Return-Path: <linux-kernel-owner+w=401wt.eu-S1758756AbZA2OWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758756AbZA2OWU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 09:22:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752880AbZA2OWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 09:22:05 -0500
Received: from one.firstfloor.org ([213.235.205.2]:43502 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911AbZA2OWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 09:22:03 -0500
Date: Thu, 29 Jan 2009 15:37:56 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, corbet@lwn.net,
       linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk,
       linux-api@vger.kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH, RFC] Remove fasync() BKL usage, take 3325
Message-ID: <20090129143756.GF7533@one.firstfloor.org>
References: <20090115153211.663df310@bike.lwn.net> <20090122065104.2787df2d.akpm@linux-foundation.org> <20090122203248.GA20159@infradead.org> <20090123045646.GK15750@one.firstfloor.org> <20090127165504.53ed7a2d.akpm@linux-foundation.org> <20090128031439.GA11025@redhat.com> <20090128173618.GA3174@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090128173618.GA3174@infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2009 at 12:36:18PM -0500, Christoph Hellwig wrote:
> On Wed, Jan 28, 2009 at 04:14:39AM +0100, Oleg Nesterov wrote:
> > I didn't send the actual patch. The idea is,
> > 
> > 	can't we use O_LOCK_FLAGS bit? I agree, it is a bit ugly,
> > 	and I won't insist if you don't like is.
> > 
> > 		static inline int try_lock_f_flags(struct file *file)
> > 		{
> > 			return !test_and_set_bit(O_LOCK_FLAGS, file->f_flags);
> > 		}
> 
> ->f_flags is an unsigned int and the bit macros need an unsigned long.
> Increasing the size of struct file for this is probably a bad idea.


I think very few architectures actually need the unsigned long.

For 2.4 I had a hack (when it did still matter for struct page)
to define a new type for this that denoted the minimal type size
needed here.

That could be reintroduced. Then only the few archs which really
require unsigned long here would pay the overhead.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
