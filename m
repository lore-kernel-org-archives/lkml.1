Return-Path: <linux-kernel-owner+w=401wt.eu-S1760821AbZFLPaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760821AbZFLPaf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 11:30:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754050AbZFLPaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 11:30:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54438 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754030AbZFLPaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 11:30:24 -0400
Date: Fri, 12 Jun 2009 08:30:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, npiggin@suse.de, cl@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH v2] slab,slub: ignore __GFP_WAIT if we're booting or 
 suspending
Message-Id: <20090612083005.56336219.akpm@linux-foundation.org>
In-Reply-To: <1244806440.30512.51.camel@penberg-laptop>
References: <Pine.LNX.4.64.0906121113210.29129@melkki.cs.Helsinki.FI>
	<Pine.LNX.4.64.0906121201490.30049@melkki.cs.Helsinki.FI>
	<20090612091002.GA32052@elte.hu>
	<84144f020906120249y20c32d47y5615a32b3c9950df@mail.gmail.com>
	<20090612100756.GA25185@elte.hu>
	<84144f020906120311x7c7dd628s82e3ca9a840f9890@mail.gmail.com>
	<1244805060.7172.126.camel@pasglop>
	<1244806440.30512.51.camel@penberg-laptop>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Jun 2009 14:34:00 +0300 Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> +static gfp_t slab_gfp_mask __read_mostly = __GFP_BITS_MASK & ~__GFP_WAIT;

It'd be safer and saner to disable __GFP_FS and __GFP_IO as well. 
Having either of those flags set without __GFP_WAIT is a somewhat
self-contradictory thing and there might be code under reclaim which
assumes that __GFP_FS|__GFP_IO implies __GFP_WAIT.

<wonders why mempool_alloc() didn't clear __GFP_FS>
