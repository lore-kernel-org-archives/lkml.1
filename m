Return-Path: <linux-kernel-owner+w=401wt.eu-S1753646AbYDPBRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646AbYDPBRu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 21:17:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752894AbYDPBR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 21:17:27 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60427 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752119AbYDPBR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 21:17:26 -0400
Date: Wed, 16 Apr 2008 03:17:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <clameter@sgi.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, apw@shadowen.org,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [patch] mm: sparsemem memory_present() memory corruption fix
Message-ID: <20080416011704.GA439@elte.hu>
References: <20080415201734.GA25628@elte.hu> <4805115D.5030703@cs.helsinki.fi> <20080415204025.GA29784@elte.hu> <alpine.LFD.1.00.0804151353380.2879@woody.linux-foundation.org> <20080416000356.GA24737@elte.hu> <20080416001816.GA26295@elte.hu> <86802c440804151732j519a541t9d8e4f6b49a53313@mail.gmail.com> <20080416004430.GA26928@elte.hu> <Pine.LNX.4.64.0804151745440.6876@schroedinger.engr.sgi.com> <20080416005231.GC26996@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080416005231.GC26996@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> > > this is the only call to memory_present() we do in 32-bit arch 
> > > setup, so it's required.
> > 
> > We could clip there if SPARSEMEM is configured. I wonder if this 
> > affects other platforms that need HIGHMEM support?
> 
> clip where and what?

i.e. as per my previous argument i'd consider the need to sanitize the 
calls in the architecture fundamentally wrong.

whether the core code emits a warning or allows the call is an 
additional question i mention in the changelog - but the core sparse 
memory code should _definitely_ not silently overflow a key internal 
array ... (of which data structure the architecture code is not even 
aware of)

	Ingo
