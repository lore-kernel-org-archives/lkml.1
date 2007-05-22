Return-Path: <linux-kernel-owner+w=401wt.eu-S1763504AbXEVVQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763504AbXEVVQa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 17:16:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760215AbXEVVQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 17:16:13 -0400
Received: from nicole.bmts.com ([216.183.128.225]:33892 "EHLO nicole.bmts.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759586AbXEVVQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 17:16:11 -0400
Date: Tue, 22 May 2007 18:14:44 -0400
From: Mike Houston <mikeserv@bmts.com>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.22-rc2
Message-Id: <20070522181444.ad932718.mikeserv@bmts.com>
In-Reply-To: <20070521213146.3e220a44@freepuppy>
References: <alpine.LFD.0.98.0705182209030.3890@woody.linux-foundation.org>
	<20070520170506.814a38d9.mikeserv@bmts.com>
	<20070521084549.61a1aa71@freepuppy>
	<20070521131055.0017404f.mikeserv@bmts.com>
	<20070521103755.51b954e1@freepuppy>
	<20070521225806.bb18d589.mikeserv@bmts.com>
	<20070521213146.3e220a44@freepuppy>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-brucetelecom.com-MailScanner-Information: Please contact Bruce Telecom 519.368.2000 for more information
X-brucetelecom.com-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-brucetelecom.com-MailScanner-From: mikeserv@bmts.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 May 2007 21:31:46 -0700
Stephen Hemminger <shemminger@linux-foundation.org> wrote:

> There maybe some hardware level interaction with SATA controller.
> I saw no failures running off i386 kernel of PATA drive and quickly
> see errors with SATA/AHCI and x86_64.

AHCI SATA on i386, but I'm not sure that has anything to do with the
problem after what follows below.

I did another test here today. I disconnected my SATA hard disks and
installed a regular PATA drive. The only PATA port I have though, is
on the jmicron 363 controller. So I enabled that controller in the
bios (I keep it disabled because I have no use for it) and installed a
distro on the drive. PCLinuxOS TR4, which probably isn't the best test
system to use (and is not for me), but it's the only one I had on hand
that recognized IDE disks on the jmicron 363 controller with the
distro kernel.

After the install was done, I disconnected the SATA CD drive so there
would be no SATA devices. Nothing was on the ICH8 controller, which
I had put in IDE mode. (no setting to disable it entirely in bios)

I compiled 2.6.22-rc2 without libata/SATA support and only enabled the
old IDE subsystem with the jmicron 36x driver.

2.6.22-rc2 kernel was working well, and I brought up the sky2 eth0
interface alright, and as is the case most of the time (but not
always), I was able to do light stuff with it for a short time (e.g.
ssh in to another box, transfer a small text file etc.) but as soon
as I start trying to move any serious data the same or similar
problem occurs.

The only device using MSI at the time was the sky2, if that's
relevant. There were no other ethernet cards installed at the
time either.

In this case I actually had the kernel crash. First time for me ever
having a kernel oops! System locked up with keyboard LED's blinking.

Not sure if anyone wants to see all of it (maybe some screwy
userland stuff involved), so I won't include that mess in the
message. It's here:
http://www.mikeserv.org/files/kernelcrash.txt

But in there we get this, a somewhat similar message:

May 22 16:16:45 localhost kernel: sky2 0000:04:00.0: error interrupt
status=0x1
May 22 16:16:45 localhost kernel: sky2 eth0: descriptor error q=0x280
get=285 [800042375e2e5e] put=285

I hard booted and tried again a second time, and this time the kernel
didn't oops but I got this:

May 22 16:34:09 testinstall kernel: sky2 0000:04:00.0: error
interrupt status=0x1
May 22 16:34:09 testinstall kernel: sky2 eth0:
descriptor error q=0x280 get=497 [800042367dde5e] put=497
May 22 16:34:09 testinstall kernel: sky2 0000:04:00.0: error interrupt
status=0x80000000
May 22 16:34:09 testinstall kernel: sky2 eth0: hw error interrupt
status 0x8
May 22 16:34:09 testinstall kernel: sky2
eth0: MAC parity error

So it's the same problem. On halting, I quickly saw what looked like
a kernel oops but nothing was logged at that stage.

Third try was the kernel oops again on attempting to transfer a file.

By the way, last night I did grab the dmesg output from the last
attempt to use sky2 on my normal (from scratch) system in case it
would be useful. This is not to be confused with the PATA experiment
above:
http://www.mikeserv.org/files/dmesg-2.6.22-rc2.txt

Mike Houston
