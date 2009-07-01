Return-Path: <linux-kernel-owner+w=401wt.eu-S1755873AbZGAL1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873AbZGAL1S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 07:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753914AbZGAL1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 07:27:08 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:23446 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbZGAL1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 07:27:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rWEkmDFWdjI3TV1iKxfDFACGi/+Pz2gAvtNVw4mMHYZepL17tYSevwzVp85P/wwGhQ
         oXPAzihhy4oH4YEVf7S5pscKsBQJt47Fbed54VSZUCJ+OxPOu0Lh1Y1KGG2s6rDHi8I7
         ICh9RBz54Sd56P5LDxKPGFAqT97Q74tNUtI3o=
Date: Wed, 1 Jul 2009 19:27:05 +0800
From: Wu Fengguang <fengguang.wu@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>, David Woodhouse <dwmw2@infradead.org>,
       David Howells <dhowells@redhat.com>,
       Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "elladan@eskimo.com" <elladan@eskimo.com>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "Barnes, Jesse" <jesse.barnes@intel.com>
Subject: Re: Found the commit that causes the OOMs
Message-ID: <20090701112705.GA3102@localhost>
References: <20090701131734.85D9.A69D9226@jp.fujitsu.com> <20090701042554.GA14344@localhost> <20090701132757.85DC.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090701132757.85DC.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 01, 2009 at 01:30:51PM +0900, KOSAKI Motohiro wrote:
> > > > The question is: Why kswapd reclaims are absent here?

Ah, maybe kswapd simply didn't have the opportunity to be scheduled
for running, because msgctl11 is busy forking thousands of processes?

> > > if direct reclaim isolate all pages, kswapd can't reclaim any pages.
> > 
> > OOM will occur in that condition. What happened before that time?
> 
> maybe yes, maybe no.
> At first test, the system still have droppable file cache. if direct
> reclaim luckly take it, the benchmark become successful end, I
> think.

Yes that's the main difference between first and second run. Note that
file cache can be dropped quickly, while the pageout of tmpfs pages
populated by msgctl11 itself takes time.

Thanks,
Fengguang
