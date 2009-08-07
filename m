Return-Path: <linux-kernel-owner+w=401wt.eu-S1753459AbZHGJUB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459AbZHGJUB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 05:20:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752918AbZHGJUA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 05:20:00 -0400
Received: from smtp.nokia.com ([192.100.105.134]:61481 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709AbZHGJUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 05:20:00 -0400
Message-ID: <4A7BF1C3.4050602@nokia.com>
Date: Fri, 07 Aug 2009 12:20:03 +0300
From: Adrian Hunter <adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: JiSheng Zhang <jszhang3@gmail.com>
CC: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "dwmw2@infradead.org" <dwmw2@infradead.org>,
       "rmk@arm.linux.org.uk" <rmk@arm.linux.org.uk>,
       "Bityutskiy Artem (Nokia-D/Helsinki)" <Artem.Bityutskiy@nokia.com>
Subject: Re: [UBI UBIFS] replace vmalloc with kmalloc
References: <2df346410908070202i6c16008ckc145559a474129c6@mail.gmail.com>
In-Reply-To: <2df346410908070202i6c16008ckc145559a474129c6@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Aug 2009 09:19:34.0182 (UTC) FILETIME=[2D7A5C60:01CA1740]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

JiSheng Zhang wrote:
> If nandflash driver use DMA to support UBI and UBIFS i/o, there will
> be panic like
> the following. This is because UBI and UBIFS use vmalloced buffer
> somewhere while
> nandflash driver put the buffer under DMA and DMA support doesn't like vmalloced
> memory.
> [  412.369280] UBIFS: default file-system created
> [  412.374879] Unable to handle kernel NULL pointer dereference at
> virtual address 00000000
> [  412.383177] UBIFS: background thread "ubifs_bgt0_0" started, PID 887
> [  412.389656] pgd = c0004000
> [  412.392419] [00000000] *pgd=00000000
> [  412.396117] Internal error: Oops: 817 [#1] PREEMPT
> 
> Yes, I know kmalloc may fail when memory get fragmented, but I grep the UBI and
> UBIFS's source, there are six .c files and seven .c files using
> vmalloc, the function
> which call vmalloc are all called during the ubi being attached and
> the volume being
> mounted. In embedded system, this mainly happen during kernel boot, it
> should succeed.
> 
> After replacing vmalloc with kmalloc, ubi and ubifs runs fine on my
> board. I can alos upload
> a patch.
> 
> Comments are welcomed!

vmalloc allows large (> 128KiB) buffers, but kmalloc doesn't.
So we presently have no choice but to use vmalloc.

I do not know what hardware you have or exactly what driver you
are using, but we have UBIFS on OneNAND using DMA.
See drivers/mtd/onenand/omap2.c

