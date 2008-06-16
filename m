Return-Path: <linux-kernel-owner+w=401wt.eu-S1756218AbYFPMc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218AbYFPMc6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 08:32:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234AbYFPMcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 08:32:51 -0400
Received: from sorrow.cyrius.com ([65.19.161.204]:3849 "EHLO sorrow.cyrius.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911AbYFPMcu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 08:32:50 -0400
Date: Mon, 16 Jun 2008 14:32:38 +0200
From: Martin Michlmayr <tbm@cyrius.com>
To: linux-kernel@vger.kernel.org
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, keithp@keithp.com
Subject: kernel panic when plugging in USB device and closing lid
Message-ID: <20080616123238.GA2852@deprecation.cyrius.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My HP Compaq 2510p laptop regularly locks up after I move away from my
desk and then return, plug in my USB keyboard and close the lid.  I've
now found an easy way to reproduce this:

 - Boot in single user mode
 - Plug in a USB device (e.g. keyboard or usb stick)
 - Close the lid
 - Open the lid and you see a kernel panic like this (written down by hand):

BUG: unable to handle kernel <1>BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
IP: [<ffffffff8024949f>] ktime_get_ts:0x17/0x48
PGD 7cceb067 PUD 7cd19067 PMD 0
Oops: 0000 [1] SMP
CPU 1
Module linked in: ...
... lots of register info ...
Process swapper (pid: 0, threadinfo fffff81007f3bc000, task ffff81007f3b40c0)

RIP [<ffffffff8024949f>] ktime_get_ts+0x17/x048
 RSP <ffff81007e88fb90>
CR2: 0000000000000000
---[ end trace dd6b99ae04431d83 ]--
Kernel panic -- not syncing: Attempted to kill the idle task!

This is with 2.6.25.  2.6.26-rc5 looks slightly different.  Screen shots:
http://www.cyrius.com/tmp/2.6.25.jpg
http://www.cyrius.com/tmp/2.6.26-rc5.jpg

I briefly talked to Matthew Garrett on IRC who said this "looks like
state corruption".  He asked me to set /proc/acpi/video/blah/DOS to 7
and see whether I could still reproduce the problem.  After setting
this value, I no longer see the kernel panic.  Matthew: "Right.  The
lid-close SMM seems to blow things up some of the time."

Does anyone have any idea what's going on and how to fix it?

-- 
Martin Michlmayr
http://www.cyrius.com/
