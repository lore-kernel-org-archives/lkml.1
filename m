Return-Path: <linux-kernel-owner+w=401wt.eu-S1754087AbZHCSfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087AbZHCSfl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 14:35:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753409AbZHCSfk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 14:35:40 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:61219 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753351AbZHCSfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 14:35:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC 0/2] new kfifo API
Date: Mon, 3 Aug 2009 20:35:13 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-3-generic; KDE/4.2.98; x86_64; ; )
Cc: Stefani Seibold <stefani@seibold.net>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <1249306755.8358.8.camel@wall-e> <87skg8u51n.fsf@basil.nowhere.org>
In-Reply-To: <87skg8u51n.fsf@basil.nowhere.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908032035.13874.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19BD0a7k0iapmnnqjRvYUzobsEvQRZ5/edkh0o
 3SUfhTcobnTKudcvZwaA5LkQZJc6Dme+FwKZECfeD6ZIoZqf21
 YWDYwAvmyxJ2yg8SVPsYM4MtDQdIFM6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 August 2009, Andi Kleen wrote:
> > struct kfifo *kfifo_alloc(unsigned long size, gfp_t gfp_mask)
> >  Dynamically allocates a new fifo and returns the address
> >  @size: the size of the internal buffer to be allocated.
> >  @gfp_mask: get_free_pages mask, passed to kmalloc()
> 
> For the MCE use case this would need to be able to optionally use
> bootmem because the first initialization happens too early.

The existing API has a kfifo_init for that purpose, so you can
pass a preallocated (bootmem, static, coherent, aligned, ...) buffer
into the FIFO.

That might be nice to keep, by leaving the 'buffer' as pointer
in struct kfifo, which could still point to a buffer that is
allocated together with the structu kfifo.

	Arnd <><
