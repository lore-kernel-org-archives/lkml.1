Return-Path: <linux-kernel-owner+w=401wt.eu-S1756972AbZFMRfE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756972AbZFMRfE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 13:35:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752636AbZFMRew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 13:34:52 -0400
Received: from 8bytes.org ([88.198.83.132]:33194 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121AbZFMRev (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 13:34:51 -0400
Date: Sat, 13 Jun 2009 19:34:51 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Linus Torvalds <torvalds@linux-foundation.org>, mingo@elte.hu,
       lethal@linux-sh.org, hancockrwd@gmail.com, jens.axboe@oracle.com,
       bharrosh@panasas.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: [PATCH] dma-debug: disable DMA_API_DEBUG for now
Message-ID: <20090613173451.GB18638@8bytes.org>
References: <20090605173232N.fujita.tomonori@lab.ntt.co.jp> <20090605104132.GE24836@amd.com> <64bb37e0906101341j341f5179o9abfa888a6b96fc3@mail.gmail.com> <20090611081032.GN5139@amd.com> <64bb37e0906111038h1a5b9f17oec6c6368d2fbd36d@mail.gmail.com> <20090612141346.GY5139@amd.com> <64bb37e0906120751u14cac347hfa2356372e1e0a6a@mail.gmail.com> <20090613111014.GA18638@8bytes.org> <64bb37e0906130726i7b6ac33dma25e17c72cca54dd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64bb37e0906130726i7b6ac33dma25e17c72cca54dd@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 13, 2009 at 04:26:06PM +0200, Torsten Kaiser wrote:
> On Sat, Jun 13, 2009 at 1:10 PM, Joerg Roedel<joro@8bytes.org> wrote:
> >
> > paddr shouldn't matter. We also can't compare against it because it is
> > not a parameter we get in the unmap path (not always).
> 
> check_unmap() checks it and sg_call_ents are also optional.

check_unmap() only checks it for coherent mappings (where it makes
sense). But for a best-fit search it does not make sense because we
already check for the type and multiple coherent mappings to the same
dma_addr for the same device are not possible (because for coherent
mappings the memory is allocated by the dma_ops backend).

Joerg
