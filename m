Return-Path: <linux-kernel-owner+w=401wt.eu-S1758329AbXJQS7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758329AbXJQS7c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 14:59:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752256AbXJQS7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 14:59:16 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55324 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754914AbXJQS7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 14:59:15 -0400
Date: Wed, 17 Oct 2007 11:58:14 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [bug] block subsystem related crash with latest -git
In-Reply-To: <20071017182013.GR15552@kernel.dk>
Message-ID: <alpine.LFD.0.999.0710171156060.26902@woody.linux-foundation.org>
References: <20071017154655.GA13394@elte.hu>
 <alpine.LFD.0.999.0710170929270.26902@woody.linux-foundation.org>
 <20071017165949.GF15552@kernel.dk> <20071017170804.GG15552@kernel.dk>
 <20071017172158.GH15552@kernel.dk> <20071017172932.GI15552@kernel.dk>
 <alpine.LFD.0.999.0710171053180.26902@woody.linux-foundation.org>
 <20071017180218.GQ15552@kernel.dk> <alpine.LFD.0.999.0710171111040.26902@woody.linux-foundation.org>
 <20071017182013.GR15552@kernel.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 17 Oct 2007, Jens Axboe wrote:
> 
> For the chain elements - yes, definitely! But we also want to clear dma
> mapping output values, at least sparc64 wants that. You could argue that
> the IOMMU code should be fixed up, but I don't think we should mix the
> two.
> 
> So we need the memset() in blk_rq_map_sg() AS WELL AS the initial sg
> table clear. I'm not arguing about the latter, we clearly do need that.

I still don't see your argument.

The SG table is *already*zeroed*.

The fact that output values will be changed later is irrelevant. They 
haven't been changed *before* - or at least you haven't given a reasonable 
explanation for why they should have.

So explain to me why the memset() in blk_rq_map_sg() helps, considering 
that the memory must have been zeroed at allocation time anyway? Tell me 
what it is that fills any of the fields we don't already initialize, and 
that can happen *before* that memset?

		Linus
