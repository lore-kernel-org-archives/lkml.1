Return-Path: <linux-kernel-owner+w=401wt.eu-S1751472AbYJKEAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751472AbYJKEAU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 00:00:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750716AbYJKEAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 00:00:05 -0400
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:47045 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753193AbYJKEAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 00:00:04 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=E7FHoWYy/UlTFd+TGh3OhhziT+jtsSWtYsVN4/MwxjN8T9ROV3BQiFc4+MFTS0XX3Jxu7Nx96bxUfwz2dkLmAeUe8AOxs6Lx3ITtgFekKPe6FqZ4nmEgt/OxkFuzVMHzTUv0fik49MPUkueeU5HMqvV5UaDpp7Vl2PuXseTdnBk=  ;
X-YMail-OSG: SSK4OuQVM1lAEcfCRBAI5OhiW0hR0yExjVB7hGQPd5ixkf19e4LQAYall3wmMHF7khmdn9i8pe79xScj9L64iGIlhNJ3rWS4DbTuA8dEdZ84m.0n2Pcf__Gx87TqkvH2gRoDONGhC7bgz5ofgxUSTSI3GJDaBfTopChY1Tq2
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: Update cacheline size on X86_GENERIC
Date: Sat, 11 Oct 2008 14:59:53 +1100
User-Agent: KMail/1.9.5
Cc: Dave Jones <davej@redhat.com>, x86@kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
References: <20081009171453.GA15321@redhat.com> <200810101945.32111.nickpiggin@yahoo.com.au> <48EF2CE0.3080109@firstfloor.org>
In-Reply-To: <48EF2CE0.3080109@firstfloor.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200810111459.53306.nickpiggin@yahoo.com.au>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 10 October 2008 21:22, Andi Kleen wrote:
> Nick Piggin wrote:
> >>> Anyway, GENERIC kernel should run well on all architectures, and while
> >>> going too big causes slightly increased structures sometimes, going too
> >>> small could result in horrible bouncing.
> >>
> >> Exactly.
> >>
> >> That is it costs one percent or so on TPC, but I think the fix
> >> for that is just to analyze where the problem is and size those
> >> data structures based on the runtime cache size. Some subsystems
> >> like slab do this already.
> >
> > Costs 1% on TPC? Is that 128 byte aligning data structures on
> > Core2, or 64 byte aligning them on P4 that costs the performance?
>
> The first. BTW it was a rough number from memory, in that ballpark.
> Also the experiment was on older kernels, might be different now.
>
> The second would undoubtedly be much worse.

OK. Well I don't have a really strong opinion on what to do...

I guess there is a reasonable argument to not care about P4 so
much in today's GENERIC kernel. If it is worth around 1% on tpc
on a more modern architecture, that is a pretty big motivation
to change it too...
