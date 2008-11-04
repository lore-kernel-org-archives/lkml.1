Return-Path: <linux-kernel-owner+w=401wt.eu-S1755702AbYKDPkO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702AbYKDPkO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 10:40:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755198AbYKDPj5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 10:39:57 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:59569 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755009AbYKDPj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 10:39:56 -0500
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
In-Reply-To: <200811041635.49932.rjw@sisk.pl>
References: <20081029105956.GA16347@atrey.karlin.mff.cuni.cz>
	 <200811040954.34969.rjw@sisk.pl> <1225812111.12673.577.camel@nimitz>
	 <200811041635.49932.rjw@sisk.pl>
Content-Type: text/plain
Date: Tue, 04 Nov 2008 07:39:42 -0800
Message-Id: <1225813182.12673.587.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-11-04 at 16:35 +0100, Rafael J. Wysocki wrote:
> On Tuesday, 4 of November 2008, Dave Hansen wrote:
> > On Tue, 2008-11-04 at 09:54 +0100, Rafael J. Wysocki wrote:
> > > To handle this, I need to know two things:
> > > 1) what changes of the zones are possible due to memory hotplugging
> > > (i.e.    can they grow, shring, change boundaries etc.)
> > 
> > All of the above. 
> 
> OK
> 
> If I allocate a page frame corresponding to specific pfn, is it guaranteed to
> be associated with the same pfn in future?

Page allocation is different.  Since you hold a reference to a page, it
can not be removed until you release that reference.  That's why every
normal alloc_pages() user in the kernel doesn't have to worry about
memory hotplug.

> > Why walk zones instead of pgdats? 
> 
> This is a historical thing rather than anything else.  I think we could switch
> to pgdats, but that would require a code rewrite that's likely to introduce
> bugs, while our image-creating code is really well tested and doesn't change
> very often.

OK, fair enough.  I just wanted you to know that there are options other
than zones.

-- Dave

