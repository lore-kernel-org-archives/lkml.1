Return-Path: <linux-kernel-owner+w=401wt.eu-S1753656AbZBDGtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656AbZBDGtT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 01:49:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751377AbZBDGtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 01:49:09 -0500
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:28075 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751128AbZBDGtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 01:49:08 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=h93dO603i0oPeL3/RuHHRUHr+vZ3xnN9Ul+Je/nh1PDZMzvYbcXFod36bM7vdYtLstYHwF/b+zLf6qBcd6p6dWUJD3W+90WufmZ4PDNsLeOzxMmY1uU8SypFBmom1maflVbY5UPMvc+lZePu32wc5w9goa9uQb8EhsDvlDIfLoA=  ;
X-YMail-OSG: pWaj1mAVM1kANYi_AZBDj5EkpN74EjJG8jzubyAHyewZlugO_ruURiJlifCJVd2CB_gjcQGyfzMBZ.R4jIFjbG11nGlPyIjwAWAb4Elk9ZazLlShyx0fbOkLzSghMG28jqi3wMzEF_ZqRqR8RC71JTw92g--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [patch] SLQB slab allocator (try 2)
Date: Wed, 4 Feb 2009 17:48:40 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Nick Piggin <npiggin@suse.de>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lin Ming <ming.m.lin@intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Christoph Lameter <cl@linux-foundation.org>
References: <20090123154653.GA14517@wotan.suse.de> <200902032136.26022.nickpiggin@yahoo.com.au> <20090203112226.GG9840@csn.ul.ie>
In-Reply-To: <20090203112226.GG9840@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902041748.41801.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 February 2009 22:22:26 Mel Gorman wrote:
> On Tue, Feb 03, 2009 at 09:36:24PM +1100, Nick Piggin wrote:

> > But it will be interesting to try looking at some of the tests where
> > SLQB has larger regressions, so that might give me something to go on
> > if I can lay my hands on speccpu2006...
>
> I can generate profile runs although it'll take 3 days to gather it all
> together unless I target specific tests (the worst ones to start with
> obviously). The suite has a handy feature called monitor hooks that allows
> a pre and post script to run for each test which I use it to start/stop
> oprofile and gather one report per benchmark. I didn't use it for this run
> as profiling affects the outcome (7-9% overhead).
>
> I do have detailed profile data available for sysbench, both per thread run
> and the entire run but with the instruction-level included, it's a lot of
> data to upload. If you still want it, I'll start it going and it'll get up
> there eventually.

It couldn't hurt, but it's usually tricky to read anything out of these from
CPU cycle profiles. Especially if they are due to cache or tlb effects (which
tend to just get spread out all over the profile).

slabinfo (for SLUB) and slqbinfo (for SLQB) activity data could be interesting
(invoke with -AD).


> > I'd be interested to see how slub performs if booted with
> > slub_min_objects=1 (which should give similar order pages to SLAB and
> > SLQB).
>
> I'll do this before profiling as only one run is required and should
> only take a day.
>
> Making spec actually build is tricky so I've included a sample config for
> x86-64 below that uses gcc and the monitor hooks in case someone else is in
> the position to repeat the results.

Thanks. I don't know if we have a copy of spec 2006 I can use, but I'll ask
around.

