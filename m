Return-Path: <linux-kernel-owner+w=401wt.eu-S1764096AbXFRQAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764096AbXFRQAb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 12:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754065AbXFRQAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 12:00:23 -0400
Received: from main.gmane.org ([80.91.229.2]:33230 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932AbXFRQAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 12:00:22 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Anthony Liguori <anthony@codemonkey.ws>
Subject: Re: QEMU's scsi controller no longer works on arm.
Date: Mon, 18 Jun 2007 09:17:55 -0500
Message-ID: <f5646j$v5u$1@sea.gmane.org>
References: <200706171420.31003.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: cpe-97-99-112-55.austin.res.rr.com
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
In-Reply-To: <200706171420.31003.rob@landley.net>
Cc: linux-arm-kernel@lists.arm.linux.org.uk
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Landley wrote:
> In 2.6.20, I can boot an arm kernel up to a shell prompt including a virtual 
> scsi hard drive.  In 2.6.21-rc1, this stopped working.
>

It's broken with x86 too.  I looked into it for a bit and it appears 
that the Linux driver is using more LSI commands than it was before. 
The odd thing is that it's probing some space that is marked reserved in 
the LSI manual.  Unfortunately, I couldn't understand the SCSI system 
well enough to understand what changed in Linux.

Regards,

Anthony Liguori

> I tried "git bisect" and found out there's a range of about 5000 commits 
> between the two where arm doesn't compile.  At the start of this range, the 
> controller worked.  At the end, it didn't anymore.
> 
> How can YOU reproduce this problem?  I'm glad you asked:
> 
> The miniconfig I'm using is attached.  You'll need an arm compiler to build 
> it, of course.  (If you haven't got one, the cross compiler I made is 
> at "http://landley.net/code/firmware/downloads/cross-compiler/".  Download 
> the armv4l version for the appropriate host, extract the tarball and add 
> the "bin" directory under that to your path.  The x86 version should work on 
> Ubuntu 6.06 or newer, the x86-64 version was built on 7.04.)
> 
> Configure with:
> 
> make ARCH=arm allnoconfig KCONFIG_ALLCONFIG=miniconfig-linux
> make ARCH=arm CROSS_COMPILE=armv4l-
> 
> And then run qemu on it:
> 
> qemu-system-arm -M versatilepb -nographic -no-reboot \
>   -hda /dev/null -kernel zImage-armv4l -append \
>   'rw panic=1 root=/dev/sdaconsole=ttyAMA0'
> 
> The failing system will loop resetting the scsi controller with lots of 
> timeouts, and takes several minutes to get the the panic where it can't mount 
> root.  The working system will panic due to root being /dev/null fairly 
> quickly, without pages of error messages and a very long wait first.
> 
> Rob

