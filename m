Return-Path: <linux-kernel-owner+w=401wt.eu-S1755606AbYKEQX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606AbYKEQX5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 11:23:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752271AbYKEQXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 11:23:48 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:51677 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237AbYKEQXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 11:23:48 -0500
Subject: Re: [linux-pm] [PATCH] hibernation should work ok with memory
	hotplug
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Nigel Cunningham <ncunningham@crca.org.au>
Cc: Matt Tolentino <matthew.e.tolentino@intel.com>, linux-pm@lists.osdl.org,
       Dave Hansen <haveblue@us.ibm.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, pavel@suse.cz, Mel Gorman <mel@skynet.ie>,
       Andy Whitcroft <apw@shadowen.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1225876205.6755.55.camel@nigel-laptop>
References: <20081029105956.GA16347@atrey.karlin.mff.cuni.cz>
	 <20081103125108.46d0639e.akpm@linux-foundation.org>
	 <1225747308.12673.486.camel@nimitz>  <200811032324.02163.rjw@sisk.pl>
	 <1225751665.12673.511.camel@nimitz> <1225771353.6755.16.camel@nigel-laptop>
	 <1225782572.12673.540.camel@nimitz> <1225783837.6755.33.camel@nigel-laptop>
	 <1225785224.12673.564.camel@nimitz> <1225876205.6755.55.camel@nigel-laptop>
Content-Type: text/plain
Date: Wed, 05 Nov 2008 08:23:43 -0800
Message-Id: <1225902223.12673.616.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-11-05 at 20:10 +1100, Nigel Cunningham wrote:
> In your example above, zone_start_pfn will be 1, won't it? If that's the
> case, I shouldn't need to subtract ARCH_PFN_OFFSET to get the right
> index within the zone and avoid the same wastage that ARCH_PFN_OFFSET
> avoids with mem_map.

Yeah, I don't think the first zone will ever start before
ARCH_PFN_OFFSET.

If the code just deals with starting at any random zone_start_pfn and
going to any other random zone_end_pfn without any waste, then it should
be fine in the presence of ARCH_PFN_OFFSET.  The only trouble is if it
assumes memory to start at 0x0.

-- Dave

