Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759803Ab0COIHr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 04:07:47 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:57795 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759776Ab0COIHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 04:07:45 -0400
Date: Mon, 15 Mar 2010 13:37:26 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Avi Kivity <avi@redhat.com>
Cc: KVM development list <kvm@vger.kernel.org>,
       Rik van Riel <riel@surriel.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RF C/T/D] Unmapped page cache control - via boot
 parameter
Message-ID: <20100315080726.GB18054@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20100315072214.GA18054@balbir.in.ibm.com>
 <4B9DE635.8030208@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4B9DE635.8030208@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Avi Kivity <avi@redhat.com> [2010-03-15 09:48:05]:

> On 03/15/2010 09:22 AM, Balbir Singh wrote:
> >Selectively control Unmapped Page Cache (nospam version)
> >
> >From: Balbir Singh<balbir@linux.vnet.ibm.com>
> >
> >This patch implements unmapped page cache control via preferred
> >page cache reclaim. The current patch hooks into kswapd and reclaims
> >page cache if the user has requested for unmapped page control.
> >This is useful in the following scenario
> >
> >- In a virtualized environment with cache!=none, we see
> >   double caching - (one in the host and one in the guest). As
> >   we try to scale guests, cache usage across the system grows.
> >   The goal of this patch is to reclaim page cache when Linux is running
> >   as a guest and get the host to hold the page cache and manage it.
> >   There might be temporary duplication, but in the long run, memory
> >   in the guests would be used for mapped pages.
> 
> Well, for a guest, host page cache is a lot slower than guest page cache.
>

Yes, it is a virtio call away, but is the cost of paying twice in
terms of memory acceptable? One of the reasons I created a boot
parameter was to deal with selective enablement for cases where
memory is the most important resource being managed.

I do see a hit in performance with my results (please see the data
below), but the savings are quite large. The other solution mentioned
in the TODOs is to have the balloon driver invoke this path. The
sysctl also allows the guest to tune the amount of unmapped page cache
if needed.

The knobs are for

1. Selective enablement
2. Selective control of the % of unmapped pages

-- 
	Three Cheers,
	Balbir
