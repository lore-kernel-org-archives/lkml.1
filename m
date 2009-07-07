Return-Path: <linux-kernel-owner+w=401wt.eu-S1755300AbZGGKtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300AbZGGKtW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 06:49:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753655AbZGGKtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 06:49:13 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49660 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255AbZGGKtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 06:49:12 -0400
Date: Tue, 7 Jul 2009 06:49:14 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] [1/2] Optimization for touch_atime
Message-ID: <20090707104914.GA23619@infradead.org>
References: <20090706924.495556466@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090706924.495556466@firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 06, 2009 at 09:24:46PM +0200, Andi Kleen wrote:
> 
> Some benchmark testing shows touch_atime to be high up in profile
> logs for IO intensive workloads. Most likely that's due to the lock
> in mnt_want_write().  Unfortunately touch_atime first takes the lock,
> and then does all the other tests that could avoid atime updates (like
> noatime or relatime).
> 
> Do it the other way round -- first try to avoid the update and only
> then if that didn't succeed take the lock. That works because none of
> the atime avoidance tests rely on locking.
> 
> This also eliminates a goto.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>


Looks good to me.
