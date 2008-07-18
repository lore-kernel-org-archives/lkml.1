Return-Path: <linux-kernel-owner+w=401wt.eu-S1755976AbYGRJXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976AbYGRJXR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 05:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751322AbYGRJXD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 05:23:03 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37727 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543AbYGRJXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 05:23:02 -0400
Subject: Re: [RFC] systemtap: begin the process of using proper kernel APIs
	(part1: use kprobe symbol_name/offset instead of address)
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, systemtap@sourceware.org,
       jbeulich@novell.com
In-Reply-To: <87ej5rsgk4.fsf@basil.nowhere.org>
References: <1216146802.3312.95.camel@localhost.localdomain>
	 <87ej5rsgk4.fsf@basil.nowhere.org>
Content-Type: text/plain
Date: Fri, 18 Jul 2008 11:23:29 +0200
Message-Id: <1216373009.5232.130.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-07-18 at 11:11 +0200, Andi Kleen wrote:
> James Bottomley <James.Bottomley@HansenPartnership.com> writes:
> 
> > One of the big nasties of systemtap is the way it tries to embed
> > virtually the entirety of the kernel symbol table in the probe modules
> > it constructs.  This is highly undesirable because it represents a
> > subversion of the kernel API to gain access to unexported symbols.  At
> > least for kprobes, the correct way to do this is to specify the probe
> > point by symbol and offset.
> >
> > This patch converts systemtap to use the correct kprobe
> > symbol_name/offset pair to identify the probe location.
> >
> > This only represents a baby step:  after this is done, there are at
> > least three other consumers of the systemtap module relocation
> > machinery:
> >
> >      1. unwind information.  I think the consumers of this can be
> >         converted to use the arch specific unwinders that already exist
> >         within the kernel
> 
> 
> Right now x86 doesn't really have a good reliable unwinder that
> works without frame pointer. I think systemtap
> recently switched to Jan Beulich's dwarf2 unwinder. Before
> switching to the in kernel unwinder that one would need to be 
> re-merged again.

Those are two separate issues.

 1) stap ought to use the kernel's infrastructure and not re-implement
its own.

 2) if the kernel's infrastructure doesn't meet requirements, improve
it.

But while the x86 might not be perfect, its fairly ok these days. Its
not the utter piece of shite x86_64 had for a long time - today's traces
mostly make sense.



