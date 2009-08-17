Return-Path: <linux-kernel-owner+w=401wt.eu-S1756916AbZHQGrk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916AbZHQGrk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 02:47:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752142AbZHQGrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 02:47:39 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51016 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756875AbZHQGri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 02:47:38 -0400
Date: Mon, 17 Aug 2009 07:48:20 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stefani Seibold <stefani@seibold.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Arnd Bergmann <arnd@arndb.de>, Andi Kleen <andi@firstfloor.org>,
       Amerigo Wang <xiyou.wangcong@gmail.com>, Joe Perches <joe@perches.com>
Subject: Re: [PATCH 2/7] kfifo: move out spinlock
Message-ID: <20090817074820.3585206b@lxorguk.ukuu.org.uk>
In-Reply-To: <20090816163422.a147a918.akpm@linux-foundation.org>
References: <1250455161.28540.4.camel@wall-e>
	<1250455590.28540.10.camel@wall-e>
	<20090816235843.0f7f11de@lxorguk.ukuu.org.uk>
	<20090816163422.a147a918.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> kfifo has no business assuming that the caller wants to use
> spin_lock() locking.
> 
> If we want to add wrapper helpers around kfifo to reduce code
> duplication in callers, and if one of those wrapper helpers provides
> spinlock-based locking then fine.

Those wrappers happen to be called kfifo_get and kfifo_put

> But the happens-to-use-spin_lock functions shouldn't be called
> kfifo_get(), because that steals namespace from the unlocked functions,
> and makes the naming for the happens-to-use-mutex_lock functions look
> weird.

All over the kernel unlocked function versions have a leading _ name.
It's the kernel convention.

The other thing I must say I dislike about these patches is the
gratuitious 'let's rename all the functions' approach it takes. The kfifo
API is documented, used and random API of the year type changes mess
stuff up and cause unneeded churn.

The implementation itself is a really really nice idea.


