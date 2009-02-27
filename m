Return-Path: <linux-kernel-owner+w=401wt.eu-S1756243AbZB0Li2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243AbZB0Li2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 06:38:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754680AbZB0LiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 06:38:19 -0500
Received: from ns.suse.de ([195.135.220.2]:41452 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753787AbZB0LiT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 06:38:19 -0500
Date: Fri, 27 Feb 2009 12:38:13 +0100
From: Nick Piggin <npiggin@suse.de>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       penberg@cs.helsinki.fi, riel@redhat.com, kosaki.motohiro@jp.fujitsu.com,
       hannes@cmpxchg.org, linux-kernel@vger.kernel.org, ming.m.lin@intel.com,
       yanmin_zhang@linux.intel.com
Subject: Re: [PATCH 20/20] Get rid of the concept of hot/cold page freeing
Message-ID: <20090227113813.GB21296@wotan.suse.de>
References: <20090223013723.1d8f11c1.akpm@linux-foundation.org> <20090223233030.GA26562@csn.ul.ie> <20090223155313.abd41881.akpm@linux-foundation.org> <20090224115126.GB25151@csn.ul.ie> <20090224160103.df238662.akpm@linux-foundation.org> <20090225160124.GA31915@csn.ul.ie> <20090225081954.8776ba9b.akpm@linux-foundation.org> <20090226163751.GG32756@csn.ul.ie> <alpine.DEB.1.10.0902261157100.7472@qirst.com> <20090226171549.GH32756@csn.ul.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090226171549.GH32756@csn.ul.ie>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 26, 2009 at 05:15:49PM +0000, Mel Gorman wrote:
> On Thu, Feb 26, 2009 at 12:00:22PM -0500, Christoph Lameter wrote:
> > I tried the general use of a pool of zeroed pages back in 2005. Zeroing
> > made sense only if the code allocating the page did not immediately touch
> > the cachelines of the page.
> 
> Any feeling as to how often this was the case?

IMO background zeroing or anything like that is only going to
become less attractive. Heat and energy considerations are
relatively increasing, so doing speculative work in the kernel
is going to become relatively more costly. Especially in this
case where you use nontemporal stores or otherwise reduce the
efficiency of the CPU caches (and increase activity on bus and
memory).
