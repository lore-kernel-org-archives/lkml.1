Return-Path: <linux-kernel-owner+w=401wt.eu-S1756195AbXH0N17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195AbXH0N17 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 09:27:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753310AbXH0N1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 09:27:50 -0400
Received: from mail.gmx.net ([213.165.64.20]:53235 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753206AbXH0N1t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 09:27:49 -0400
X-Authenticated: #24879014
X-Provags-ID: V01U2FsdGVkX19SFctLjhtSQR+NcIouYBiCzSr15kYy79yZePEgU6
	OU86AzFqGEIidq
Message-ID: <46D2D0E2.9060408@gmx.net>
Date: Mon, 27 Aug 2007 15:25:54 +0200
From: Michael Kerrisk <mtk-manpages@gmx.net>
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: Nicolas George <nicolas.george@ens.fr>
CC: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net,
       jdike@linux.intel.com
Subject: Re: UML/man: BLKGETSIZE takes a long, not an int
References: <20070814092942.GA14324@clipper.ens.fr>
In-Reply-To: <20070814092942.GA14324@clipper.ens.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Nicolas,

> I fear that my bug-report yesterday was very badly written, with me writing
> to the wrong mailing-list and all.
> 
> I was saying:
> 
>> I found a type mismatch in UML that makes host block devices unusable as ubd
>> devices on x86_64 and other 64 bits systems (segfault of the mm subsystem):
>>
>> In block/ioctl.c, the following lines show that the BLKGETSIZE ioctl expects
>> a pointer to a long:
>>
>> 	case BLKGETSIZE:
>> 		if ((bdev->bd_inode->i_size >> 9) > ~0UL)
>> 			return -EFBIG;
>> 		return put_ulong(arg, bdev->bd_inode->i_size >> 9);
>>
>> In arch/um/os-Linux/file.c, os_file_size calls it with an int.
>>
>> The ioctl_list man page should be fixed as well.

manual page changed for 2.65:

--- ioctl_list.2
+++ ioctl_list.2        (working copy)
@@ -243,7 +243,7 @@
 0x0000125D  BLKROSET                   const int *
 0x0000125E  BLKROGET                   int *
 0x0000125F  BLKRRPART                  void
-0x00001260  BLKGETSIZE                 int *
+0x00001260  BLKGETSIZE                 unsigned long *
 0x00001261  BLKFLSBUF                  void
 0x00001262  BLKRASET                   int
 0x00001263  BLKRAGET                   int *

Thanks,

Michael

-- 
Michael Kerrisk
maintainer of Linux man pages Sections 2, 3, 4, 5, and 7

Want to help with man page maintenance?  Grab the latest tarball at
http://www.kernel.org/pub/linux/docs/manpages/
read the HOWTOHELP file and grep the source files for 'FIXME'.
