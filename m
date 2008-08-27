Return-Path: <linux-kernel-owner+w=401wt.eu-S1753977AbYH0Gyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977AbYH0Gyt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 02:54:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234AbYH0Gyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 02:54:41 -0400
Received: from smtp115.mail.mud.yahoo.com ([209.191.84.164]:20312 "HELO
	smtp115.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752228AbYH0Gyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 02:54:40 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=dKYu86tJsE/y5ECtpogbilzqS4FcIGdewsl6JiDe3miqfEYwK4F5JPGHVyTFNHhFZawQHQDgBa16uaBMsqVLOYZBmuBs3giyTde++fc0hA2EWa42gshUYFb7CEJfxUg3xNHbfJfrA18ItckpJ1fUMKPLwlBmw/YOZFzYYfbulKg=  ;
X-YMail-OSG: SL8K21YVM1l.FTNjuZ779I1mBDdhd8h.cfKArBMT3udBwjapjUmgcfi_rnT7IgehVX8vOHkpZBoa8cMPLMAoDd9P5ROCmugPj.Jk52kMDhlogKomA8I1oQbOVRb.aM688WY-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Mike Travis <travis@sgi.com>
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c =?iso-8859-1?q?-=09bisected?=
Date: Wed, 27 Aug 2008 16:54:32 +1000
User-Agent: KMail/1.9.5
Cc: Dave Jones <davej@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Alan D. Brunelle" <Alan.Brunelle@hp.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Luck, Tony" <tony.luck@intel.com>, Jack Steiner <steiner@sgi.com>,
       Christoph Lameter <cl@linux-foundation.org>
References: <48B29F7B.6080405@hp.com> <20080826192848.GA20653@redhat.com> <48B460FE.2020100@sgi.com>
In-Reply-To: <48B460FE.2020100@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808271654.32721.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 August 2008 06:01, Mike Travis wrote:
> Dave Jones wrote:
> ...
>
> > But yes, for this to be even remotely feasible, there has to be a
> > negligable performance cost associated with it, which right now, we
> > clearly don't have. Given that the number of people running 4096 CPU
> > boxes even in a few years time will still be tiny, punishing the common
> > case is obviously absurd.
> >
> > 	Dave
>
> I did do some fairly extensive benchmarking between configs of NR_CPUS =
> 128 and 4096 and most performance hits were in the neighborhood of < 5% on
> systems with 8 cpus and 4GB of memory (our most common test system).

5% is a pretty nasty performance hit... what sort of benchmarks are we
talking about here?

I just made some pretty crazy changes to the VM to get "only" around 5
or so % performance improvement in some workloads.

What places are making heavy use of cpumasks that causes such a slowdown?
Hopefully callers can mostly be improved so they don't need to use cpumasks
for common cases.

Until then, it would be kind of sad for a distro to ship a generic x86
kernel and lose 5% performance because it is set to 4096 CPUs...

But if I misunderstand and you're talking about specific microbenchmarks to
find the worst case for huge cpumasks, then I take that back.


> [But 
> changing cpumask_t's to be pointers instead of values will likely increase
> this.]  I've tried to be very sensitive to this issue with all my previous
> changes, so convincing the distros to set NR_CPUS=4096 would be as painless
> for them as possible. ;-)
>
> Btw, huge count cpu systems I don't think are that far away.  I believe the
> nextgen Larabbee chips will be geared towards HPC applications [instead of
> just GFX apps], and putting 4 of these chips on a motherboard would add up
> to 512 cpu threads (1024 if they support hyperthreading.)

It would be quite interesting if they make them cache coherent / MP capable.
Will they be?
