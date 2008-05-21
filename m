Return-Path: <linux-kernel-owner+w=401wt.eu-S1761912AbYEUE7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761912AbYEUE7Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 00:59:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751336AbYEUE7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 00:59:15 -0400
Received: from ozlabs.org ([203.10.76.45]:53500 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751169AbYEUE7O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 00:59:14 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 18/57] iTCO: unlocked_ioctl, coding style and cleanup
Date: Wed, 21 May 2008 14:58:57 +1000
User-Agent: KMail/1.9.9
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       wim@iguana.be, Stephen Rothwell <sfr@canb.auug.org.au>
References: <20080519124659.31722.51847.stgit@core> <200805211426.16234.rusty@rustcorp.com.au> <20080520213654.a25d286e.akpm@linux-foundation.org>
In-Reply-To: <20080520213654.a25d286e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805211458.58020.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 May 2008 14:36:54 Andrew Morton wrote:
> On Wed, 21 May 2008 14:26:15 +1000 Rusty Russell <rusty@rustcorp.com.au> 
wrote:
> > > decent-sized smashup during the merge window.  There are lessons
> > > here...
> >
> > I've been pulling out s/down_trylock/down_nowait/ patches which effect
> > others' changes.  Those patches get moved to the end of my queue, and
> > I'll revisit them before an actual merge with Linus.
> >
> > As down_trylock still works (but marked deprecated) with my patches,
> > they're fine to drop.  Just tell me which ones...
>
> Well, a simple patch which does
>
> /*
>  * comment goes here
>  */
> static inline int __must_check down_nowait(struct semaphore *sem)
> {
> 	return !down_trylock(sem);
> }
>
> and which does not deprecate down_trylock() could go into mainline
> right now

Sure, in this case it's probably worth it.

> , (assuming that the overall concept doesn't get shot down in 
> review - did it get reviewed?)

Well, it got some commentry on lkml, mainly from Christoph H.  He was the one 
who came up with "down_nowait" vs the original "down_try".

> Then you can start trickling stuff out to people straight away.

OK, I'll send a patch now.

Thanks,
Rusty.



