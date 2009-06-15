Return-Path: <linux-kernel-owner+w=401wt.eu-S1760948AbZFOPKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760948AbZFOPKW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 11:10:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757521AbZFOPKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 11:10:09 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:53839 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751501AbZFOPKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 11:10:07 -0400
Date: Mon, 15 Jun 2009 11:01:41 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Mel Gorman <mel@csn.ul.ie>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>, riel@redhat.com,
       fengguang.wu@intel.com, linuxram@us.ibm.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 0/3] Fix malloc() stall in zone_reclaim() and bring
 behaviour more in line with expectations V3
In-Reply-To: <20090615105651.GD23198@csn.ul.ie>
Message-ID: <alpine.DEB.1.10.0906151057270.23995@gentwo.org>
References: <20090611163006.e985639f.akpm@linux-foundation.org> <20090612110424.GD14498@csn.ul.ie> <20090615163018.B43A.A69D9226@jp.fujitsu.com> <20090615105651.GD23198@csn.ul.ie>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Jun 2009, Mel Gorman wrote:

> > May I ask your worry?
> >
>
> Simply that I believe the intention of PF_SWAPWRITE here was to allow
> zone_reclaim() to aggressively reclaim memory if the reclaim_mode allowed
> it as it was a statement that off-node accesses are really not desired.

Right.

> Ok. I am not fully convinced but I'll not block it either if believe it's
> necessary. My current understanding is that this patch only makes a difference
> if the server is IO congested in which case the system is struggling anyway
> and an off-node access is going to be relatively small penalty overall.
> Conceivably, having PF_SWAPWRITE set makes things worse in that situation
> and the patch makes some sense.

We could drop support for RECLAIM_SWAP if that simplifies things.

