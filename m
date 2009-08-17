Return-Path: <linux-kernel-owner+w=401wt.eu-S932158AbZHQHhn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932158AbZHQHhn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 03:37:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757090AbZHQHhm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 03:37:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54452 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757043AbZHQHhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 03:37:40 -0400
Date: Mon, 17 Aug 2009 00:36:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Stefani Seibold <stefani@seibold.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Arnd Bergmann <arnd@arndb.de>, Andi Kleen <andi@firstfloor.org>,
       Amerigo Wang <xiyou.wangcong@gmail.com>, Joe Perches <joe@perches.com>
Subject: Re: [PATCH 2/7] kfifo: move out spinlock
Message-Id: <20090817003617.2abe0a95.akpm@linux-foundation.org>
In-Reply-To: <20090817074820.3585206b@lxorguk.ukuu.org.uk>
References: <1250455161.28540.4.camel@wall-e>
	<1250455590.28540.10.camel@wall-e>
	<20090816235843.0f7f11de@lxorguk.ukuu.org.uk>
	<20090816163422.a147a918.akpm@linux-foundation.org>
	<20090817074820.3585206b@lxorguk.ukuu.org.uk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Aug 2009 07:48:20 +0100 Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > kfifo has no business assuming that the caller wants to use
> > spin_lock() locking.
> > 
> > If we want to add wrapper helpers around kfifo to reduce code
> > duplication in callers, and if one of those wrapper helpers provides
> > spinlock-based locking then fine.
> 
> Those wrappers happen to be called kfifo_get and kfifo_put

Those names are wrong.

They're wrong because they are the spinlock-specific variant.  What are
we going to call the mutex_lock-specific variant?

> > But the happens-to-use-spin_lock functions shouldn't be called
> > kfifo_get(), because that steals namespace from the unlocked functions,
> > and makes the naming for the happens-to-use-mutex_lock functions look
> > weird.
> 
> All over the kernel unlocked function versions have a leading _ name.
> It's the kernel convention.

tisn't.  radix-tree, rbrtee, idr, list_head, prio_tree, flex_array -
none of them use that convention.

> The other thing I must say I dislike about these patches is the
> gratuitious 'let's rename all the functions' approach it takes. The kfifo
> API is documented, used and random API of the year type changes mess
> stuff up and cause unneeded churn.

It fixes naming mistakes.  Long-term it is the correct thing to do. 
Best to do it now before we get more callers.

