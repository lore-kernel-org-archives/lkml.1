Return-Path: <linux-kernel-owner+w=401wt.eu-S1753248AbZHGJPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248AbZHGJPA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 05:15:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752709AbZHGJPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 05:15:00 -0400
Received: from co203.xi-lite.net ([149.6.83.203]:33822 "EHLO co203.xi-lite.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751925AbZHGJO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 05:14:59 -0400
Message-ID: <4A7BF091.5040605@parrot.com>
Date: Fri, 7 Aug 2009 11:14:57 +0200
From: Matthieu CASTET <matthieu.castet@parrot.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: JiSheng Zhang <jszhang3@gmail.com>
CC: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
       "Artem.Bityutskiy@nokia.com" <Artem.Bityutskiy@nokia.com>,
       "dwmw2@infradead.org" <dwmw2@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "rmk@arm.linux.org.uk" <rmk@arm.linux.org.uk>,
       "adrian.hunter@nokia.com" <adrian.hunter@nokia.com>
Subject: Re: [UBI UBIFS] replace vmalloc with kmalloc
References: <2df346410908070202i6c16008ckc145559a474129c6@mail.gmail.com>
In-Reply-To: <2df346410908070202i6c16008ckc145559a474129c6@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

JiSheng Zhang a écrit :
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
> 
mtd is not DMA safe. So patching UBI and UBIFS is not enought.


Matthieu
