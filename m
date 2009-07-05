Return-Path: <linux-kernel-owner+w=401wt.eu-S1755494AbZGEMoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494AbZGEMoj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 08:44:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756635AbZGEMoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 08:44:30 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:6170 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756630AbZGEMo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 08:44:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=OvMa2y75iuKZ8uctmX+5KLH0zL+Cd1YLEQz2eA8uesypbdwqmBPK1IywOI1B2rPFec
         +ZKN6InOezbgt6oIbNI/BpVIv6RaRfQd2be35sC9PLY+cArtXvnaKh55jAdS5QdpA+g8
         W6/pNFyqE8vhgSYf7LQSOUwYCHgfuJvFWkwp4=
Date: Sun, 5 Jul 2009 20:44:18 +0800
From: Ming Lei <tom.leiming@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: joerg.roedel@amd.com, fujita.tomonori@lab.ntt.co.jp,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 0/3] dma-mapping:remove CONFIG_HAVE_DMA_ATTRS
Message-ID: <20090705204418.44fc38c1@linux-lm>
In-Reply-To: <200907051319.37169.arnd@arndb.de>
References: <1246674895-9610-1-git-send-email-tom.leiming@gmail.com>
	<200907051319.37169.arnd@arndb.de>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.4; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Jul 2009 13:19:36 +0200
Arnd Bergmann <arnd@arndb.de> wrote:

> On Saturday 04 July 2009, tom.leiming@gmail.com wrote:
> > 2,Disabling CONFIG_HAVE_DMA_ATTRS may lead to a compile failure;
> 
> I'm not sure I understand this point. CONFIG_HAVE_DMA_ATTRS tells
> the common code whether the architecture understands dma attributes.

If a new arch does not define CONFIG_HAVE_DMA_ATTRS but uses
dma-mapping-common.h, it will lead to a compile failure. 

include/asm-generic/dma-mapping-common.h

	#define dma_map_single(d, a, s, r) dma_map_single_attrs(d, a,
	s, r, NULL)
	...

include/linux/dma-mapping.h
	
	#ifndef CONFIG_HAVE_DMA_ATTRS
	struct dma_attrs;

	#define dma_map_single_attrs(dev, cpu_addr, size, dir, attrs) \
        dma_map_single(dev, cpu_addr, size, dir)
	...
	#endif


> If you enable it on all architectures, you will get new compile
> failures on all those that don't understand them, while the current
> code correctly falls back on the standard functions.

You are right, the patch will lead to new compile failure for the
ARCHs, on which disables CONFIG_HAVE_DMA_ATTRS and doesn't use
dma-mapping-common.h. So the patch is not mature.

> 
> I think it makes sense to combine CONFIG_HAVE_DMA_ATTRS with the
> use of dma-mapping-common.h, but the majority of the architectures
> just uses a static mapping, where attributes make no sense.
> 
> You also missed powerpc64, which selects CONFIG_HAVE_DMA_ATTRS
> but does not (yet) use dma-mapping-common.h.

ppc64 doesn't use dma-mapping-common.h, so the patch doesn't consider
it.

-- 
Lei Ming
