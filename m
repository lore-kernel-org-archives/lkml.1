Return-Path: <linux-kernel-owner+w=401wt.eu-S1757897AbZGGN5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757897AbZGGN5a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 09:57:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757618AbZGGN5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 09:57:19 -0400
Received: from mga14.intel.com ([143.182.124.37]:48132 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757812AbZGGN5S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 09:57:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,362,1243839600"; 
   d="scan'208";a="162317443"
Date: Tue, 7 Jul 2009 21:56:56 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: [PATCH 5/5] add NR_ANON_PAGES to OOM log
Message-ID: <20090707135656.GB9444@localhost>
References: <20090705211739.091D.A69D9226@jp.fujitsu.com> <20090705130200.GA6585@localhost> <20090707102106.0C66.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090707102106.0C66.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 07, 2009 at 09:22:48AM +0800, KOSAKI Motohiro wrote:
> > On Sun, Jul 05, 2009 at 08:21:20PM +0800, KOSAKI Motohiro wrote:
> > > > On Sun, Jul 05, 2009 at 05:26:18PM +0800, KOSAKI Motohiro wrote:

> @@ -2118,9 +2118,9 @@ void show_free_areas(void)
>  	printk("Active_anon:%lu active_file:%lu inactive_anon:%lu\n"
>  		" inactive_file:%lu unevictable:%lu\n"
>  		" isolated_anon:%lu isolated_file:%lu\n"
> -		" dirty:%lu writeback:%lu buffer:%lu unstable:%lu\n"
> +		" dirty:%lu writeback:%lu buffer:%lu shmem:%lu\n"

btw, nfs unstable pages are related to writeback pages, so it may be
better to put "unstable" right after "writeback" (as it was)?

Thanks,
Fengguang


>  		" free:%lu slab_reclaimable:%lu slab_unreclaimable:%lu\n"
> -		" mapped:%lu pagetables:%lu bounce:%lu\n",
> +		" mapped:%lu pagetables:%lu unstable:%lu bounce:%lu\n",
>  		global_page_state(NR_ACTIVE_ANON),
>  		global_page_state(NR_ACTIVE_FILE),
>  		global_page_state(NR_INACTIVE_ANON),
> @@ -2131,12 +2131,13 @@ void show_free_areas(void)
>  		global_page_state(NR_FILE_DIRTY),
>  		global_page_state(NR_WRITEBACK),
>  		nr_blockdev_pages(),
> -		global_page_state(NR_UNSTABLE_NFS),
> +		global_page_state(NR_SHMEM),
>  		global_page_state(NR_FREE_PAGES),
>  		global_page_state(NR_SLAB_RECLAIMABLE),
>  		global_page_state(NR_SLAB_UNRECLAIMABLE),
>  		global_page_state(NR_FILE_MAPPED),
>  		global_page_state(NR_PAGETABLE),
> +		global_page_state(NR_UNSTABLE_NFS),
>  		global_page_state(NR_BOUNCE));

