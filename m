Return-Path: <linux-kernel-owner+w=401wt.eu-S1751384AbXCLSgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751384AbXCLSgV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 14:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751385AbXCLSgV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 14:36:21 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:34885 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384AbXCLSgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 14:36:20 -0400
Subject: Re: [PATCH 1/3] Lumpy Reclaim V4
From: Dave Hansen <hansendc@us.ibm.com>
To: Andy Whitcroft <apw@shadowen.org>
Cc: Andrew Morton <akpm@osdl.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>
In-Reply-To: <5239d2d31cd39bf4fc33426648f97be0@pinky>
References: <exportbomb.1173723760@pinky>
	 <5239d2d31cd39bf4fc33426648f97be0@pinky>
Content-Type: text/plain
Date: Mon, 12 Mar 2007 11:36:16 -0700
Message-Id: <1173724576.11945.100.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-12 at 18:23 +0000, Andy Whitcroft wrote:
> 
> +                       /* The target page is in the block, ignore it. */
> +                       if (unlikely(pfn == page_pfn))
> +                               continue;
> +#ifdef CONFIG_HOLES_IN_ZONE
> +                       /* Avoid holes within the zone. */
> +                       if (unlikely(!pfn_valid(pfn)))
> +                               break;
> +#endif 

Would having something like:

        static inline int pfn_in_zone_hole(unsigned long pfn)
        {
        #ifdef CONFIG_HOLES_IN_ZONE
        	if (unlikely(!pfn_valid(pfn)))
        		return 1;
        #endif 
        	return 0;
        }
        
help us out?  page_is_buddy() and page_is_consistent() appear to do the
exact same thing, with the same #ifdef.

-- Dave

