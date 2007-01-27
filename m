Return-Path: <linux-kernel-owner+w=401wt.eu-S932071AbXA0VAT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071AbXA0VAT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 16:00:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932074AbXA0VAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 16:00:19 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:54001 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932071AbXA0VAR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 16:00:17 -0500
Date: Sat, 27 Jan 2007 21:59:57 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Marc Perkel <mperkel@yahoo.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Raid 10 question/problem [ot]
In-Reply-To: <197171.96132.qm@web52509.mail.yahoo.com>
Message-ID: <Pine.LNX.4.61.0701272138030.22295@yvahk01.tjqt.qr>
References: <197171.96132.qm@web52509.mail.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 27 2007 10:42, Marc Perkel wrote:
>> >
>> >I'm using Fedora Core 6. /dev/md0 and /dev/md1, buth of which are raid
>> >1 arrays survive the reboot. But when I make a raid 0 out of those two
>> >raid arrays that's what is vanishing.
>> 
>> That's interesting. I am using Aurora Corona [FC6+RHide], and all but
>> md0 vanishes. (Reason for that is that udev does not create the nodes
>> md1-md31 on boot, so mdadm cannot assemble the arrays.)
>
>What do you have to do to get UDEV to create /dev/md2? Is there a config
>file for that?

That's the big question. On openSUSE 10.2, all the md devices get created
automatically. I suppose that happens as part of udev processing all the
queued kernel events at bootup.

On default FC6 install (i.e. without any raid), only /dev/md0 is present
(like in Aurora). That alone, and that you got md1 there, and I don't, is
strange.

I think I found it. udev does not do md at all, for some reason.
This line in /etc/rc.d/rc.sysinit is quite "offending":

[ -x /sbin/nash ] && echo "raidautorun /dev/md0" | nash --quiet

Starting a init=/bin/bash prompt and doing "/usr/sbin/udevmonitor &" 
there reveals:

bash-3.1# echo raidautorun /dev/md0 | /sbin/nash --quiet
UEVENT[1169934663.372139] add@/block/md0
bash-3.1# echo raidautorun /dev/md1 | /sbin/nash --quiet
UEVENT[1169934667.601027] add@/block/md1

No sign of md1. (Wtf here!) I can see why it's broken, but to nash every 
md device sounds like the worst solution around. I'd say the Fedora boot 
process is severely broken wrt. md. Well, what's your rc.sysinit looking 
like, since you seem to be having a md1 floating around?



	-`J'
-- 
