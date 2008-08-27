Return-Path: <linux-kernel-owner+w=401wt.eu-S1754037AbYH0HBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037AbYH0HBf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 03:01:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752741AbYH0HB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 03:01:27 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:7161 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752735AbYH0HB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 03:01:26 -0400
Date: Wed, 27 Aug 2008 16:00:58 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Magnus Damm <magnus.damm@gmail.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       video4linux-list@redhat.com,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] VIDEO_SH_MOBILE_CEU should depend on HAS_DMA (was: Re: m68k allmodconfig)
Message-ID: <20080827070057.GA18717@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Magnus Damm <magnus.damm@gmail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	video4linux-list@redhat.com,
	Linux Kernel Development <linux-kernel@vger.kernel.org>
References: <20080814195522.ad74990c.akpm@linux-foundation.org> <Pine.LNX.4.64.0808262035310.7910@anakin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0808262035310.7910@anakin>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2008 at 09:37:21PM +0200, Geert Uytterhoeven wrote:
> 	Hi Andrew,
> 
> On Thu, 14 Aug 2008, Andrew Morton wrote:
> > ERROR: "dma_alloc_coherent" [drivers/media/video/videobuf-dma-contig.ko] undefined!
> > ERROR: "dma_sync_single_for_cpu" [drivers/media/video/videobuf-dma-contig.ko] undefined!
> > ERROR: "dma_free_coherent" [drivers/media/video/videobuf-dma-contig.ko] undefined!
> 
> M68k allmodconfig still selects Sun-3, which sets NO_DMA.
> I guess you're also seeing this on the other NO_DMA platforms (h8300, m32r,
> s390, and PCI-less SPARC)?
> 
> Below is a patch.
> 
> Shouldn't it also (or instead) depend on SUPERH or some SuperH platform?
> Or is this not done to have more compile-coverage?
> 
The SUPERH dependency was there initially, but was dropped for increased
compilation coverage. The HAS_DMA dependence is certainly the right thing
to do here.

> Subject: [PATCH] VIDEO_SH_MOBILE_CEU should depend on HAS_DMA
> 
> commit 0d3244d6439c8c31d2a29efd587c7aca9042c8aa ("V4L/DVB (8342):
> sh_mobile_ceu_camera: Add SuperH Mobile CEU driver V3") introduced
> VIDEO_SH_MOBILE_CEU, which selects VIDEOBUF_DMA_CONTIG. This circumvents the
> dependency on HAS_DMA of VIDEOBUF_DMA_CONTIG.
> 
> Add a dependency on HAS_DMA to VIDEO_SH_MOBILE_CEU to fix this.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Acked-by: Paul Mundt <lethal@linux-sh.org>
