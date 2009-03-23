Return-Path: <linux-kernel-owner+w=401wt.eu-S1759182AbZCWPnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759182AbZCWPnU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 11:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757772AbZCWPnE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 11:43:04 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:57489 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755737AbZCWPnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 11:43:01 -0400
Date: Mon, 23 Mar 2009 11:39:17 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Mel Gorman <mel@csn.ul.ie>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       riel@redhat.com,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH] fix vmscan to take care of nodemask
In-Reply-To: <2f11576a0903230831r72892eadoabfc0f128e9f55a6@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0903231137010.11796@qirst.com>
References: <20090323100356.e980d266.kamezawa.hiroyu@jp.fujitsu.com>  <20090323114814.GB6484@csn.ul.ie>  <alpine.DEB.1.10.0903230936130.4095@qirst.com> <2f11576a0903230831r72892eadoabfc0f128e9f55a6@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Mar 2009, KOSAKI Motohiro wrote:

> 2009/3/23 Christoph Lameter <cl@linux-foundation.org>:
> > On Mon, 23 Mar 2009, Mel Gorman wrote:
> >
> >> try_to_free_pages() is used for the direct reclaim of up to
> >> SWAP_CLUSTER_MAX pages when watermarks are low. The caller to
> >> alloc_pages_nodemask() can specify a nodemask of nodes that are allowed
> >> to be used but this is not passed to try_to_free_pages(). This can lead
> >> to the unnecessary reclaim of pages that are unusable by the caller and
> >> in the worst case lead to allocation failure as progress was not been
> >> made where it is needed.
> >>
> >> This patch passes the nodemask used for alloc_pages_nodemask() to
> >> try_to_free_pages().
> >
> > This is only useful for MPOL_BIND. Direct reclaim within a cpuset already
> > honors the boundaries of the cpuset.
>
> Do you mean nak or comment adding request?
> I agree you. but I don't find any weak point of this patch.

Just a comment.

