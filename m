Return-Path: <linux-kernel-owner+w=401wt.eu-S1760893AbYEWAwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760893AbYEWAwj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 20:52:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756027AbYEWAwb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 20:52:31 -0400
Received: from ozlabs.org ([203.10.76.45]:42485 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754429AbYEWAwa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 20:52:30 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Daniel Walker <dwalker@mvista.com>
Subject: Re: [PATCH] Introduce down_nowait()
Date: Fri, 23 May 2008 10:52:16 +1000
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       Christoph Hellwig <hch@infradead.org>, Matthew Wilcox <matthew@wil.cx>
References: <200805211600.16415.rusty@rustcorp.com.au> <200805221856.23824.rusty@rustcorp.com.au> <1211471323.18130.84.camel@localhost.localdomain>
In-Reply-To: <1211471323.18130.84.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805231052.17387.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 23 May 2008 01:48:43 Daniel Walker wrote:
> On Thu, 2008-05-22 at 18:56 +1000, Rusty Russell wrote:
> > The patches to change down_trylock to down_try touch a heap of files,
> > which are also touched in other people's trees.  If this patch goes
> > upstream, those people rewriting that code can use down_try in their
> > rewrite, and I can throw mine away.
>
> Seems like it's too much trouble.. I mean, we're removing semaphores
> anyway and down_trylock with them. I'll agree with Andrew down_trylock
> removal is pretty glacial. It's cause there aren't many of them and most
> of the ones I've looked at are in strange locking schemes, which makes
> them difficult to remove..

Frankly, I agree.  I did this patchset assuming it would be trivial, and it 
really is.  We've spent more time discussing it here than spent coding it in 
the first place and handling the conflicts.

> I'm not against your changes, but if it's going to cause problems I'd
> rather people focus on mutex_trylock instead.

Yes, but Stephen seems to have no problems with the conflicts.  He knows the 
removal patches override my patches, and if I miss any down_trylock()s, it 
simply means a deprecated warning.  The onus is on me to solve anything else.

Cheers,
Rusty.
