Return-Path: <linux-kernel-owner+w=401wt.eu-S964954AbXGMJyB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964954AbXGMJyB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 05:54:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762139AbXGMJxx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 05:53:53 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59531 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761997AbXGMJxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 05:53:52 -0400
Date: Fri, 13 Jul 2007 10:53:37 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Hugh Dickins <hugh@veritas.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jes Sorensen <jes@sgi.com>,
       Dmitry Monakhov <dmonakhov@sw.ru>, linux-kernel@vger.kernel.org
Subject: Re: [patch] mm: recheck lock rlim after f_op->mmap() method
Message-ID: <20070713095337.GB16304@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Hugh Dickins <hugh@veritas.com>, Jes Sorensen <jes@sgi.com>,
	Dmitry Monakhov <dmonakhov@sw.ru>, linux-kernel@vger.kernel.org
References: <20070709184917.GA8720@dnb.sw.ru> <Pine.LNX.4.64.0707101813390.4717@blonde.wat.veritas.com> <20070711093253.GA19061@infradead.org> <20070711101245.GA18770@dnb.sw.ru> <20070711101437.GA21735@infradead.org> <Pine.LNX.4.64.0707111826530.22786@blonde.wat.veritas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707111826530.22786@blonde.wat.veritas.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2007 at 07:03:36PM +0100, Hugh Dickins wrote:
> Well, they'll get what they deserve.  I'm not convinced Dmitry's right
> about their nopage; and I'm not going to waste any more time working
> out ways to protect ourselves from them.  Let's stick with the mspec.

I'm not just concerned about the ati driver.  There's a lot of driver
that do or did really stupid stuff with mmap, including in-tree drivers.
the actual mmap() code is not actually a fastpath so additional sanity
checks can't hurt.  It might not be worth the effort for ->nopage, though.

