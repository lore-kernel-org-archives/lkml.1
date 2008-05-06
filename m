Return-Path: <linux-kernel-owner+w=401wt.eu-S1756177AbYEFLZQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177AbYEFLZQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 07:25:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752665AbYEFLZB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 07:25:01 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:60464 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631AbYEFLZA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 07:25:00 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 36/56] microblaze_v2: dma support
Date: Tue, 6 May 2008 13:24:04 +0200
User-Agent: KMail/1.9.9
Cc: Michal Simek <monstr@seznam.cz>,
       John Williams <john.williams@petalogix.com>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       Michal Simek <monstr@monstr.eu>
References: <1209901305-6404-1-git-send-email-monstr@seznam.cz> <48202AB6.4010201@seznam.cz> <Pine.LNX.4.64.0805061317120.10091@anakin>
In-Reply-To: <Pine.LNX.4.64.0805061317120.10091@anakin>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200805061324.06282.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18tzWCDd5YOJl5xL4xeTy/5tozU5891dpt7pI8
 FSUiiQaF/3Q3RnUZPX1oXsNj1iCCP92KsDPKy6zixHUUg/somN
 z/U/dCZhkMVKk3e62oMwQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 May 2008, Geert Uytterhoeven wrote:
> > struct scatterlist {
> >       unsigned long page_link;
> >       unsigned int    offset;
> >       unsigned int    length;
> >       dma_addr_t      dma_address;
> > };
> 
> If unsigned long is 32-bit but dma_addr_t is 64-bit, there may be a gap
> between length and dma_address.
> 

But moving dma_address to the front only has the effect to create implicit
padding at the end of struct scatterlist, so you don't gain anything
either way.

It's only an internal definition that can be changed at any time without
breaking applications, so I wouldn't worry about it, and better leave
it identical to the other architectures.

The one thing that should indeed be changed is the addition of
'unsigned long sg_magic' that is needed for CONFIG_DEBUG_SG.

	Arnd <><
