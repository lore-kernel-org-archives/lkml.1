Return-Path: <linux-kernel-owner+w=401wt.eu-S932459AbYEUJOG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932459AbYEUJOG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 05:14:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754513AbYEUJNx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 05:13:53 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58766 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbYEUJNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 05:13:53 -0400
Subject: Re: kswapd busy but not swapping
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Christian Kujau <lists@nerdbynature.de>
Cc: LKML <linux-kernel@vger.kernel.org>, kanoj@netxen.com
In-Reply-To: <alpine.DEB.1.10.0805210050440.13780@sheep.housecafe.de>
References: <alpine.DEB.1.10.0805210050440.13780@sheep.housecafe.de>
Content-Type: text/plain
Date: Wed, 21 May 2008 11:13:37 +0200
Message-Id: <1211361217.6463.61.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-05-21 at 01:04 +0200, Christian Kujau wrote:
> Hi,
> 
> I noticed that the [kswapd0] thread was eating 3-7% cpu time but no 
> swapspace has been used yet. This is with a just booted 2.6.25.4 system,
> currently with some disk i/o going on.
> 
> So I figured that kswapd might not be responsible for "swapping" after 
> all, although the name suggests it. Grep'ing Documentation/ for kswapd did 
> not reveal much. Is the paper from Kanoj[0] still valid for 2.6 kernels? 
> The SGI page referenced in Documentation/kernel-docs.txt is down, but 
> there's a .txt version on [1] which tells me:
> 
>    "When memory runs low, and a process can not find a free page, it wakes
>     up kswapd, the memory stealer"
> 
> So, if I'd run low on memory, kswapd would be active. But I don't see that 
> in free(1):
> 
> # free -m
>               total       used       free     shared    buffers     cached
> Mem:          2023       1662        360          0        820        315
> -/+ buffers/cache:        526       1496
> Swap:         1505          0       1505

It could have been busy reclaiming pagecache.

kswapd is the generic reclaim thread - paging anonymous memory to the
swap is but one form thereof.

