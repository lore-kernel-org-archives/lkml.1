Return-Path: <linux-kernel-owner+w=401wt.eu-S1753346AbZBCKhE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346AbZBCKhE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 05:37:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751763AbZBCKgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 05:36:54 -0500
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:39489 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751568AbZBCKgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 05:36:53 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=v/vvVxB5lCm+JOnohjV/0P/mUfvhT5cV8uf138oYCBtvGRIcXm5k5fKjuHXS+zkZZ5yoOqa2mArY+Zpet0BYMdzDh4xx1ak71pNgrWWCYCTAAMmFjFEgAds0srvVcAsibu+tBKlJwoFdwob+c/ipOWysAjKu/CYWLBHXZcRr6Dg=  ;
X-YMail-OSG: 3Yf8ImIVM1mGhocYYOmBC9bifwOP1.rUsyXvgsAsm5xSwzvl8dwivl5V96QB8CjLmio67rNGJHxKz8K9g_8lQlDpwubriCost8SIrNPEHFllHfy2_uAw15stmoYajMndrGP0Qk7jmwbz60ub8H79V2RASM2YjaJqq7wF9hxk9QQHh.cH.c9HbakldU8_v2d3EFG8dj.xowFgF82cv1_lISIg41k-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [patch] SLQB slab allocator (try 2)
Date: Tue, 3 Feb 2009 21:36:24 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Nick Piggin <npiggin@suse.de>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lin Ming <ming.m.lin@intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Christoph Lameter <cl@linux-foundation.org>
References: <20090123154653.GA14517@wotan.suse.de> <1232959706.21504.7.camel@penberg-laptop> <20090203101205.GF9840@csn.ul.ie>
In-Reply-To: <20090203101205.GF9840@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902032136.26022.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 February 2009 21:12:06 Mel Gorman wrote:
> On Mon, Jan 26, 2009 at 10:48:26AM +0200, Pekka Enberg wrote:
> > Hi Nick,
> >
> > On Fri, 2009-01-23 at 16:46 +0100, Nick Piggin wrote:
> > > Since last time, fixed bugs pointed out by Hugh and Andi, cleaned up
> > > the code suggested by Ingo (haven't yet incorporated Ingo's last
> > > patch).
> > >
> > > Should have fixed the crash reported by Yanmin (I was able to reproduce
> > > it on an ia64 system and fix it).
> > >
> > > Significantly reduced static footprint of init arrays, thanks to Andi's
> > > suggestion.
> > >
> > > Please consider for trial merge for linux-next.
> >
> > I merged a the one you resent privately as this one didn't apply at all.
> > The code is in topic/slqb/core branch of slab.git and should appear in
> > linux-next tomorrow.
> >
> > Testing and especially performance testing is welcome. If any of the HPC
> > people are reading this, please do give SLQB a good beating as Nick's
> > plan is to replace both, SLAB and SLUB, with it in the long run.As
> > Christoph has expressed concerns over latency issues of SLQB, I suppose
> > it would be interesting to hear if it makes any difference to the
> > real-time folks.
>
> The HPC folks care about a few different workloads but speccpu is one that
> shows up. I was in the position to run tests because I had put together
> the test harness for a paper I spent the last month writing. This mail
> shows a comparison between slab, slub and slqb for speccpu2006 running a
> single thread and sysbench ranging clients from 1 to 4*num_online_cpus()
> (16 in both cases). Additional tests were not run because just these two
> take one day per kernel to complete. Results are ratios to the SLAB figures
> and based on an x86-64 and ppc64 machine.

Hi Mel,

This is very nice, thanks for testing. SLQB and SLUB are quite similar
in a lot of cases, which indeed could be explained by cacheline placement
(both of these can allocate down to much smaller sizes, and both of them
also put metadata directly in free object memory rather than external
locations).

But it will be interesting to try looking at some of the tests where
SLQB has larger regressions, so that might give me something to go on
if I can lay my hands on speccpu2006...

I'd be interested to see how slub performs if booted with slub_min_objects=1
(which should give similar order pages to SLAB and SLQB).


