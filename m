Return-Path: <linux-kernel-owner+w=401wt.eu-S1764557AbYEFPhR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764557AbYEFPhR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 11:37:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759501AbYEFPhD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 11:37:03 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:60066 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755992AbYEFPhB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 11:37:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@seznam.cz
Subject: Re: [PATCH 36/56] microblaze_v2: dma support
Date: Tue, 6 May 2008 17:36:16 +0200
User-Agent: KMail/1.9.9
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       John Williams <john.williams@petalogix.com>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca
References: <1209901305-6404-1-git-send-email-monstr@seznam.cz> <200805061324.06282.arnd@arndb.de> <48205B0D.70202@seznam.cz>
In-Reply-To: <48205B0D.70202@seznam.cz>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200805061736.18180.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+/3gr56wXKOIgyPuvwIBo2QHvrwAWKOMhzUBu
 Ri+CaqSv196+qXeAUXyS5LKtmJw/bOlfzShUU1WHbCBD5C5rdS
 QdEexOYVenT3efwNw7xQw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 May 2008, Michal Simek wrote:
> here is proposed struct.
> 
> struct scatterlist {
>       dma_addr_t        dma_address;
>       unsigned long     page_link;
> #ifdef CONFIG_DEBUG_SG
>       unsigned long     sg_magic;
> #endif
>       unsigned int      length;
>       unsigned int      offset;
> };
> 
> Is it OK now?

Everyone else has the sg_magic first, which makes sense for debugging.
Don't worry about it too much, just use the same code as avr32, h8300,
blackfin, fvr, mk68knommu, mn10300, sh, v850 and xtensa.

These are all the same, but I just saw that they also have

#define sg_dma_address(sg)      ((sg)->dma_address)
#define sg_dma_len(sg)          ((sg)->length)

which you probably want as well.

	Arnd <><
