Return-Path: <linux-kernel-owner+w=401wt.eu-S1758797AbXFGIrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758797AbXFGIrW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 04:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753747AbXFGIrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 04:47:10 -0400
Received: from frosty.hhs.nl ([145.52.2.15]:39915 "EHLO frosty.hhs.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751776AbXFGIrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 04:47:08 -0400
X-Greylist: delayed 1271 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Jun 2007 04:47:08 EDT
Message-ID: <4667C00D.40708@hhs.nl>
Date: Thu, 07 Jun 2007 10:21:33 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
CC: vojtech@suse.cz
Subject: problem with softraw and keycodes > 128
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.2/RELEASE, bases: 07062007 #319870, status: clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

<Note: I'm not on the please keep me CC-ed>

Hi all,

First a short intro I'm a Linux enthousiast and developer. I mainly write
userspace code, but I've also written 2 kernel drivers of which one is in the
mainline and the other is waiting for review.

I've been experimenting with getting the internetkeys on several keyboards to
work. My biggest problem with this currently is the following:

Step 1: press key, dmesg says:
atkbd.c: Unknown key released (translated set 2, code 0xa3 on isa0060/serio0).
atkbd.c: Use 'setkeycodes e023 <keycode>' to make it known.

Step 2: map key: setkeycodes e023 163

Step 3: run xev, press key. X-keycode is: 153 instead of 163 ?

Problem, as the xkb files for these keyboards expect the X-keycode to be 163,
as just it is under the console. Now I know that X-keycodes !=
console-keycodes, for example the A key is 30 on the console and 38 in X, but
in the case of this special keys, both the xkb files for these internet
keyboards (written by suse) and config files for special daemons like lineak,
expect them to be identical. Doing:
echo -n 0 >/sys/devices/platform/i8042/serio1/softraw
However does make them identical.

I don't know if this is an xorg or a kernel problem, but I do know that this
behavior is rather annoying, and IMHO a bug. I've been reading the kernel code
from input.c and atkbd.c but I cannot find anything explaining this there, so
now I'm looking at the xorg kbd driver. I have the feeling though that this
require someone with some more knowledge of the whole input subsystem, hence
this mail.

<Note: I'm not on the please keep me CC-ed>

Thanks & Regards,

Hans


