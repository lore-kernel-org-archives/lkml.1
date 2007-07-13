Return-Path: <linux-kernel-owner+w=401wt.eu-S933960AbXGMNp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933960AbXGMNp4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 09:45:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932093AbXGMNpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 09:45:41 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:48475 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759236AbXGMNpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 09:45:39 -0400
Date: Fri, 13 Jul 2007 15:45:37 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: James Bottomley <James.Bottomley@SteelEye.com>
cc: Jens Axboe <jens.axboe@oracle.com>, Paul Mackerras <paulus@samba.org>,
       Alessandro Rubini <rubini@vision.unipv.it>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       Geoff Levand <geoffrey.levand@am.sony.com>
Subject: Re: [patch 5/6] ps3: BD/DVD/CD-ROM Storage Driver
In-Reply-To: <1184333670.3402.17.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.62.0707131541150.18802@pademelon.sonytel.be>
References: <20070704132212.726923000@pademelon.sonytel.be>
 <20070704132346.591348000@pademelon.sonytel.be> <1184331741.3402.13.camel@localhost.localdomain>
 <20070713130508.GQ5328@kernel.dk> <Pine.LNX.4.62.0707131518120.18802@pademelon.sonytel.be>
 <1184333670.3402.17.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584337861-427551646-1184334107=:18802"
Content-ID: <Pine.LNX.4.62.0707131543130.18802@pademelon.sonytel.be>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584337861-427551646-1184334107=:18802
Content-Type: TEXT/PLAIN; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
Content-ID: <Pine.LNX.4.62.0707131543131.18802@pademelon.sonytel.be>

On Fri, 13 Jul 2007, James Bottomley wrote:
> On Fri, 2007-07-13 at 15:25 +0200, Geert Uytterhoeven wrote:
> > kmap() just returns page_address() on ppc64, as there's no highmem.
> > kunmap() is a no-op.
> 
> > So technically I could just use page_address() directly, but Christoph
> > wanted
> > me to keep the kmap()/kunmap() sequence because it's considered a good
> > practice.
> 
> The point isn't what kmap and kunmap do ... it's the addresses they
> return.  By and large, a kernel virtual address for a page is different
> from the user virtual address.  If the cache is virtually indexed you
> get different cache lines for the same page ... and that sets you up
> with aliases you need to resolve.  parisc is the same ... our
> kmap/kunmap are nops as well, but our kernel virtual addresses are still
> different from the user virtual ones.

IC.

  - flush_kernel_dcache_page() is a no-op on ppc64
    (ARCH_HAS_FLUSH_KERNEL_DCACHE_PAGE is defined on parisc only).

  - For reference, drivers/scsi/ipr.c (another ppc64 driver) just uses a plain
    kmap/memcpy/kunmap sequence

So what should I do?

With kind regards,
 
Geert Uytterhoeven
Software Architect

Sony Network and Software Technology Center Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium
 
Phone:    +32 (0)2 700 8453	
Fax:      +32 (0)2 700 8622	
E-mail:   Geert.Uytterhoeven@sonycom.com	
Internet: http://www.sony-europe.com/
 	
Sony Network and Software Technology Center Europe	
A division of Sony Service Centre (Europe) N.V.	
Registered office: Technologielaan 7 · B-1840 Londerzeel · Belgium	
VAT BE 0413.825.160 · RPR Brussels	
Fortis Bank Zaventem · Swift GEBABEBB08A · IBAN BE39001382358619
---584337861-427551646-1184334107=:18802--
