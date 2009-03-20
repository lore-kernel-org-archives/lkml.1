Return-Path: <linux-kernel-owner+w=401wt.eu-S1758065AbZCTP3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758065AbZCTP3g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 11:29:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751315AbZCTP31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 11:29:27 -0400
Received: from gir.skynet.ie ([193.1.99.77]:56477 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754731AbZCTP30 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 11:29:26 -0400
Date: Fri, 20 Mar 2009 15:29:21 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 08/25] Calculate the preferred zone for allocation only
	once
Message-ID: <20090320152921.GN24586@csn.ul.ie>
References: <1237543392-11797-1-git-send-email-mel@csn.ul.ie> <1237543392-11797-9-git-send-email-mel@csn.ul.ie> <alpine.DEB.1.10.0903201105530.3740@qirst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0903201105530.3740@qirst.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 20, 2009 at 11:06:46AM -0400, Christoph Lameter wrote:
> On Fri, 20 Mar 2009, Mel Gorman wrote:
> 
> > get_page_from_freelist() can be called multiple times for an allocation.
> > Part of this calculates the preferred_zone which is the first usable
> > zone in the zonelist. This patch calculates preferred_zone once.
> 
> Isnt this adding an additional pass over the zonelist? Maybe mitigaged by
> the first zone usually being the preferred zone.
> 

The alternative is uglifing the iterator quite a bit and making the code a
bit impeneratable. The walk to the first preferred zone should be very short.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
