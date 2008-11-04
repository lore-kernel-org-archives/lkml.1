Return-Path: <linux-kernel-owner+w=401wt.eu-S1754545AbYKDHg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545AbYKDHg2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 02:36:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752476AbYKDHgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 02:36:19 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:46768 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780AbYKDHgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 02:36:18 -0500
Subject: Re: [linux-pm] [PATCH] hibernation should work ok with memory
	hotplug
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Nigel Cunningham <ncunningham@crca.org.au>,
       Matt Tolentino <matthew.e.tolentino@intel.com>, linux-pm@lists.osdl.org,
       Dave Hansen <haveblue@us.ibm.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, pavel@suse.cz, Mel Gorman <mel@skynet.ie>,
       Andy Whitcroft <apw@shadowen.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <200811040808.36464.rjw@sisk.pl>
References: <20081029105956.GA16347@atrey.karlin.mff.cuni.cz>
	 <1225751665.12673.511.camel@nimitz> <1225771353.6755.16.camel@nigel-laptop>
	 <200811040808.36464.rjw@sisk.pl>
Content-Type: text/plain
Date: Mon, 03 Nov 2008 23:36:14 -0800
Message-Id: <1225784174.12673.547.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-11-04 at 08:08 +0100, Rafael J. Wysocki wrote:
> A pfn always refers to specific page frame and/or struct page, so yes.
> However, in one of the nodes these pfns are sort of "invalid" (they point
> to struct pages belonging to other zones).  AFAICS.

Part of this problem is getting out of the old zone mindset.  It used to
be that there were one, two, or three zones, set up at boot, with static
ranges.  These never had holes, never changed, and were always stacked
up nice and tightly on top of one another.  It ain't that way no more.

Now, the zones are much more truly "allocation pools".  They're bunches
of memory with similar attributes and hypervisors or firmware can hand
them to the OS in very interesting ways.  This means that the attributes
that help us pool the memory together have less and less to do with
physical addresses.  A given physical address a decreasing chance of
being related to its neighbor.

-- Dave

