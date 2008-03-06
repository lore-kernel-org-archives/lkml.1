Return-Path: <linux-kernel-owner+w=401wt.eu-S1755458AbYCFTNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458AbYCFTNA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 14:13:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763092AbYCFTMm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 14:12:42 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:15093 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755035AbYCFTMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 14:12:40 -0500
Date: Thu, 6 Mar 2008 11:08:47 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Badari Pulavarty <pbadari@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       paulus@samba.org, Yasunori Goto <y-goto@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/5] generic __remove_pages() support
Message-Id: <20080306110847.11d7cb26.randy.dunlap@oracle.com>
In-Reply-To: <1204829734.7939.61.camel@dyn9047017100.beaverton.ibm.com>
References: <1204829673.7939.59.camel@dyn9047017100.beaverton.ibm.com>
	<1204829734.7939.61.camel@dyn9047017100.beaverton.ibm.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 Mar 2008 10:55:34 -0800 Badari Pulavarty wrote:

> Generic helper function to remove section mappings and sysfs entries
> for the section of the memory we are removing.  offline_pages() correctly 
> adjusted zone and marked the pages reserved.

Such generic (exported, non-static) interfaces could use some
(kernel-)docs, please.

> Issue: If mem_map, usemap allocation could come from different places -
> kmalloc, vmalloc, alloc_pages or bootmem. There is no easy way
> to find and free up bootmem allocations.
> 
> Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
> 
> ---
>  include/linux/memory_hotplug.h |    4 +++
>  mm/memory_hotplug.c            |   44 +++++++++++++++++++++++++++++++++++++++++
>  mm/sparse.c                    |   43 +++++++++++++++++++++++++++++++++++++---
>  3 files changed, 88 insertions(+), 3 deletions(-)

> Index: linux-2.6.25-rc2/include/linux/memory_hotplug.h
> ===================================================================
> --- linux-2.6.25-rc2.orig/include/linux/memory_hotplug.h	2008-02-27 12:58:17.000000000 -0800
> +++ linux-2.6.25-rc2/include/linux/memory_hotplug.h	2008-02-27 13:00:04.000000000 -0800
> @@ -64,6 +65,8 @@ extern int offline_pages(unsigned long, 
>  /* reasonably generic interface to expand the physical pages in a zone  */
>  extern int __add_pages(struct zone *zone, unsigned long start_pfn,
>  	unsigned long nr_pages);
> +extern int __remove_pages(struct zone *zone, unsigned long start_pfn,
> +	unsigned long nr_pages);
>  
>  /*
>   * Walk thorugh all memory which is registered as resource.

           through :)

---
~Randy
