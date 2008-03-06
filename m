Return-Path: <linux-kernel-owner+w=401wt.eu-S933522AbYCFMl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933522AbYCFMl7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 07:41:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756999AbYCFMlv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 07:41:51 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:37261 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755475AbYCFMlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 07:41:51 -0500
Subject: Re: [PATCH] Modify loop device to be able to manage partitions of
	the disk image
From: Laurent Vivier <Laurent.Vivier@bull.net>
To: =?ISO-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <47CFE1B9.1080405@draigBrady.com>
References: <1204796612842-git-send-email-Laurent.Vivier@bull.net>
	 <47CFD6B0.4020602@draigBrady.com> <1204803914.4325.16.camel@frecb07144>
	 <47CFE1B9.1080405@draigBrady.com>
Content-Type: text/plain; charset=utf-8
Organization: Bull S.A.S.
Date: Thu, 06 Mar 2008 13:44:11 +0100
Message-Id: <1204807451.4325.28.camel@frecb07144>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Le jeudi 06 mars 2008 à 12:21 +0000, Pádraig Brady a écrit :
> Laurent Vivier wrote:
> > Le jeudi 06 mars 2008 à 11:34 +0000, Pádraig Brady a écrit :
> >> Laurent Vivier wrote:
> >>> This patch allows to use loop device with partitionned disk image.
> >>>
> >>> Original behavior of loop is not modified.
> >>>
> >>> A new parameter is introduced to define how many partition we want to be
> >>> able to manage per loop device. This parameter is "max_part".
> >> I like it!
> > 
> > Thanks,
> > 
> >> Shouldn't we set max_part to non zero by default though?
> > 
> > Well, the problem is that you modify the default minor number of loop
> > device if max_part != 0, so I'm afraid of compatibility problems:
> 
> I understand that. But who would care about specific minor numbers?

Well, in some case I care about the minor number.

Normally, device name is meaningless, i.e. you can call the device as
you want, the real information comes from the inode, the major number
for the driver, and the minor number as a parameter for the driver. For
instance, if I have a device node and I want to know if it is a SCSI
disk or an ATA disk I make a fstat() and I look at the major number, if
I want to know if it is the first disk or the second, a partition or
not, I look at the minor number.

> Hmm how does your patch relate to this: http://lwn.net/Articles/110426/

I didn't know this one but it is very similar.

> As an aside, I also notice on my system from the following output that
> the limit of the number of partitions for a sata/scsi disk seems to be 15:
> 
> $ ls -la /dev/sd[ab]
> brw-rw---- 1 root disk    8,  0 2007-11-13 10:35 /dev/sda
> brw-rw---- 1 root plugdev 8, 16 2008-03-06 12:11 /dev/sdb

For the scsi disk, the minor number contains the disk number and the
partition number, if I remember correctly originally minor number were 8
bits (it is not the case now I believe), and SCSI disk id can be from 0
to 15 (4 bits) so it lets only 4 bits for partition number (15
partitions)

Regards,
Laurent
-- 
----------------- Laurent.Vivier@bull.net  ------------------
"Programmers who subconsciously view themselves as artists
 will enjoy what they do and will do it better." D. Knuth

