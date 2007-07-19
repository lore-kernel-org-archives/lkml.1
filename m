Return-Path: <linux-kernel-owner+w=401wt.eu-S934775AbXGSIZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934775AbXGSIZ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 04:25:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762428AbXGSIY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 04:24:27 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42162 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763844AbXGSIYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 04:24:20 -0400
Date: Thu, 19 Jul 2007 01:10:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-kernel@vger.kernel.org
Subject: Re: cmpxchg is not available to generic code
Message-Id: <20070719011055.1392c7d2.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0707190900320.19586@skynet.skynet.ie>
References: <20070719000549.1e57b5b2.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0707190900320.19586@skynet.skynet.ie>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jul 2007 09:02:03 +0100 (IST) Dave Airlie <airlied@linux.ie> wrote:

> 
> 
> > arm:
> >
> > drivers/char/drm/drm_lock.c: In function `drm_lock_take':
> > drivers/char/drm/drm_lock.c:221: error: implicit declaration of function `cmpxchg'
> >
> > You might be able to use atomic_cmpxchg, which _is_ present
> > on all architectures.  Or use a spinlock.
> >
> > What's that code doing anyway?  driver-private locking primitives?
> 
> When did arm suddenly start wanting DRM?

It's selectable in config.  allmodconfig broke.

> they need to grow a userpsace 
> cmpxchg as davem mentioned to go along with this, changing the drm now 
> isn't possible due to backwards compat..

For reference purposes, that position is not acceptable.  We _never_ accept the
"oh I can't change my proposed kernel interface because I already have
userspace relying on it" argument.

Hopefully that won't be an issue here.  I guess DRM now needs a
`depends on !ARM'.

