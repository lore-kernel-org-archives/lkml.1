Return-Path: <linux-kernel-owner+w=401wt.eu-S1755144AbYKDPWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144AbYKDPWT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 10:22:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753560AbYKDPWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 10:22:09 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:50664 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536AbYKDPWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 10:22:08 -0500
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
In-Reply-To: <200811040954.34969.rjw@sisk.pl>
References: <20081029105956.GA16347@atrey.karlin.mff.cuni.cz>
	 <200811040808.36464.rjw@sisk.pl> <1225784174.12673.547.camel@nimitz>
	 <200811040954.34969.rjw@sisk.pl>
Content-Type: text/plain
Date: Tue, 04 Nov 2008 07:21:51 -0800
Message-Id: <1225812111.12673.577.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-11-04 at 09:54 +0100, Rafael J. Wysocki wrote:
> To handle this, I need to know two things:
> 1) what changes of the zones are possible due to memory hotplugging
> (i.e.    can they grow, shring, change boundaries etc.)

All of the above. 

> 2) what kind of locking is needed to prevent zones from changing.

The amount of locking is pretty minimal.  We depend on some locking in
sysfs to keep two attempts to online from stepping on the other.

There is the zone_span_seq*() set of functions.  These are used pretty
sparsely, but we do use them in page_outside_zone_boundaries() to notice
when a zone is resized.

There are also the pgdat_resize*() locks.  Those are more for internal
use guarding the sparsemem structures and so forth.

Could you describe a little more why you need to lock down zone
resizing?  Do you *really* mean zones, or do you mean "the set of memory
on the system"?  Why walk zones instead of pgdats?

-- Dave

