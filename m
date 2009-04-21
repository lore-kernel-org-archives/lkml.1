Return-Path: <linux-kernel-owner+w=401wt.eu-S1756942AbZDUKbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756942AbZDUKbo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 06:31:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753831AbZDUKba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 06:31:30 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47525 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172AbZDUKb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 06:31:29 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 12/25] Remove a branch by assuming __GFP_HIGH == ALLOC_HIGH
Cc: kosaki.motohiro@jp.fujitsu.com,
       Linux Memory Management List <linux-mm@kvack.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090421180757.F145.A69D9226@jp.fujitsu.com>
References: <1240266011-11140-13-git-send-email-mel@csn.ul.ie> <20090421180757.F145.A69D9226@jp.fujitsu.com>
Message-Id: <20090421193030.F16B.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Tue, 21 Apr 2009 19:31:23 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > @@ -1639,8 +1639,8 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
> >  	 * policy or is asking for __GFP_HIGH memory.  GFP_ATOMIC requests will
> >  	 * set both ALLOC_HARDER (!wait) and ALLOC_HIGH (__GFP_HIGH).
> >  	 */
> > -	if (gfp_mask & __GFP_HIGH)
> > -		alloc_flags |= ALLOC_HIGH;
> > +	VM_BUG_ON(__GFP_HIGH != ALLOC_HIGH);

Oops, I forgot said one comment.
BUILD_BUG_ON() is better?


> > +	alloc_flags |= (gfp_mask & __GFP_HIGH);
> >  
> >  	if (!wait) {
> >  		alloc_flags |= ALLOC_HARDER;
> 
> 	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> 
> 
> 



