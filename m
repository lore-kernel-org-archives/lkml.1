Return-Path: <linux-kernel-owner+w=401wt.eu-S1757629AbXI1IWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757629AbXI1IWu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 04:22:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754833AbXI1IWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 04:22:42 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42996 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331AbXI1IWl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 04:22:41 -0400
Date: Fri, 28 Sep 2007 09:22:39 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
       Zach Brown <zach.brown@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org
Subject: Re: [PATCH 06/12] mm: remove raw SetPageLocked() usage
Message-ID: <20070928082239.GA31230@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	lkml <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
	Zach Brown <zach.brown@oracle.com>, Ingo Molnar <mingo@elte.hu>,
	akpm@linux-foundation.org
References: <20070928074200.436463000@chello.nl> <20070928080042.020756000@chello.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20070928080042.020756000@chello.nl>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  		error = radix_tree_insert(&mapping->page_tree, offset, page);
>  		if (!error) {
>  			page_cache_get(page);

I don't think we want an unchecked trylock_page without a comment explaining
it.  I'd go as far as saying trylock_page should get a __must_check
attribute, and we'll need a dummy variable to actually ignore it.

