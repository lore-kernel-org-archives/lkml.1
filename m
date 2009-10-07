Return-Path: <linux-kernel-owner+w=401wt.eu-S932949AbZJGMVO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932949AbZJGMVO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 08:21:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932873AbZJGMVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 08:21:14 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:49918 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932691AbZJGMVN convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com;4:1>);
	Wed, 7 Oct 2009 08:21:13 -0400
Message-Id: <4ACCA3B402000078000187BE@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 07 Oct 2009 13:20:36 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Hugh Dickins" <hugh.dickins@tiscali.co.uk>
Cc: <linux-mm@kvack.org>, "Andrew Morton" <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] adjust gfp mask passed on nested vmalloc() 
	 invocation
References: <4AC9E38E0200007800017F57@vpn.id2.novell.com>
 <Pine.LNX.4.64.0910062241500.21409@sister.anvils>
 <4ACC62DC0200007800018690@vpn.id2.novell.com>
 <Pine.LNX.4.64.0910071300330.28844@sister.anvils>
In-Reply-To: <Pine.LNX.4.64.0910071300330.28844@sister.anvils>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Hugh Dickins <hugh.dickins@tiscali.co.uk> 07.10.09 14:08 >>>
>Well, now we've accepted that this code cannot be used in_interrupt(),
>there's no need for your #ifdef CONFIG_HIGHMEM nor for my memset: just
>use __GFP_ZERO as it was before, and your patch would amount to or'ing
>__GFP_HIGHMEM into gfp_mask for the __vmalloc_node case - wouldn't it?

Plus the consolidation of masking the passed in gfp_mask by
GFP_RECLAIM_MASK also for the nested vmalloc() case, in particular to
remove the GFP_DMA* possibly coming in from vmalloc_32(). But yes,
it will become simpler.

Jan

