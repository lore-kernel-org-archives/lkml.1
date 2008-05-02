Return-Path: <linux-kernel-owner+w=401wt.eu-S964950AbYEBR1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964950AbYEBR1x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 13:27:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934894AbYEBR1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 13:27:31 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:46566 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934675AbYEBR1a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 13:27:30 -0400
Subject: Re: [PATCH] Add sysfs removable attribute for hotplug memory remove
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Badari Pulavarty <pbadari@us.ibm.com>
Cc: akpm@linux-foundation.org, Mel Gorman <mel@csn.ul.ie>,
       "kamezawa.hiroyu" <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1209747376.16169.27.camel@badari-desktop>
References: <1209747376.16169.27.camel@badari-desktop>
Content-Type: text/plain
Date: Fri, 02 May 2008 10:27:21 -0700
Message-Id: <1209749241.7763.44.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-05-02 at 09:56 -0700, Badari Pulavarty wrote:
> 
> +/* Return the start of the next active pageblock after a given page */
> +static struct page *next_active_pageblock(struct page *page)
> +{
> +       /* Ensure the starting page is pageblock-aligned */
> +       BUG_ON(page_to_pfn(page) & (pageblock_nr_pages - 1));
> +
> +       /* Move forward by at least 1 * pageblock_nr_pages */
> +       int pageblocks_stride = 1;
> +
> +       /* If the entire pageblock is free, move to the end of free page */
> +       if (pageblock_free(page))
> +               pageblocks_stride += page_order(page) - pageblock_order;
> +
> +       return page + (pageblocks_stride * pageblock_nr_pages);
> +}

Do you really want that variable declared in the middle of the function?

Otherwise looks fine to me.  I'm a bit worried about the whole "scan
every page in the section" thing.  That could get expensive if people
ever decided to poll this file.  Maybe we should tell our potential
users about that.

-- Dave

