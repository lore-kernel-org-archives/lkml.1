Return-Path: <linux-kernel-owner+w=401wt.eu-S1754813AbZDWIEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813AbZDWIEk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 04:04:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758852AbZDWHo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 03:44:56 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:53550 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758816AbZDWHoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 03:44:55 -0400
Subject: Re: [PATCH 02/22] Do not sanity check order in the fast path
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Dave Hansen <dave@linux.vnet.ibm.com>,
       Linux Memory Management List <linux-mm@kvack.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.0904221244030.14558@chino.kir.corp.google.com>
References: <1240408407-21848-1-git-send-email-mel@csn.ul.ie>
	 <1240408407-21848-3-git-send-email-mel@csn.ul.ie>
	 <1240416791.10627.78.camel@nimitz> <20090422171151.GF15367@csn.ul.ie>
	 <alpine.DEB.2.00.0904221244030.14558@chino.kir.corp.google.com>
Date: Thu, 23 Apr 2009 10:44:53 +0300
Message-Id: <1240472693.16082.56.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-22 at 13:11 -0700, David Rientjes wrote:
> On Wed, 22 Apr 2009, Mel Gorman wrote:
> 
> > If there are users with good reasons, then we could convert this to WARN_ON
> > to fix up the callers. I suspect that the allocator can already cope with
> > recieving a stupid order silently but slowly. It should go all the way to the
> > bottom and just never find anything useful and return NULL.  zone_watermark_ok
> > is the most dangerous looking part but even it should never get to MAX_ORDER
> > because it should always find there are not enough free pages and return
> > before it overruns.

> slub: enforce MAX_ORDER
> 
> slub_max_order may not be equal to or greater than MAX_ORDER.
> 
> Additionally, if a single object cannot be placed in a slab of
> slub_max_order, it still must allocate slabs below MAX_ORDER.
> 
> Cc: Christoph Lameter <cl@linux-foundation.org>
> Signed-off-by: David Rientjes <rientjes@google.com>

Applied, thanks!

