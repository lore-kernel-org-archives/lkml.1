Return-Path: <linux-kernel-owner+w=401wt.eu-S1161837AbXECKi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161837AbXECKi0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 06:38:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161838AbXECKi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 06:38:26 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44011 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161837AbXECKiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 06:38:24 -0400
Date: Thu, 3 May 2007 11:37:56 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Hugh Dickins <hugh@veritas.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Andrea Arcangeli <andrea@suse.de>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: 2.6.22 -mm merge plans -- vm bugfixes
Message-ID: <20070503103756.GA19958@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Nick Piggin <nickpiggin@yahoo.com.au>,
	Hugh Dickins <hugh@veritas.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Andrea Arcangeli <andrea@suse.de>
References: <20070430162007.ad46e153.akpm@linux-foundation.org> <4636FDD7.9080401@yahoo.com.au> <Pine.LNX.4.64.0705011931520.16502@blonde.wat.veritas.com> <4638009E.3070408@yahoo.com.au> <Pine.LNX.4.64.0705021418030.16517@blonde.wat.veritas.com> <46393BA7.6030106@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46393BA7.6030106@yahoo.com.au>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2007 at 11:32:23AM +1000, Nick Piggin wrote:
> The attached patch gets performance up a bit by avoiding some
> barriers and some cachelines:
> 
> G5
>          pagefault   fork          exec
> 2.6.21   1.49-1.51   164.6-170.8   741.8-760.3
> +patch   1.71-1.73   175.2-180.8   780.5-794.2
> +patch2  1.61-1.63   169.8-175.0   748.6-757.0
> 
> So that brings the fork/exec hits down to much less than 5%, and
> would likely speed up other things that lock the page, like write
> or page reclaim.

Is that every fork/exec or just under certain cicumstances?
A 5% regression on every fork/exec is not acceptable.

