Return-Path: <linux-kernel-owner+w=401wt.eu-S1760153AbXJOVP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760153AbXJOVP4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 17:15:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755629AbXJOVPs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 17:15:48 -0400
Received: from artax.karlin.mff.cuni.cz ([195.113.31.125]:44295 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754827AbXJOVPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 17:15:47 -0400
X-Greylist: delayed 1684 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Oct 2007 17:15:47 EDT
Date: Mon, 15 Oct 2007 22:47:42 +0200 (CEST)
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
To: Nick Piggin <npiggin@suse.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: LFENCE instruction (was: [rfc][patch 3/3] x86: optimise barriers)
Message-ID: <Pine.LNX.4.64.0710152204060.30307@artax.karlin.mff.cuni.cz>
X-Personality-Disorder: Schizoid
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> According to latest memory ordering specification documents from Intel 
> and AMD, both manufacturers are committed to in-order loads from 
> cacheable memory for the x86 architecture. Hence, smp_rmb() may be a 
> simple barrier.
>
> http://developer.intel.com/products/processor/manuals/318147.pdf 
> http://www.amd.com/us-en/assets/content_type/white_papers_and_tech_docs/24593.pdf

Hi

I'm just wondering about one thing --- what is LFENCE instruction good 
for?

SFENCE is for enforcing ordering in write-combining buffers (it doesn't 
have sense in write-back cache mode).
MFENCE is for preventing of moving stores past loads.

But what is LFENCE for? I read the above documents and they already say 
that CPUs have ordered loads.

In Intel instruction reference, the description for LFENCE is copied from 
SFENCE (with the word "store" replaced with the word "load"), so it 
doesn't really give much insight into the operation of the instruction.

Or is LFENCE just a no-op reserved for the possibility that Intel would 
relax ordering rules?

Mikulas
