Return-Path: <linux-kernel-owner+w=401wt.eu-S1753783AbXFWHrD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783AbXFWHrD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 03:47:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751984AbXFWHqy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 03:46:54 -0400
Received: from barikada.upol.cz ([158.194.242.200]:52268 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910AbXFWHqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 03:46:54 -0400
To: Denis Cheng <crquan@gmail.com>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] trivial: the memset operation on a automatic array variable should be optimized out by data initialization
In-Reply-To: <467cac85.081b600a.5b88.457f@mx.google.com>
References: <467cac85.081b600a.5b88.457f@mx.google.com>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: jed (x86_64-pc-linux-glibc-debian)
X-Mailer: slrn
Date: Sat, 23 Jun 2007 09:59:33 +0200
Message-Id: <E1I20Wr-00064i-T0@flower>
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* From: Denis Cheng
* Newsgroups: linux.kernel
* Date: Fri, 22 Jun 2007 22:15:49 -0700 (PDT)
 
> From: Denis Cheng <crquan@gmail.com>
>
> the explicit memset call could be optimized out by data initialization,
> thus all the fill working can be done by the compiler implicitly.

Can be optimized and can be done by compiler are just words;

> and C standard guaranteed all the unspecified data field initialized to zero.

standards and implementation are on opposite poles of magnet

> Signed-off-by: Denis Cheng <crquan@gmail.com>
>
> ---
> After comments in the former threads:
> http://lkml.org/lkml/2007/6/18/119

i see a patch

> http://lkml.org/lkml/2007/6/18/48

same patch.

> @@ -406,8 +406,8 @@ void __cpuinit zap_low_mappings(int cpu)
>  #ifndef CONFIG_NUMA
>  void __init paging_init(void)
>  {
> -	unsigned long max_zone_pfns[MAX_NR_ZONES];
> -	memset(max_zone_pfns, 0, sizeof(max_zone_pfns));
> +	unsigned long max_zone_pfns[MAX_NR_ZONES] = {};
> +
>  	max_zone_pfns[ZONE_DMA] = MAX_DMA_PFN;
>  	max_zone_pfns[ZONE_DMA32] = MAX_DMA32_PFN;
>  	max_zone_pfns[ZONE_NORMAL] = end_pfn;

Why not just show actual objdump output on code (maybe with different
oxygen atoms used in gcc), rather than *talking* about optimization and
standards, hm?

I bet, that will be a key for success. And if you are interested in such
optimizations, why not to grep whole source tree for this kind of
things? I'm not sure one function in arch/x86_64 is only such ``unoptimized''.
And after doing that maybe you will see, that "{}" initializer can be
applied not only to integer values (you did init with of *long int*,
with *int*, btw), but to structs and others.

Ahh, one more thing about _optimizing_ your time, i.e. not wasting one.

Add to CC list people, who already did reply on you patch. Otherwise
you are showing your disrespect for them and hiding from further
discussion.

I think you do not, but Linux development not have an automatic system
for patch tracking, so you are on your own with your text editor and
e-mail client on this. Please take care for your time.

--
  frenzy
-o--=O`C
 #oo'L O
<___=E M
