Return-Path: <linux-kernel-owner+w=401wt.eu-S1754828AbYIHRRB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828AbYIHRRB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 13:17:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753289AbYIHRQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 13:16:51 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60649 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050AbYIHRQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 13:16:51 -0400
Date: Mon, 8 Sep 2008 13:16:48 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: Andi Kleen <andi@firstfloor.org>, Chris Mason <chris.mason@oracle.com>,
       linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: adaptive mutexes, was Re: btrfs_tree_lock & trylock
Message-ID: <20080908171648.GA19117@infradead.org>
References: <20080908111059.GA8902@basil.nowhere.org> <1220881666.8537.3.camel@think.oraclecorp.com> <20080908135414.GG26079@one.firstfloor.org> <1220882551.8537.5.camel@think.oraclecorp.com> <20080908142052.GK26079@one.firstfloor.org> <20080908080751.3d29fd61@extreme>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080908080751.3d29fd61@extreme>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2008 at 08:07:51AM -0700, Stephen Hemminger wrote:
> The problem is that they are a nuisance. It is impossible to choose
> the right trade off between spin an no-spin, also they optimize for
> a case that doesn't occur often enough to be justified.
> 
> People seem to repeatedly come up with adaptive mutex based on intuitive
> hunch, and never do much analysis before or afterwards.
> 
> You need some facts to come up with a useful model:
>   % of time lock is contended
>   average lock hold time
>   overhead of entry-exit for lock primitive (spin time)
>   overhead of the adaptive version either pure spin or pure mutex
> 
> Also, adaptive locks have even worse unfairness than spin locks under
> contention.

Well, the traditional wisdom in kernel land is that you want a spinlock
if the contention phases are short.  But we grow more an more places
where we might do sleep under the lock.  One optimization would be
to spin, but only if the mutex holder is not sleeping.  Or we make the
spinning a completely different API, mutex_lock_adaptive()

