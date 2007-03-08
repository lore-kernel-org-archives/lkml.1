Return-Path: <linux-kernel-owner+w=401wt.eu-S1751549AbXCHMNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751549AbXCHMNh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 07:13:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751553AbXCHMNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 07:13:37 -0500
Received: from amsfep17-int.chello.nl ([213.46.243.15]:10456 "EHLO
	amsfep14-int.chello.nl" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751542AbXCHMNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 07:13:37 -0500
Subject: Re: [RFC][PATCH] mm: fix page_mkclean() vs non-linear vmas
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: npiggin@suse.de, akpm@linux-foundation.org, mingo@elte.hu,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       benh@kernel.crashing.org, jdike@addtoit.com, hugh@veritas.com,
       torvalds@linux-foundation.org
In-Reply-To: <E1HPH6v-0003CT-00@dorka.pomaz.szeredi.hu>
References: <1173264462.6374.140.camel@twins>
	 <20070307110035.GE5555@wotan.suse.de> <1173268086.6374.157.camel@twins>
	 <20070307121730.GC18704@wotan.suse.de> <1173271286.6374.166.camel@twins>
	 <20070307130851.GE18704@wotan.suse.de> <1173273562.6374.175.camel@twins>
	 <20070307133649.GF18704@wotan.suse.de> <1173275532.6374.183.camel@twins>
	 <1173278067.6374.188.camel@twins>  <20070307150102.GH18704@wotan.suse.de>
	 <1173286682.6374.191.camel@twins>
	 <E1HPGg9-00039z-00@dorka.pomaz.szeredi.hu> <1173353824.9438.15.camel@twins>
	 <E1HPH6v-0003CT-00@dorka.pomaz.szeredi.hu>
Content-Type: text/plain
Date: Thu, 08 Mar 2007 13:11:43 +0100
Message-Id: <1173355903.9438.18.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-08 at 12:48 +0100, Miklos Szeredi wrote:
> > However this still leaves the non-linear reclaim (Nick pointed it out as
> > a potential DoS and other people have corroborated this). I have no idea
> > on that to do about that.
> 
> OK, but that is a completely different problem, not affecting
> page_mkclean() or msync().
> 
> And it doesn't sound too hard to solve: when current algorithm doesn't
> seem to be making progress, then it will have to be done the hard way,
> searching for for all nonlinear ptes of a page to unmap.

Ah, you see, but that is when you've already lost.

The DoS is about the computational complexity of the reclaim, not if it
will ever come out of it with free pages.

