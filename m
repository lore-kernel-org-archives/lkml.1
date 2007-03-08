Return-Path: <linux-kernel-owner+w=401wt.eu-S1751450AbXCHLta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751450AbXCHLta (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 06:49:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751493AbXCHLt3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 06:49:29 -0500
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:57106 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450AbXCHLt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 06:49:29 -0500
To: a.p.zijlstra@chello.nl
CC: npiggin@suse.de, akpm@linux-foundation.org, mingo@elte.hu,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       benh@kernel.crashing.org, jdike@addtoit.com, hugh@veritas.com,
       torvalds@linux-foundation.org
In-reply-to: <1173353824.9438.15.camel@twins> (message from Peter Zijlstra on
	Thu, 08 Mar 2007 12:37:04 +0100)
Subject: Re: [RFC][PATCH] mm: fix page_mkclean() vs non-linear vmas
References: <1173264462.6374.140.camel@twins>
	 <20070307110035.GE5555@wotan.suse.de> <1173268086.6374.157.camel@twins>
	 <20070307121730.GC18704@wotan.suse.de> <1173271286.6374.166.camel@twins>
	 <20070307130851.GE18704@wotan.suse.de> <1173273562.6374.175.camel@twins>
	 <20070307133649.GF18704@wotan.suse.de> <1173275532.6374.183.camel@twins>
	 <1173278067.6374.188.camel@twins>  <20070307150102.GH18704@wotan.suse.de>
	 <1173286682.6374.191.camel@twins>
	 <E1HPGg9-00039z-00@dorka.pomaz.szeredi.hu> <1173353824.9438.15.camel@twins>
Message-Id: <E1HPH6v-0003CT-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 08 Mar 2007 12:48:41 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> However this still leaves the non-linear reclaim (Nick pointed it out as
> a potential DoS and other people have corroborated this). I have no idea
> on that to do about that.

OK, but that is a completely different problem, not affecting
page_mkclean() or msync().

And it doesn't sound too hard to solve: when current algorithm doesn't
seem to be making progress, then it will have to be done the hard way,
searching for for all nonlinear ptes of a page to unmap.

Miklos
