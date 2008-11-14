Return-Path: <linux-kernel-owner+w=401wt.eu-S1753812AbYKNMbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812AbYKNMbY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 07:31:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751345AbYKNMbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 07:31:15 -0500
Received: from mail.ukfsn.org ([77.75.108.10]:46987 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751424AbYKNMbO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 07:31:14 -0500
Date: Fri, 14 Nov 2008 12:30:58 +0000
From: Nick Warne <nick@ukfsn.org>
To: linux-kernel@vger.kernel.org
Subject: i8046:  unbind/bind issue with laptop system password set
Message-ID: <20081114123058.4e7db857@palantir.linicks.net>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This is a strange one.  My laptop, a Dell Inspiron 6400 (UK model
MM061) has a BIOS option to set system password that is required on
boot/reboot/and on waking up from suspend to RAM (sleep).

This works fine, but after I enter my password during resume, I find
my keyboard has gone AWOL (no keys mapped, all keys auto repeat etc.)
and shortly mouse buttons die too... so all I can do now is hit the
power off button!

log/messages spews out lots of this stuff:
Nov 14 11:36:36 palantir kernel: [10330.783152] atkbd.c: Unknown key pressed (raw set 2, code 0x28 on isa0060/serio0).
Nov 14 11:36:36 palantir kernel: [10330.783164] atkbd.c: Use 'setkeycodes 28 <keycode>' to make it known.
Nov 14 11:36:37 palantir kernel: [10330.855664] atkbd.c: Unknown key pressed (raw set 2, code 0x128 on isa0060/serio0).
Nov 14 11:36:37 palantir kernel: [10330.855676] atkbd.c: Use 'setkeycodes 28 <keycode>' to make it known

I have invested this, and one difference I notice in log/messages
during resume activity is this:

WITHOUT system password required:
input: AT Translated Set 2 keyboard
as /devices/platform/i8042/serio0/input/input1

WITH system password required:
input: AT Raw Set 2 keyboard as /devices/platform/i8042/serio16/input/input45

Now, investigating further, I have found that I can replicate this whole issue with this script:

#!/bin/sh
echo -n "i8042" > /sys/bus/platform/drivers/i8042/unbind
sleep 5;
echo -n "i8042" > /sys/bus/platform/drivers/i8042/bind

if I hit a key during the sleep stage, the keyboard et al all goes AWOL again.

So, I am presuming here that when my laptop gets woken up, the BIOS system password screen comes, and the /etc/acpi/resume.d/ scripts are being held in stasis until I enter the password.  BUT, I have then used the keyboard before i8042 is echoed to 'bind', and this causes the issue.  Without the system password set, the scipts perhaps run fast enough before I can hit the keyboard in this keyboard state.

One reference I found with similar problem:

http://kerneltrap.org/mailarchive/linux-kernel/2008/5/13/1805874

Thanks,

Nick

-- 
Free Software Foundation Associate Member 5508
