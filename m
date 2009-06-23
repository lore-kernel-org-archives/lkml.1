Return-Path: <linux-kernel-owner+w=401wt.eu-S1757894AbZFWI1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757894AbZFWI1u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 04:27:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754042AbZFWI1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 04:27:33 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36105 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752984AbZFWI1a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 04:27:30 -0400
Date: Tue, 23 Jun 2009 10:27:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2 -tip] perf_counter: parse-events.c introduce alias
	member in event_symbol
Message-ID: <20090623082712.GD11181@elte.hu>
References: <1245669194.17153.6.camel@localhost.localdomain> <1245669268.17153.8.camel@localhost.localdomain> <20090622113256.GA22479@elte.hu> <1245675657.7537.3.camel@localhost.localdomain> <20090622141009.GB6486@elte.hu> <1245700551.6167.5.camel@localhost.localdomain> <1245701279.6167.7.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245701279.6167.7.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

>  L1-data-Cache-Load-Referencees                      398303881
>  L1-data-Cache-Load-Misses                             3552374
>  L1-data-Cache-Store-Referencees                        270178
>  L1-data-Cache-Store-Misses                         <inactive>
>  L1-data-Cache-Prefetch-Referencees                     611622
>  L1-data-Cache-Prefetch-Misses                          399730
>  L1-instruction-Cache-Load-Referencees               124696447
>  L1-instruction-Cache-Load-Misses                      2912802
>  L1-instruction-Cache-Store-Referencees             <inactive>
>  L1-instruction-Cache-Store-Misses                  <inactive>
>  L1-instruction-Cache-Prefetch-Referencees              156576
>  L1-instruction-Cache-Prefetch-Misses               <inactive>
>  L2-Cache-Load-Referencees                             4312353
>  L2-Cache-Load-Misses                                   470382
>  L2-Cache-Store-Referencees                            4392945
>  L2-Cache-Store-Misses                              <inactive>
>  L2-Cache-Prefetch-Referencees                      <inactive>
>  L2-Cache-Prefetch-Misses                           <inactive>
>  Data-TLB-Cache-Load-Referencees                     127076487
>  Data-TLB-Cache-Load-Misses                            1930048
>  Data-TLB-Cache-Store-Referencees                   <inactive>
>  Data-TLB-Cache-Store-Misses                        <inactive>
>  Data-TLB-Cache-Prefetch-Referencees                <inactive>
>  Data-TLB-Cache-Prefetch-Misses                     <inactive>
>  Instruction-TLB-Cache-Load-Referencees              132768077
>  Instruction-TLB-Cache-Load-Misses                        6406
>  Instruction-TLB-Cache-Store-Referencees            <inactive>
>  Instruction-TLB-Cache-Store-Misses                 <inactive>
>  Instruction-TLB-Cache-Prefetch-Referencees         <inactive>

there's a typo somewhere: it's References, not Referencees.

>  Instruction-TLB-Cache-Prefetch-Misses              <inactive>
>  Branch-Cache-Load-Referencees                        58030210
>  Branch-Cache-Load-Misses                              3257804
>  Branch-Cache-Store-Referencees                     <inactive>
>  Branch-Cache-Store-Misses                          <inactive>
>  Branch-Cache-Prefetch-Referencees                  <inactive>
>  Branch-Cache-Prefetch-Misses                       <inactive>

btw., these names should be shortened somehow.

Instruction-TLB-Cache-Prefetch-Referencees could become:

  iTLB-prefetch-refs

Data-TLB-Cache-Store-Referencees could become:

  dTLB-store-refs

etc. (You might want to send us a list of abbreviations first, 
before coding it, to avoid unnecessary work - it will need a few 
iterations.)

The long versions should be recognized too, if someone prefers those 
(i.e. our alias detection should be extensive and permissive), but 
the names we _display_ should be short.

	Ingo
