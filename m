Return-Path: <linux-kernel-owner+w=401wt.eu-S1761400AbZCYM1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761400AbZCYM1f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 08:27:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758241AbZCYM1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 08:27:25 -0400
Received: from viefep17-int.chello.at ([62.179.121.37]:26367 "EHLO
	viefep17-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761262AbZCYM1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 08:27:24 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH 5/6] perf_counter: kerneltop: mmap_pages argument
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Wu Fengguang <fengguang.wu@intel.com>
In-Reply-To: <20090325121811.GC11571@elte.hu>
References: <20090325113021.781490788@chello.nl>
	 <20090325113317.104545398@chello.nl>  <20090325121811.GC11571@elte.hu>
Content-Type: text/plain
Date: Wed, 25 Mar 2009 13:27:13 +0100
Message-Id: <1237984033.7972.865.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-25 at 13:18 +0100, Ingo Molnar wrote:
> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > provide a knob to set the number of mmap data pages.
> 
> > +	" -m pages  --mmap_pages=<pages> # number of mmap data pages\n"
> 
> Btw., we really want this to be auto-tuning to a large degree. If 
> the kernel observes missed events, it should create a 
> PERF_EVENT_OVERFLOW==0x3 record, with the number of missed events - 
> or something like that.

Well, who's to say we ever see that overflow record if we're having
trouble tracking the output as is?

How important is it for people to have accurate overflow information
other than the current -- we can't keep up -- kind?

One possible solution is making the control page writable and writing
the userspace read position to it, then the kernel can, on
perf_output_begin() detect the overflow and count the number of
overwritten events.

This overflow count could then be published back into the control page.

TBH I'm not much of a fan, making all these pages writable just opens a
whole can of worms, and that accurate overflow tracking will put more
code in the output path.

Also, when mixing streams (events,mmap) is a single: you missed 'n'
events still good?



