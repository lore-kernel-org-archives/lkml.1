Return-Path: <linux-kernel-owner+w=401wt.eu-S934475AbXEHBcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934475AbXEHBcx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 21:32:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934425AbXEHBct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 21:32:49 -0400
Received: from mga05.intel.com ([192.55.52.89]:15235 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934383AbXEHBcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 21:32:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,502,1170662400"; 
   d="scan'208";a="243141492"
Subject: RE: Regression with SLUB on Netperf and Volanomark
From: Tim Chen <tim.c.chen@linux.intel.com>
Reply-To: tim.c.chen@linux.intel.com
To: Christoph Lameter <clameter@sgi.com>
Cc: "Chen, Tim C" <tim.c.chen@intel.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Zhang, Yanmin" <yanmin.zhang@intel.com>,
       "Wang, Peter Xihong" <peter.xihong.wang@intel.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <Pine.LNX.4.64.0705041800070.28492@schroedinger.engr.sgi.com>
References: <9D2C22909C6E774EBFB8B5583AE5291C02786032@fmsmsx414.amr.corp.intel.com>
	 <Pine.LNX.4.64.0705031839480.16296@schroedinger.engr.sgi.com>
	 <1178322083.23795.217.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0705041800070.28492@schroedinger.engr.sgi.com>
Content-Type: text/plain
Organization: Intel
Date: Mon, 07 May 2007 17:40:34 -0700
Message-Id: <1178584834.15701.18.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-05-04 at 18:02 -0700, Christoph Lameter wrote:
> On Fri, 4 May 2007, Tim Chen wrote:
> 
> > On Thu, 2007-05-03 at 18:45 -0700, Christoph Lameter wrote:
> > > Hmmmm.. One potential issues are the complicated way the slab is 
> > > handled. Could you try this patch and see what impact it has?
> > > 
> > The patch boost the throughput of TCP_STREAM test by 5%, for both slab
> > and slub.  But slab is still 5% better in my tests.
> 
> Really? buffer head handling improves TCP performance? I think you have 
> run to run variances. I need to look at this myself.

I think the object of interest should be sk_buff, not buffer_head. I
made a mistake of accidentally using another config after applying your
buffer head patch.  I compared the kernel again under the same config,
with and without the buffer_head patch. There's no boost to TCP_STREAM
test from the patch.  So things make sense again.  My apology for the
error. 

However, the output from TCP_STREAM is quite stable.  
I am still seeing a 4% difference between the SLAB and SLUB kernel.
Looking at the L2 cache miss rate with emon, I saw 6% more cache miss on
the client side with SLUB.  The server side has the same amount of cache
miss.  This is test under SMP mode with client and server bound to
different core on separate package.

Thanks.

Tim
