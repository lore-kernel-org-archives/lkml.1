Return-Path: <linux-kernel-owner+w=401wt.eu-S1754584AbYKDEQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584AbYKDEQs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 23:16:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754165AbYKDEQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 23:16:36 -0500
Received: from mail.crca.org.au ([67.207.131.56]:48372 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753912AbYKDEQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 23:16:35 -0500
X-Bogosity: Ham, spamicity=0.000000
Subject: Re: [linux-pm] [PATCH] hibernation should work ok with memory
	hotplug
From: Nigel Cunningham <ncunningham@crca.org.au>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matt Tolentino <matthew.e.tolentino@intel.com>, linux-pm@lists.osdl.org,
       Dave Hansen <haveblue@us.ibm.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, pavel@suse.cz, Mel Gorman <mel@skynet.ie>,
       Andy Whitcroft <apw@shadowen.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1225751665.12673.511.camel@nimitz>
References: <20081029105956.GA16347@atrey.karlin.mff.cuni.cz>
	 <20081103125108.46d0639e.akpm@linux-foundation.org>
	 <1225747308.12673.486.camel@nimitz>  <200811032324.02163.rjw@sisk.pl>
	 <1225751665.12673.511.camel@nimitz>
Content-Type: text/plain
Organization: Christian Reformed Churches of Australia
Date: Tue, 04 Nov 2008 15:02:33 +1100
Message-Id: <1225771353.6755.16.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Mon, 2008-11-03 at 14:34 -0800, Dave Hansen wrote:
> A node might have a node_start_pfn=0 and a node_end_pfn=100 (and it may
> have only one zone).  But, there may be another node with
> node_start_pfn=10 and a node_end_pfn=20.  This loop:
> 
>         for_each_zone(zone) {
> 		...
>                 for (pfn = zone->zone_start_pfn; pfn < max_zone_pfn; pfn++)
>                         if (page_is_saveable(zone, pfn))
>                                 memory_bm_set_bit(orig_bm, pfn);
>         }
> 
> will walk over the smaller node's pfn range multiple times.  Is this OK?
> 
> I think all you have to do to fix it is check page_zone(page) == zone
> and skip out if they don't match.

So pfn 10 in the first node refers to the same memory as pfn 10 in the
second node?

Regards,

Nigel

