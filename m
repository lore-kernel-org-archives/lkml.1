Return-Path: <linux-kernel-owner+w=401wt.eu-S932777AbZFOSs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932777AbZFOSs2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 14:48:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751413AbZFOSsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 14:48:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:60181 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762599AbZFOSsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 14:48:19 -0400
Subject: Re: [tip:perfcounters/core] x86: Add NMI types for kmap_atomic
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>, linux-kernel@vger.kernel.org,
       mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       efault@gmx.de, npiggin@suse.de, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090615184217.GG11248@elte.hu>
References: <tip-3ff0141aa3a03ca3388b40b36167d0a37919f3fd@git.kernel.org>
	 <1245077165.6800.497.camel@laptop>
	 <Pine.LNX.4.64.0906151623570.5225@sister.anvils>
	 <1245080486.6800.561.camel@laptop> <1245089065.13761.19316.camel@twins>
	 <20090615181555.GA11248@elte.hu> <1245089943.13761.19334.camel@twins>
	 <20090615182549.GD11248@elte.hu> <1245090608.13761.19349.camel@twins>
	 <20090615184217.GG11248@elte.hu>
Content-Type: text/plain
Date: Mon, 15 Jun 2009 20:47:54 +0200
Message-Id: <1245091674.6741.180.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-15 at 20:42 +0200, Ingo Molnar wrote:
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Mon, 2009-06-15 at 20:25 +0200, Ingo Molnar wrote:
> > > * Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > > but ... look at the APIs i propose above. We dont need _any_ 
> > > 'types'.
> > > 
> > > That type enumeration is basically an open-coded allocator. If we do 
> > > a _real_ allocator (a balanced stack of atomic kmaps) we dont need 
> > > any of those indices, and all the potential for mismatch goes away 
> > > as well - a stack nests trivially with IRQ and NMI and arbitrary 
> > > other contexts.
> > 
> > You want types because:
> >  - they encode the intent, and can be verified
> >  - they help keep track of the max nesting depth
> > 
> > In the proposed implementation all type code basically falls away 
> > no ! CONFIG_DEBUG_VM, but is kept around for robustness.
> 
> But much of the fragility of the types (and their clumsiness - for 
> example in highpte ops we have to know at which level of the 
> pagetables we are, and use the right kind of index) is _precisely_ 
> because we have the types ...

How will you manage the max depth?

