Return-Path: <linux-kernel-owner+w=401wt.eu-S1757571AbYBOVqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757571AbYBOVqW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 16:46:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753465AbYBOVqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 16:46:14 -0500
Received: from ti-out-0910.google.com ([209.85.142.185]:29195 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655AbYBOVqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 16:46:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:content-type:content-transfer-encoding;
        b=NOlLQh1dbSTZp7p8bbLCZTsKpZMfOk2sNfh+3ccBoOq2LJbX5u0SMNBeAbEN8UARNC6pFWpHlgAjFPdedk3m1Y3EXDkZir6ds79b8ipCe6OlLeGGYdEqflyZd4gtyDJbs30cX3GTx0bJU7FhPDeW/uoqa5hw73nm5jSDNzAeulc=
Message-ID: <47B60812.4050206@gmail.com>
Date: Fri, 15 Feb 2008 16:45:54 -0500
From: Andrew Buehler <abuehler.kernel@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: USB regression (and other failures) in 2.6.2[45]*
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In my workplace, I use a customized version of Novell's ZENworks imaging
boot CD, which is based off of Linux. I have one particular model of
laptop - the IBM/Lenovo R61 - on which three different things fail
completely in current kernels (tested with 2.6.24.2 and 2.6.25-rc1):
USB, AHCI (and thus access to the SATA drive), and networking. As a
consequence of all three failing in parallel, I have no practical way to
get logs and other information off of the machine to help with tracking
down the bugs.

I am primarily concerned about the AHCI and networking issues, since
they are what need to be working in order for us to do what we need to
with these boot discs and these laptops. However, I intend to focus on
the USB issue first, because it seems slightly more tractable and fixing
it would allow me to reliably get logs off of the computer so as to
provide information to help track down and fix the other problems.

Specifically, the USB issue is more tractable in that I have found one
narrow set of circumstances in which I *can* get it to work, and so have
been able to obtain an lspci log and a dmesg log from the failing
laptop. I seem to remember the lkml FAQ advising not to simply attach
such files unsolicited, so I have not provided them here, but I am more
than willing to send them (and the matching .config file) along upon
request. Instead, I will do my best to summarize the errors as I have
observed them, though that best may be somewhat poor. In the following,
unless explicitly specified, I am using 2.6.25-rc1, simply because I
expect that it will be more likely to get attention and fixes than
earlier (released) versions.


Early in the boot process, immediately after the 'io scheduler foobar
registered' lines, the message

====
0000:00:1a.7 EHCI: BIOS handoff failed (BIOS bug?) 01010001
====

appears twice. Despite the parenthetical suggestion, I do not believe
that the problem could be a bug in the BIOS, because Windows is able to
access all of the hardware on these laptops - including USB devices,
which is what I understand EHCI to involve - without the slightest
difficulty.

If there is no USB Flash drive is connected during the boot process,
there are no further apparently-USB-related errors during boot that I
can recognize, and various messages about USB host controllers being
detected appear; they seem to be perfectly normal. When the boot process
completes, connecting such a drive produces no visible response
whatsoever.

If on the other hand there *is* a USB Flash drive connected during the
boot process, there are many other USB-related messages, some of which
appear to be errors. I am not certain which are in fact relevant, and
would prefer not to simply copy-and-paste blindly from the log; if the
information is necessary, I would prefer to simply provide the entire
log rather than risk missing something important. However, when the boot
process is done and the usb-storage module is loaded, the drive is in
fact recognized and can be mounted, though it is very slow to respond;
in my one test it took ~20+ seconds to mount the drive (512MB, vfat), an
unmeasured but quite long time to dump dmesg into a file on that drive,
a barely noticeable but still present blink to copy /proc/config.gz to
the drive, and four seconds to unmount afterwards.


For reference, I have on hand a version of this same boot disc built
using kernel 2.6.23.1, which does not produce the EHCI errors, and on
which the USB drive is usable in exactly the way I expect from a Linux
system. I have not made a significant attempt to narrow down the point
at which the functionality broke, but I can do so if desired, though it
will take some time - the more so as I can test this only while at work,
and am facing an impending three-day weekend.

(I do not have a working git environment, and do not understand well how
to set one up, as the mechanics and to some extent the interface
semantics of git seem to be rather different from those of any VCS with
which I am familiar. That is, however, the only reason - aside from the
time involved - why I would be unwilling to track down the exact change
which caused the regression.)

I am quite certain that I have not provided enough information to
address the problem. Please let me know what would be necessary, and I
will do my best to provide it. Additionally, if I have made any major
flubs (of etiquette or otherwise), please do point them out so that I
can avoid them in future.

-- 
    Andrew Buehler
