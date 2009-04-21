Return-Path: <linux-kernel-owner+w=401wt.eu-S1754889AbZDUI32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889AbZDUI32 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 04:29:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753610AbZDUI3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 04:29:19 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:37722 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754AbZDUI3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 04:29:18 -0400
Subject: Re: [PATCH 08/25] Calculate the preferred zone for allocation only
 once
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090421082732.GB12713@csn.ul.ie>
References: <1240266011-11140-1-git-send-email-mel@csn.ul.ie>
	 <1240266011-11140-9-git-send-email-mel@csn.ul.ie>
	 <1240299457.771.42.camel@penberg-laptop> <20090421082732.GB12713@csn.ul.ie>
Date: Tue, 21 Apr 2009 11:29:16 +0300
Message-Id: <1240302556.771.65.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-21 at 09:27 +0100, Mel Gorman wrote:
> > You might want to add an explanation to the changelog why this change is
> > safe. It looked like a functional change at first glance and it was
> > pretty difficult to convince myself that __alloc_pages_slowpath() will
> > always return NULL when there's no preferred zone because of the other
> > cleanups in this patch series.
> > 
> 
> Is this better?
> 
> get_page_from_freelist() can be called multiple times for an allocation.
> Part of this calculates the preferred_zone which is the first usable zone in
> the zonelist but the zone depends on the GFP flags specified at the beginning
> of the allocation call. This patch calculates preferred_zone once. It's safe
> to do this because if preferred_zone is NULL at the start of the call, no
> amount of direct reclaim or other actions will change the fact the allocation
> will fail.

Perfect!

