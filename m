Return-Path: <linux-kernel-owner+w=401wt.eu-S1754782AbYGGGy2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782AbYGGGy2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 02:54:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752049AbYGGGyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 02:54:20 -0400
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:32069 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752205AbYGGGyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 02:54:19 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Arp9PdxqPrB2cEAkCxwnb2G9H51vUCjX9SlC2QHrPGLycGaycO9OkDLE4G8J6krR9MXd2ySJZTSvZPRBpiYgskqyMi1uN/a/mOf6ko2ZMG6En0u1AvPN98RhXMhe24DAdAU6/0S4+BjKljC6OvqiK4x/OkzqAd7rxYdtbNea+9M=  ;
X-YMail-OSG: pBQMvgYVM1kHLTJBN5LciAh42UCqC_zOx6sEMcHbd1TozHPRxGloALBRb4OYM6.0cMLZ3.TNClLjcyWekEkrsJvsLpi5cyf7_ZIB8HB4N.WAKkgcCEWqmuoT_IBwLRerZjU-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: kmap_atomic_pfn for PCI BAR access?
Date: Mon, 7 Jul 2008 16:53:54 +1000
User-Agent: KMail/1.9.5
Cc: Dave Airlie <airlied@gmail.com>, Keith Packard <keithp@keithp.com>,
       Dave Airlie <airlied@linux.ie>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <1214242487.11887.35.camel@koto.keithp.com> <21d7e9970806251823q3405e192q13d4944bd0cc3291@mail.gmail.com> <486308C9.5070709@goop.org>
In-Reply-To: <486308C9.5070709@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807071653.55094.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 June 2008 13:11, Jeremy Fitzhardinge wrote:
> Dave Airlie wrote:

> > doing tlb flush for iounmap is slow as all hell if you do it a lot,
> > and we can't afford to mmap the whole aperture it can 1GB.
>
> Maybe Nick's vmap reimplementation would help here.  It effectively
> allows you to map stuff into the vmalloc space, and do lazy tlb flushes
> to mitigate the cost of map/unmap.  He posted the patches week or so ago.

Yeah, it can _really_ help. I'd posted some performance numbers with
the patch which might prompt you to take another look at ioremap.

One thing I still haven't implemented in that patch are CPU-local
mappings (which only require a local flush to flush)... I found that
after the improvements I did implement, they didn't help much for
my workloads, so I suspect you might find the same thing... But anyway
if you really need the per-CPU mappings, it should be possible to
implement rather generically in vmap layer.

I would be very interested to know what sort of results you see with it
(compared to kmap_atomic and compared to vanilla ioremap)

Thanks,
Nick
