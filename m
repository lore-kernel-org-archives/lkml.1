Return-Path: <linux-kernel-owner+w=401wt.eu-S1755583AbZIJKb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583AbZIJKb1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 06:31:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755533AbZIJKb0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 06:31:26 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:33317 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755472AbZIJKbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 06:31:25 -0400
Date: Thu, 10 Sep 2009 12:31:26 +0200
From: Andreas Mohr <andi@lisas.de>
To: linux-input@vger.kernel.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org
Subject: 2.6.31-rc6 (yeah, I know...): weird tty / X.org state currently
Message-ID: <20090910103126.GA17742@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

forgive me for posting about such an ancient version,
but I'm facing very weird control key state issues here
(or would they be related to the recent tty layer issues?)
that I deem to be worth posting about.

Yesterday I had a full lockup of my keyboard in X.org.
(note that this might be related to very ugly block layer lockups,
in worst-case scenarios even mouse cursor stuck up to a whole _minute_
in case of heavier traffic on this el-cheapo PATA SSD).

[ # CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set ]

And somehow I have a hunch that these unusual and very large latencies
may have played a role in suddenly having the keyboard lock up completely
in X.org.
Nothing helped, neither changing display device configuration (this
did help in other environments!), nor fiddling with KDE accessibility
abominations, nor fiddling with keyboard / mouse settings in KDE
systemsettings.
X.org keyboard stayed stuck solidly, only going down to other ttys worked
just fine.

But the kicker happened when I restarted kdm to restore my keyboard!
While this worked, in the new session I observed _very_ strange
behaviour:

In konsole, normal letters and control key combinations (Ctrl-l vs. l)
worked absolutely fine, but typing such normal things as Alt-Left or Alt-F2 or
Alt-F4 went down to ttys(!!). IOW, the kernel's control key status was stuck
but not stuck.
Once in a text tty, the control key status was sane _as well_, IOW no
Ctrl-l behaviour when simply typing an l.

Possibly the kernel's control key state got stuck in a weird state,
perhaps due to some input layer race conditions or so.

Or is it X.org's input handling which is responsible for Ctrl-Alt-F1
etc. combos? I wouldn't think so...

Ah wait, probably it's not any control key state mismatch, but there's
probably simply a "any graphical tty additionally has a Ctrl-key
requirement to lock against tty changes" flag which is BROKEN (disabled)
in the case of my currently running(!) GUI tty session.
(go fetch any bug analysis while they're hot! ;)

Aspire One netbook, u9.04, 2.6.31-rc6 (not upgradeable at this instant).

00:02.1 Display controller: Intel Corporation Mobile 945GM/GMS/GME,
943/940GML Express Integrated Graphics Controller (rev 03)

ii  xserver-xorg-input-evdev                   1:2.1.1-1ubuntu4		X.Org X server -- evdev input driver
ii  xserver-xorg-input-kbd                     1:1.3.1-2ubuntu1		X.Org X server -- keyboard input driver
ii  xserver-xorg-input-mouse                   1:1.4.0-1 X.Org		X server -- mouse input driver
ii  xserver-xorg-input-synaptics               0.99.3-2ubuntu4		Synaptics TouchPad driver for X.Org/XFree86 server
ii  xserver-xorg                               1:7.4~5ubuntu18		the X.Org X server

Thanks,

Andreas Mohr
