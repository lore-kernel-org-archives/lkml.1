Return-Path: <linux-kernel-owner+w=401wt.eu-S1752863AbYAWVgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863AbYAWVgv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 16:36:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751261AbYAWVgn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 16:36:43 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:56827 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103AbYAWVgm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 16:36:42 -0500
Date: Wed, 23 Jan 2008 13:36:37 -0800
From: Nishanth Aravamudan <nacc@us.ibm.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Mel Gorman <mel@csn.ul.ie>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       lee.schermerhorn@hp.com, Linux MM <linux-mm@kvack.org>,
       Olaf Hering <olaf@aepfle.de>
Subject: Re: [PATCH] Fix boot problem in situations where the boot CPU is
	running on a memoryless node
Message-ID: <20080123213637.GE3848@us.ibm.com>
References: <20080123125236.GA18876@aepfle.de> <20080123135513.GA14175@csn.ul.ie> <Pine.LNX.4.64.0801231611160.20050@sbz-30.cs.Helsinki.FI> <Pine.LNX.4.64.0801231626320.21475@sbz-30.cs.Helsinki.FI> <Pine.LNX.4.64.0801231648140.23343@sbz-30.cs.Helsinki.FI> <20080123155655.GB20156@csn.ul.ie> <Pine.LNX.4.64.0801231906520.1028@sbz-30.cs.Helsinki.FI> <20080123195220.GB3848@us.ibm.com> <84144f020801231302g2cafdda9kf7f916121dc56aa5@mail.gmail.com> <Pine.LNX.4.64.0801231312580.15681@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0801231312580.15681@schroedinger.engr.sgi.com>
X-Operating-System: Linux 2.6.24-4-generic (i686)
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.01.2008 [13:14:26 -0800], Christoph Lameter wrote:
> On Wed, 23 Jan 2008, Pekka Enberg wrote:
> 
> > I think Mel said that their configuration did work with 2.6.23
> > although I also wonder how that's possible. AFAIK there has been some
> > changes in the page allocator that might explain this. That is, if
> > kmem_getpages() returned pages for memoryless node before, bootstrap
> > would have worked.
> 
> Regular kmem_getpages is called with GFP_THISNODE set. There was some
> breakage in 2.6.22 and before with GFP_THISNODE returning pages from
> the wrong node if a node had no memory. So it may have worked
> accidentally and in an unsafe manner because the pages would have been
> associated with the wrong node which could trigger bug ons and locking
> troubles.

Right, so it might have functioned before, but the correctness was
wobbly at best... Certainly the memoryless patch series has tightened
that up, but we missed these SLAB issues.

I see that your patch fixed Olaf's machine, Pekka. Nice work on
everyone's part tracking this stuff down.

Thanks,
Nish
