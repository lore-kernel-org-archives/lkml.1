Return-Path: <linux-kernel-owner+w=401wt.eu-S1757275AbZCYM5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275AbZCYM5w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 08:57:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753094AbZCYM5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 08:57:42 -0400
Received: from viefep11-int.chello.at ([62.179.121.31]:19992 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879AbZCYM5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 08:57:41 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH 5/6] perf_counter: kerneltop: mmap_pages argument
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Wu Fengguang <fengguang.wu@intel.com>
In-Reply-To: <20090325125407.GA32744@elte.hu>
References: <20090325113021.781490788@chello.nl>
	 <20090325113317.104545398@chello.nl> <20090325121811.GC11571@elte.hu>
	 <1237984033.7972.865.camel@twins> <20090325123514.GB28639@elte.hu>
	 <1237984864.7972.896.camel@twins>  <20090325125407.GA32744@elte.hu>
Content-Type: text/plain
Date: Wed, 25 Mar 2009 13:57:12 +0100
Message-Id: <1237985832.7972.930.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-25 at 13:54 +0100, Ingo Molnar wrote:
> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > On Wed, 2009-03-25 at 13:35 +0100, Ingo Molnar wrote:
> > 
> > > > Also, when mixing streams (events,mmap) is a single: you missed 
> > > > 'n' events still good?
> > > 
> > > How would such mixing work? Multiple counters streaming into the 
> > > same mmap area?
> > 
> > No basically having overflow events and mmap-vma changed events in 
> > a single output stream.
> 
> ah, and i missed the impact of variable size records - that too 
> makes it somewhat impractical to emit overflow records in situ. (the 
> kernel does not really know the precise start of the previous 
> record, typically.)

Alternatively, we could simply not emit new events until the read
position increases,. that's much simpler.

Still don't like mapping the stuff writable though..

