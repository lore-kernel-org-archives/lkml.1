Return-Path: <linux-kernel-owner+w=401wt.eu-S1761948AbZCPSBg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761948AbZCPSBg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 14:01:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760408AbZCPRz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 13:55:27 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:43533 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761021AbZCPRzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 13:55:25 -0400
Date: Mon, 16 Mar 2009 12:30:02 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Mel Gorman <mel@csn.ul.ie>
cc: Linux Memory Management List <linux-mm@kvack.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 29/35] Do not store the PCP high and batch watermarks in
 the per-cpu structure
In-Reply-To: <1237196790-7268-30-git-send-email-mel@csn.ul.ie>
Message-ID: <alpine.DEB.1.10.0903161228120.32577@qirst.com>
References: <1237196790-7268-1-git-send-email-mel@csn.ul.ie> <1237196790-7268-30-git-send-email-mel@csn.ul.ie>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Mar 2009, Mel Gorman wrote:

> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -166,8 +166,6 @@ static inline int is_unevictable_lru(enum lru_list l)
>
>  struct per_cpu_pages {
>  	int count;		/* number of pages in the list */
> -	int high;		/* high watermark, emptying needed */
> -	int batch;		/* chunk size for buddy add/remove */


There is a hole here on 64 bit systems.

>
>  	/* Lists of pages, one per migrate type stored on the pcp-lists */
>  	struct list_head lists[MIGRATE_PCPTYPES];
> @@ -285,6 +283,12 @@ struct zone {
>  		unsigned long pages_mark[3];
>  	};
>
> +	/* high watermark for per-cpu lists, emptying needed */
> +	u16 pcp_high;
> +
> +	/* chunk size for buddy add/remove to per-cpu lists*/
> +	u16 pcp_batch;
> +

Move this up to fill the hole?

