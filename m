Return-Path: <linux-kernel-owner+w=401wt.eu-S1756709AbYHZTvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756709AbYHZTvj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 15:51:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753305AbYHZTvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 15:51:31 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43822 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084AbYHZTva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 15:51:30 -0400
Date: Tue, 26 Aug 2008 15:51:14 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tejun Heo <htejun@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Al Viro <viro@ZenIV.linux.org.uk>, hch@infradead.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eric Van Hensbergen <ericvh@gmail.com>,
       Ron Minnich <rminnich@sandia.gov>, v9fs-developer@lists.sourceforge.net,
       cbe-oss-dev@ozlabs.org
Subject: Re: [PATCH 2/2] poll: allow f_op->poll to sleep
Message-ID: <20080826195114.GB19297@infradead.org>
References: <48B40BD4.7040004@kernel.org> <48B40C2F.3050700@gmail.com> <alpine.LFD.1.10.0808260954040.3363@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0808260954040.3363@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2008 at 09:58:14AM -0700, Linus Torvalds wrote:
> I don't really see the point.
> 
> poll() isn't allowed to sleep for many reasons. Some are technical. But 
> the most obvious one is that a sleeping "poll()" is totally against the 
> whole point of polling in the first place!
> 
> So is there some big conceptual reason to change how poll() has always 
> worked?

Just as a little sidenote most files on spufs have a ->poll that sleeps,
and currently we don't have any debugging to catch this, I just noticed
this by accident.  The reason that it sleeps is because it needs to grab
a sleping lock, and as that lock protects against a rather complicate
type of hardware context switch it's not possible to replace it with
a spinlock.

