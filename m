Return-Path: <linux-kernel-owner+w=401wt.eu-S1756812AbYKDQ3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812AbYKDQ3m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 11:29:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755512AbYKDQ3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 11:29:30 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:47664 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755932AbYKDQ32 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 11:29:28 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [linux-pm] [PATCH] hibernation should work ok with memory hotplug
Date: Tue, 4 Nov 2008 17:34:03 +0100
User-Agent: KMail/1.9.9
Cc: Nigel Cunningham <ncunningham@crca.org.au>,
       Matt Tolentino <matthew.e.tolentino@intel.com>, linux-pm@lists.osdl.org,
       Dave Hansen <haveblue@us.ibm.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, pavel@suse.cz, Mel Gorman <mel@skynet.ie>,
       Andy Whitcroft <apw@shadowen.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20081029105956.GA16347@atrey.karlin.mff.cuni.cz> <200811041635.49932.rjw@sisk.pl> <1225813182.12673.587.camel@nimitz>
In-Reply-To: <1225813182.12673.587.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811041734.04802.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 4 of November 2008, Dave Hansen wrote:
> On Tue, 2008-11-04 at 16:35 +0100, Rafael J. Wysocki wrote:
> > On Tuesday, 4 of November 2008, Dave Hansen wrote:
> > > On Tue, 2008-11-04 at 09:54 +0100, Rafael J. Wysocki wrote:
> > > > To handle this, I need to know two things:
> > > > 1) what changes of the zones are possible due to memory hotplugging
> > > > (i.e.    can they grow, shring, change boundaries etc.)
> > > 
> > > All of the above. 
> > 
> > OK
> > 
> > If I allocate a page frame corresponding to specific pfn, is it guaranteed to
> > be associated with the same pfn in future?
> 
> Page allocation is different.  Since you hold a reference to a page, it
> can not be removed until you release that reference.  That's why every
> normal alloc_pages() user in the kernel doesn't have to worry about
> memory hotplug.

Good. :-)

So, if I allocate the image pages right prior to creating the image, they
won't be touched by memory hotplug.

Now, I need to do one more thing, which is to check how much memory has to be
freed before creating the image.  For this purpose I need to lock memory
hotplug temporarily, count pages to free and unlock it.  What interface should
I use for this purpose? 

[I'll also need to lock memory hotplug temporarily during resume.]

Rafael
