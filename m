Return-Path: <linux-kernel-owner+w=401wt.eu-S1756534AbZDGO6L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534AbZDGO6L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 10:58:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753469AbZDGO54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 10:57:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40706 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752933AbZDGO5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 10:57:55 -0400
Date: Tue, 7 Apr 2009 07:54:39 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: David Woodhouse <dwmw2@infradead.org>
cc: Ingo Molnar <mingo@elte.hu>, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] intel-iommu: fix build with CONFIG_BRANCH_TRACER=y
In-Reply-To: <1239104035.22733.443.camel@macbook.infradead.org>
Message-ID: <alpine.LFD.2.00.0904070751510.4010@localhost.localdomain>
References: <1238839639.3560.37.camel@macbook.infradead.org>  <20090407053739.GA10500@elte.hu>  <1239083045.22733.383.camel@macbook.infradead.org>  <20090407054818.GA5557@elte.hu> <20090407055245.GA10406@elte.hu>  <1239084280.22733.404.camel@macbook.infradead.org>
  <20090407061558.GA31261@elte.hu> <20090407084950.GA1467@elte.hu>  <20090407090229.GA2467@elte.hu> <1239104035.22733.443.camel@macbook.infradead.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 7 Apr 2009, David Woodhouse wrote:
> 
> But it's a workaround, not a fix -- if we're going to #define if() then
> we should damn well make it transparent, and not have to work around
> breakage in arbitrary places.
> 
> Hence the patch I sent to Linus last night, which fixes it in the
> _right_ place:
> 	http://marc.info/?l=linux-kernel&m=123907505308502&w=2

Oh, Gods. 

It's definitely better in the sense that if we define 'if()', we should 
give it proper C semantics, but it's in some ways even uglier.

Can we please do it something like the following instead:

	#define if(a, ...) \
		__trace_if( (a, ## __VA_ARGS__) )

so that you don't need to do that ", ## __VA_ARGS__" thing three times?

		Linus
