Return-Path: <linux-kernel-owner+w=401wt.eu-S1754715AbZDFHMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715AbZDFHMW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 03:12:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754421AbZDFHMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 03:12:13 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:56934 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754313AbZDFHMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 03:12:12 -0400
Subject: Re: + page-owner-tracking.patch added to -mm tree
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: Vegard Nossum <vegard.nossum@gmail.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Mel Gorman <mel@csn.ul.ie>, Jason Baron <jbaron@redhat.com>,
       linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org,
       alexn@dsv.su.se, akpm@linux-foundation.org, alexn@telia.com,
       apw@shadowen.org, cl@linux-foundation.org, haveblue@us.ibm.com,
       kamezawa.hiroyu@jp.fujitu.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Fr?d?ric Weisbecker" <fweisbec@gmail.com>
In-Reply-To: <20090403144344.GA9643@elte.hu>
References: <20090401125506.GA6406@csn.ul.ie>
	 <20090401131713.GQ12966@elte.hu> <20090401133220.GB6406@csn.ul.ie>
	 <20090401134917.GC18677@elte.hu> <1238597398.23857.11.camel@penberg-laptop>
	 <20090401152251.GB23390@elte.hu> <1238656331.26286.17.camel@penberg-laptop>
	 <20090403042131.GA15669@localhost> <20090403141743.GF8875@elte.hu>
	 <49D61F09.2080808@cs.helsinki.fi>  <20090403144344.GA9643@elte.hu>
Date: Mon, 06 Apr 2009 10:12:09 +0300
Message-Id: <1239001929.1573.11.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Fri, 2009-04-03 at 16:43 +0200, Ingo Molnar wrote:
> * Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> 
> > Ingo Molnar wrote:
> >> * Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro> wrote:
> >>
> >>> One thing I'm not sure about this patch is whether it manages to  
> >>> record an allocation only once, i.e. does it log a single event  
> >>> when/if the slab allocator requests pages? Some time ago I sent a  
> >>> patch adding GFP_NOTRACE to gfp.h, but was rejected. Maybe this  
> >>> could be a way out of the mess.
> >>>
> >>> (GFP_NOTRACE would also allow us to log "backend" allocations easily 
> >>> and treat them separately, for the record, or simply filter them 
> >>> out.)
> >>
> >> makes a lot of sense IMO to annotate these via a GFP flag.
> >
> > Yup, make sense. I think I rejected the patch (did I?) because I 
> > wanted to fix the slub/slab mess differently but here it makes 
> > perfect sense.
> 
> I'm wondering how much could be shared with the kmemcheck's 
> internal-allocation annotations. There's some overlap (although not 
> a full match) i suspect?

I didn't check but I suspect it's not a perfect match. Kmemcheck wants
to know a lot more of the internal workings of an allocator than
kmemtrace. That is, we need to deal with constructor special cases for
initialization and debugging, for instance.

			Pekka

