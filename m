Return-Path: <linux-kernel-owner+w=401wt.eu-S1755373AbYEMJpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373AbYEMJpa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 05:45:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751655AbYEMJpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 05:45:18 -0400
Received: from nef2.ens.fr ([129.199.96.40]:3137 "EHLO nef2.ens.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751613AbYEMJpR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 05:45:17 -0400
X-Greylist: delayed 949 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 May 2008 05:45:17 EDT
Date: Tue, 13 May 2008 11:27:35 +0200
From: Eric.Brunet@lps.ens.fr
To: Linux Kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Bug with keyboard input
Message-ID: <20080513092735.GA32087@platane.lps.ens.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.1.4 (nef2.ens.fr [129.199.96.32]); Tue, 13 May 2008 11:29:26 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi list,

With uptodate Fedora 7 (kernel kernel-2.6.23.15-80.fc7) on a Dell D430
laptop.

In short, if I do
	echo -n "i8042" > /sys/bus/platform/drivers/i8042/unbind
followed by
	echo -n "i8042" > /sys/bus/platform/drivers/i8042/bind
everything works fine, EXCEPT if I hit a key on the keyboard between the
unbind and the bind (tested with leftcontrol and spacebar). If I hit a
key, it looks like the keyboard isn't taking release events anymore and
the next key I hit is forever repeated. When my keyboard is in its working
state, I read
	N: Name="AT Translated Set 2 keyboard"
in /proc/bus/input/devices. When it is in its non-working state (I hit a
key between unbind and bind), I read
	N: Name="AT Raw Set 2 keyboard"
in the same file, and each time I hit a key, I have messages such as
    atkbd.c: Unknown key pressed (raw set 2, code 0x11f on isa0060/serio0).
    atkbd.c: Use 'setkeycodes 1f <keycode>' to make it known.
    atkbd.c: Unknown key pressed (raw set 2, code 0x11e on isa0060/serio0).
    atkbd.c: Use 'setkeycodes 1e <keycode>' to make it known.
in my logs.

Note that the key doesn't have to be pressed while the bind happens, it
is sufficient that the key have been pressed and released before the
bind.

So, is there a way to make it work and have the input layer automatically
recognize the correct keyboard type or keyboard mode ? If not, is there a
way to keep it from guessing and to force it to treat the keyboard as an
"AT Translated Set 2 keyboard" ?

As a final note, I get hit by this bug quite often during suspend/resume
cycles. I had found that the keyboard wasn't all the time properly waking up,
(it was getting stuck) so I've added a file in /etc/pm/sleep.d to do the
unbind at suspend time and the bind at resume time. This fixed my
problem, except that at times I stupidly press a key in the hope that the
resume is done and that the screen is black only because of the
screensaver, and that hitting a key will make appear the unlocking
window...

Thanks,

	Éric Brunet
