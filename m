Return-Path: <linux-kernel-owner+w=401wt.eu-S1755693AbZDUIso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693AbZDUIso (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 04:48:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754549AbZDUIsb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 04:48:31 -0400
Received: from gir.skynet.ie ([193.1.99.77]:43605 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752545AbZDUIsa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 04:48:30 -0400
Date: Tue, 21 Apr 2009 09:48:27 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 13/25] Inline __rmqueue_smallest()
Message-ID: <20090421084827.GF12713@csn.ul.ie>
References: <1240266011-11140-1-git-send-email-mel@csn.ul.ie> <1240266011-11140-14-git-send-email-mel@csn.ul.ie> <1240300695.771.54.camel@penberg-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1240300695.771.54.camel@penberg-laptop>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 21, 2009 at 10:58:15AM +0300, Pekka Enberg wrote:
> On Mon, 2009-04-20 at 23:19 +0100, Mel Gorman wrote:
> > Inline __rmqueue_smallest by altering flow very slightly so that there
> > is only one call site. This allows the function to be inlined without
> > additional text bloat.
> 
> Quite frankly, I think these patch changelogs could use some before and
> after numbers for "size mm/page_alloc.o" because it's usually the case
> that kernel text shrinks when you _remove_ inlines.
> 

I can generate that although it'll be a bit misleading because stack
parameters are added earlier in the series that get eliminated later due
to inlines. Shuffling them around won't help a whole lot.

Inline for only one call site though saves text in this series. For a
non-inlined function, the calling convension has to be obeyed and for a
large number of parameters like this functions, that can be sizable.

I'll regenerate the figures though.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
