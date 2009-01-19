Return-Path: <linux-kernel-owner+w=401wt.eu-S1756245AbZASHNn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245AbZASHNn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 02:13:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753022AbZASHNb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 02:13:31 -0500
Received: from smtp115.mail.mud.yahoo.com ([209.191.84.164]:29024 "HELO
	smtp115.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750735AbZASHNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 02:13:30 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=zlPtMHvKEd1U18tXji9+5PWHfiJcKyXzJDgLf6q4WgIDYEH4ZF08FE0u8F96whBLhGWMHWOETrmCc3m1MZeP/pd3FrNr92l1rTXMP6SbGIDmeuGOdbT5QScDddNPxfvic5YH2OTIW4N9WAndkFxmGUHF6P1+8EivmUD+zckge7g=  ;
X-YMail-OSG: .PIOTY8VM1nsjjjoa6myMf5GoW83WKONKTI8AuL9ry8i9_xaKrWzFxiYAMvVhaEtntnxUKuDWkm7V2gTG81gFVwTrwVJfiSlAv4kMPLZwmpx0aqMMGVNFpo4U9KPsGtZGjnT4XUtSbXcr1bBiNhNvqOoES8N66Rh61ZK_XgouAI0U.GGRKEdQsoHFL.h7sNQjOMBvTrbckvfH4OIFYYHnnlDZfcQf_fdi38-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Subject: Re: Mainline kernel OLTP performance update
Date: Mon, 19 Jan 2009 18:13:06 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: "Matthew Wilcox" <matthew@wil.cx>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>, chinang.ma@intel.com,
       linux-kernel@vger.kernel.org, sharad.c.tripathi@intel.com,
       arjan@linux.intel.com, andi.kleen@intel.com, suresh.b.siddha@intel.com,
       harita.chilukuri@intel.com, douglas.w.styner@intel.com,
       peter.xihong.wang@intel.com, hubert.nueckel@intel.com,
       chris.mason@oracle.com, srostedt@redhat.com, linux-scsi@vger.kernel.org,
       "Andrew Vasquez" <andrew.vasquez@qlogic.com>,
       "Anirban Chakraborty" <anirban.chakraborty@qlogic.com>,
       "Christoph Lameter" <cl@linux-foundation.org>
References: <BC02C49EEB98354DBA7F5DD76F2A9E800317003CB0@azsmsx501.amr.corp.intel.com> <200901162142.51306.nickpiggin@yahoo.com.au> <84144f020901160255i530755bboc07750a61240d4bf@mail.gmail.com>
In-Reply-To: <84144f020901160255i530755bboc07750a61240d4bf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901191813.07960.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 January 2009 21:55:30 Pekka Enberg wrote:
> Hi Nick,
>
> On Fri, Jan 16, 2009 at 12:42 PM, Nick Piggin <nickpiggin@yahoo.com.au> 
wrote:
> >> I don't have the exact config for the previous tests but it's was just
> >> my laptop regular config whereas the new tests are x86-64 defconfig.
> >> So I think I'm just hitting some of the other OLTP regressions here,
> >> aren't I? There's some scheduler related options such as
> >> CONFIG_GROUP_SCHED and CONFIG_FAIR_GROUP_SCHED enabled in defconfig
> >> that I didn't have in the original tests. I can try without them if
> >> you want but I'm not sure it's relevant for SLAB vs SLUB tests.
> >
> > Oh no that's fine. It just looked like you repeated the test but
> > with lockdep disabled (and no other changes).
>
> Right. In any case, I am still unable to reproduce the OLTP issue and
> I've seen SLUB beat SLAB on my machine in most of the benchmarks
> you've posted.

SLUB was distinctly slower on the tbench, netperf, and hackbench
tests that I ran. These were faster with SLUB on your machine?
What kind of system is it?


> So I have very mixed feelings about SLQB. It's very
> nice that it works for OLTP but we still don't have much insight (i.e.
> numbers) on why it's better.

According to estimates in this thread, I think Matthew said SLUB would
be around 6% slower? SLQB is within measurement error of SLAB.

Fair point about personally reproducing the OLTP problem yourself. But
the fact is that we will get problem reports that cannot be reproduced.
That does not make them less relevant. I can't reproduce the OLTP
benchmark myself. And I'm fully expecting to get problem reports for
SLQB against insanely sized SGI systems, which I will take very seriously
and try to fix them.


> I'm also bit worried if SLQB has gotten
> enough attention from the NUMA and HPC folks that brought us SLUB.

It hasn't, but that's the problem we're hoping to solve by getting it
merged. People can give it more attention, and we can try to fix any
problems. SLUB has been default for quite a while now and not able to
solve all problems it has had reported against it. So I hope SLQB will
be able to unblock this situation.


> The good news is that SLQB can replace SLAB so either way, we're not
> going to end up with four allocators. Whether it can replace SLUB
> remains to be seen.

Well I think being able to simply replace SLAB is not ideal. The plan
I'm hoping is to have four allocators for a few releases, and then
go back to having two. That is going to mean some groups might not
have their ideal allocator merged... but I think it is crazy to settle
with more than one main compile-time allocator for the long term.

I don't know what the next redhat enterprise release is going to do,
but if they go with SLAB, then I think that means no SGI systems would
run in production with SLUB anyway, so what would be the purpose of
having a special "HPC/huge system" allocator? Or... what other reasons
should users select SLUB vs SLAB? (in terms of core allocator behaviour,
versus extras that can be ported from one to the other) If we can't even
make up our own minds, then will others be able to?

