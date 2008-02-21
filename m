Return-Path: <linux-kernel-owner+w=401wt.eu-S1765062AbYBUNu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765062AbYBUNu6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 08:50:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756897AbYBUNur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 08:50:47 -0500
Received: from smtp2.sssup.it ([193.205.80.100]:51312 "EHLO smpt2.sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758411AbYBUNuq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 08:50:46 -0500
Message-ID: <47BD81A6.7080009@gandalf.sssup.it>
Date: Thu, 21 Feb 2008 14:50:30 +0100
From: michael <trimarchi@gandalf.sssup.it>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: linux-mtd@lists.infradead.org,
       Michael Trimarchi <trimarchimichael@yahoo.it>,
       linux-kernel@vger.kernel.org
Subject: [Fwd: Re: JFFS2 as rootfs on DataFlash]
Content-Type: multipart/mixed;
 boundary="------------090709040409060806070606"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090709040409060806070606
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit



--------------090709040409060806070606
Content-Type: message/rfc822;
 name="Re: JFFS2 as rootfs on DataFlash"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="Re: JFFS2 as rootfs on DataFlash"

Message-ID: <47BBE67B.6030804@gandalf.sssup.it>
Date: Wed, 20 Feb 2008 09:36:11 +0100
From: michael <trimarchi@gandalf.sssup.it>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: Ulf Samuelsson <ulf.samuelsson@atmel.com>
Subject: Re: JFFS2 as rootfs on DataFlash
References: <109598.62836.qm@web50805.mail.re2.yahoo.com> <20080219163821.gmq5orqmcksgo8wg@feanor.sssup.it> <012b01c8735a$3c946c30$050514ac@atmel.com>
In-Reply-To: <012b01c8735a$3c946c30$050514ac@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

hi,
> I have build JFFS2 for dataflash using buildroot.
> It was some time ago though.
>
> You do need to have the -s 0x210 and -e 0x2100.
> Note that using old mtd S/W will break the JFFS2,
> since old MTD assumes that pages are 2^n.
>
> You need to fix the mtd S/W in the linux kernel/root fs
> AND you need to change the mtd used to generate the file system.
>
>   
I'm using the 2.6.24 tree. Take a look:

 Inode      node at 0x00002724, totlen 0x00000115, #ino     21, 
version    16, isize   461972, csize      209, dsize     1056, offset    
14784
         Inode      node at 0x0000283c, totlen 0x00000117, #ino     21, 
version    17, isize   461972, csize      211, dsize     1056, offset    
15840
         Inode      node at 0x00002954, totlen 0x00000334, #ino     21, 
version    18, isize   461972, csize      752, dsize     1056, offset    
16896

This a short dump of an image create with mkfs.jffs2 using your setting.

Inode      node at 0x002a8ae8, totlen 0x000007a6, #ino    700, 
version     4, isize     8192, csize     1890, dsize     4096, 
offset     4096
         Inode      node at 0x002a9290, totlen 0x00000607, #ino    700, 
version     5, isize    12288, csize     1475, dsize     4096, 
offset     8192
         Inode      node at 0x002a9898, totlen 0x00000549, #ino    700, 
version     6, isize    16384, csize     1285, dsize     4096, offset    
12288
         Inode      node at 0x002a9de4, totlen 0x000006b7, #ino    700, 
version     7, isize    20480, csize     1651, dsize     4096, offset    
16384

This is created by linux, filling it just copy file.

    Inode      node at 0x00042000, totlen 0x00000a40, #ino     21, 
version    75, isize   461972, csize     2556, dsize     4096, offset   
229376
         Inode      node at 0x00042a40, totlen 0x00000abe, #ino     21, 
version    76, isize   461972, csize     2682, dsize     4096, offset   
233472
         Inode      node at 0x00043500, totlen 0x00000363, #ino     21, 
version    77, isize   461972, csize      799, dsize      986, offset   
237568
This is created by me using only the erase blocksize.

As you can see the inode data can be 4096 and it is wrong to have 1056.

Regards Michael



--------------090709040409060806070606--
