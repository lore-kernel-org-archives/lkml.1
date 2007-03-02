Return-Path: <linux-kernel-owner+w=401wt.eu-S2992672AbXCBRjM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992672AbXCBRjM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 12:39:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992678AbXCBRjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 12:39:11 -0500
Received: from mga06.intel.com ([134.134.136.21]:15701 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992675AbXCBRjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 12:39:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,243,1170662400"; 
   d="scan'208"; a="203346316:sNHT28482097"
Date: Fri, 2 Mar 2007 09:35:27 -0800
From: Mark Gross <mgross@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Balbir Singh <balbir@in.ibm.com>, Mel Gorman <mel@skynet.ie>,
       npiggin@suse.de, clameter@engr.sgi.com, mingo@elte.hu,
       jschopp@austin.ibm.com, arjan@infradead.org, mbligh@mbligh.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: The performance and behaviour of the anti-fragmentation related patches
Message-ID: <20070302173527.GA7280@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <20070301101249.GA29351@skynet.ie> <20070301160915.6da876c5.akpm@linux-foundation.org> <Pine.LNX.4.64.0703011642190.12485@woody.linux-foundation.org> <45E7835A.8000908@in.ibm.com> <Pine.LNX.4.64.0703011939120.12485@woody.linux-foundation.org> <20070301195943.8ceb221a.akpm@linux-foundation.org> <Pine.LNX.4.64.0703012105080.3953@woody.linux-foundation.org> <20070302162023.GA4691@linux.intel.com> <20070302090753.b06ed267.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070302090753.b06ed267.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 02, 2007 at 09:07:53AM -0800, Andrew Morton wrote:
> On Fri, 2 Mar 2007 08:20:23 -0800 Mark Gross <mgross@linux.intel.com> wrote:
> 
> > > The whole DRAM power story is a bedtime story for gullible children. Don't 
> > > fall for it. It's not realistic. The hardware support for it DOES NOT 
> > > EXIST today, and probably won't for several years. And the real fix is 
> > > elsewhere anyway (ie people will have to do a FBDIMM-2 interface, which 
> > > is against the whole point of FBDIMM in the first place, but that's what 
> > > you get when you ignore power in the first version!).
> > >
> > 
> > Hardware support for some of this is coming this year in the ATCA space
> > on the MPCBL0050.  The feature is a bit experimental, and
> > power/performance benefits will be workload and configuration
> > dependent.  Its not a bed time story.
> 
> What is the plan for software support?

The plan is the typical layered approach to enabling.  Post the basic
enabling patch, followed by a patch or software to actually exercise the
feature.

The code to exercise the feature is complicated by the fact that the
memory will need re-training as it comes out of low power state.  The
code doing this is still a bit confidential.

I have the base enabling patch ready for RFC review.
I'm working on the RFC now.

> 
> Will it be possible to just power the DIMMs off?  I don't see much point in
> some half-power non-destructive mode.

I think so, but need to double check with the HW folks.

Technically, the dims could be powered off, and put into 2 different low
power non-destructive states.  (standby and suspend), but putting them
in a low power non-destructive mode has much less latency and provides
good bang for the buck or LOC change needed to make work.

Which lower power mode an application chooses will depend on latency
tolerances of the app.  For the POC activities we are looking at we are
targeting the lower latency option, but that doesn't lock out folks from
trying to do something with the other options.

--mgross

