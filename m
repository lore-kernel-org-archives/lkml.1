Return-Path: <linux-kernel-owner+w=401wt.eu-S1760282AbYGPPA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760282AbYGPPA5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 11:00:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753778AbYGPPAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 11:00:49 -0400
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:45065 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756768AbYGPPAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 11:00:48 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtUEAKikfUhMRKxB/2dsb2JhbACBWa8b
Date: Wed, 16 Jul 2008 11:00:46 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Peter Zijlstra <peterz@infradead.org>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Masami Hiramatsu <mhiramat@redhat.com>,
       linux-mm@kvack.org, Dave Hansen <haveblue@us.ibm.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: Re: [patch 10/17] LTTng instrumentation - swap
Message-ID: <20080716150046.GI24546@Krystal>
References: <20080715222604.331269462@polymtl.ca> <20080715222748.214360024@polymtl.ca> <1216197576.5232.27.camel@twins> <20080716144008.GG24546@Krystal> <1216219654.5232.55.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1216219654.5232.55.camel@twins>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 10:59:19 up 41 days, 19:40,  5 users,  load average: 3.23, 2.74,
	1.65
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Wed, 2008-07-16 at 10:40 -0400, Mathieu Desnoyers wrote:
> > * Peter Zijlstra (peterz@infradead.org) wrote:
> > > On Tue, 2008-07-15 at 18:26 -0400, Mathieu Desnoyers wrote:
> 
> > > > @@ -1796,6 +1799,7 @@ get_swap_info_struct(unsigned type)
> > > >  {
> > > >  	return &swap_info[type];
> > > >  }
> > > > +EXPORT_SYMBOL_GPL(get_swap_info_struct);
> > > 
> > > I'm not too happy with this export.
> > > 
> > 
> > Would it make more sense to turn get_swap_info_struct into a static
> > inline in swap.h ?
> 
> Seeing a consumer of it would go a long way towards discussing it ;-)
> 

The LTTng probe which connects to this tracepoint looks like :

+static void probe_swap_out(struct page *page)
+{
+       trace_mark(mm_swap_out, "pfn %lu filp %p offset %lu",
+               page_to_pfn(page),
+               get_swap_info_struct(swp_type(
+                       page_swp_entry(page)))->swap_file,
+               swp_offset(page_swp_entry(page)));
+}

So, I need get_swap_info_struct to extract the swap file pointer from
the swap entry.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
