Return-Path: <linux-kernel-owner+w=401wt.eu-S1754584AbYJJIpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584AbYJJIpt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 04:45:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751443AbYJJIpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 04:45:41 -0400
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:29774 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751040AbYJJIpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 04:45:40 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=FhNgmfYMR2tXYwq7dhdX3Qn9YlCbSLyz9rowVuqMMS1nBoIjizu03+p2MtJEhYIzE8coqhDVfmyonVBcaAK/Mlgl2ptdOs3M0UaswKNPA06Dkr3J/di1NQGEwouXIKvWD73D6+rvCBbllGc2xKqEF2lrT8tMY7/MS/pD0QrZTqo=  ;
X-YMail-OSG: 1J6m7V8VM1mQ9fUZh10TjEGmHVVtjzOSfDY6ba2bYqNggCA4SAbcYrqr8wv6MdttYm25dbHT1i_pc5BjHR.XDyORxDzQKSrxhKXBb_.nLDZqpEoVpmIFtBXZjPJRzC8I5E7UByavWSoixU1JSfjUJo9cPzXE7n0hRwEWtLN5zuJ0eRRTvwyXi0l27vR9
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: Update cacheline size on X86_GENERIC
Date: Fri, 10 Oct 2008 19:45:31 +1100
User-Agent: KMail/1.9.5
Cc: Dave Jones <davej@redhat.com>, x86@kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
References: <20081009171453.GA15321@redhat.com> <200810101428.23662.nickpiggin@yahoo.com.au> <87tzbksxja.fsf@basil.nowhere.org>
In-Reply-To: <87tzbksxja.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810101945.32111.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 10 October 2008 18:46, Andi Kleen wrote:
> Nick Piggin <nickpiggin@yahoo.com.au> writes:
> > On Friday 10 October 2008 04:14, Dave Jones wrote:
> >> I just noticed that configuring a kernel to use CONFIG_X86_GENERIC
> >> (as is typical for a distro kernel) configures it to use a 128 byte
> >> cacheline size. This made sense when that was commonplace (P4 era) but
> >> current
> >> Intel, AMD and VIA cpus use 64 byte cachelines.
> >
> > I think P4 technically did have 64 byte cachelines, but had some adjacent
> > line prefetching.
>
> The "coherency unit" on P4, which is what matters for SMP alignment
> purposes to avoid false sharing, is 128 bytes.
>
> > And AFAIK core2 CPUs can do similar prefetching (but
> > maybe it's smarter and doesn't cause so much bouncing?).
>
> On Core2 the coherency unit is 64bytes.

OK.


> > Anyway, GENERIC kernel should run well on all architectures, and while
> > going too big causes slightly increased structures sometimes, going too
> > small could result in horrible bouncing.
>
> Exactly.
>
> That is it costs one percent or so on TPC, but I think the fix
> for that is just to analyze where the problem is and size those
> data structures based on the runtime cache size. Some subsystems
> like slab do this already.

Costs 1% on TPC? Is that 128 byte aligning data structures on
Core2, or 64 byte aligning them on P4 that costs the performance?


> TPC is a bit of a extreme case because it is so extremly cache bound.

Still, it is a good canary.


> Overall the memory impact of the cache padding is getting less over
> time because more and more data is moving into the per CPU data areas.

Right.
