Return-Path: <linux-kernel-owner+w=401wt.eu-S1761431AbYESODt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761431AbYESODt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 10:03:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759132AbYESODl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 10:03:41 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46195 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758667AbYESODl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 10:03:41 -0400
Date: Mon, 19 May 2008 10:03:39 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: corbet@lwn.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [2/11] Add unlocked_fasync
Message-ID: <20080519140339.GB24267@infradead.org>
References: <20080519231.561421028@firstfloor.org> <20080519123111.97C0C1B41FF@basil.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080519123111.97C0C1B41FF@basil.firstfloor.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2008 at 02:31:11PM +0200, Andi Kleen wrote:
> 
> Add a new fops entry point to allow fasync without BKL. While it's arguably
> unclear this entry point is called often enough for it really matters
> it was still relatively easy to do. And there are far less async users
> in the tree than ioctls so it's likely they can be all converted 
> eventually and then the non unlocked async entry point could be dropped.
> 
> There was still the problem of the actual flags change being
> protected against other setters of flags. Instead of using BKL
> for this use the i_mutex now.
> 
> I also added a mutex_lock against one other flags change
> that was lockless and could potentially lose updates.
> 
> There are a couple of potential problems I added comments about on.

I'd rather do a properly flag day and move lock_kernel into the
instances instead of adding this _unlocked gunk.
