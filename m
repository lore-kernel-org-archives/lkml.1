Return-Path: <linux-kernel-owner+w=401wt.eu-S1755348AbYLVNRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348AbYLVNRU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 08:17:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754254AbYLVNRL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 08:17:11 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:10183 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753697AbYLVNRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 08:17:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=RXKj7vwx6XsiDe3k/OPZpMx2Z2zr1OdaEh90lITQZ9B9XibZTX5id2jgZVtoVsirtp
         3HF8Uuc1gCGkryhiC+QH6aS8JW+/dHYTgy/m8lv29ivgyQpMJL+mcOpMizZMXqU2u0y1
         mD9OOR8BlQVl4rdvkVje6V88swnts1jdBYFpE=
Message-ID: <494F9354.2070701@gmail.com>
Date: Mon, 22 Dec 2008 14:17:08 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-input@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: frequent hangs
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am experiencing frequent (twice in 4 boots) hangs on my PC, just after
entering X. Sometimes there is no problem and the PC starts up fine and keeps
working normally. It seems to happen during boot only.

Hangs are: mouse first responds wildly, then stops working altogether as well as
the keyboard.

I compared diffs of /var/log/Xorg.0.log.old and /var/log/Xorg.0.log twice after
hangs and noted these extra lines (with +) both times when boot was OK:

 enable montype: 1
+enable montype: 1
+(II) 3rd Button detected: disabling emulate3Button

I have a Logitech PS/2 wheel mouse. As normally I found in my dmesg:

mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input0
input: PS2++ Logitech Wheel Mouse as /class/input/input1
input: Power Button (FF) as /class/input/input2
input: Power Button (CM) as /class/input/input3

I compile a Linus git-pulled kernel with a .config that I do not change often
and normally works. It seems that kernel changes somewhere between May and
December 2008 caused this, I didn't compile new kernels a lot in this period.

After reboot I noted (suspected to be related):
Sound signals
processor Clock settings altered



A possibly related issue is that sometimes (about once every month) my mouse
doesn't work when entering X. (I have sent an email previously for this).

cat /dev/input/mice doesn't give strange characters when moving my mouse

I stored dmesg when there was trouble:

twice dmesg contained:
psmouse.c: Failed to enable mouse on isa0060/serio1

4 other times missing was:
input: PS2++ Logitech Wheel Mouse as /class/input/input1

and instead:
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input0
input: Power Button (FF) as /class/input/input1
input: Power Button (CM) as /class/input/input2

(in earlier dmesgs "/class" was "/devices/virtual".
or /devices/platform/i8042/serio[10]/)

Roel
