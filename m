Return-Path: <linux-kernel-owner+w=401wt.eu-S1757399AbZHQJwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757399AbZHQJwv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 05:52:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757278AbZHQJwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 05:52:50 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43226 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756898AbZHQJwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 05:52:50 -0400
Date: Mon, 17 Aug 2009 11:52:50 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Stefani Seibold <stefani@seibold.net>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Arnd Bergmann <arnd@arndb.de>, Andi Kleen <andi@firstfloor.org>,
       Amerigo Wang <xiyou.wangcong@gmail.com>, Joe Perches <joe@perches.com>
Subject: Re: [PATCH 2/7] kfifo: move out spinlock
Message-ID: <20090817095250.GB10446@one.firstfloor.org>
References: <1250455161.28540.4.camel@wall-e> <1250455590.28540.10.camel@wall-e> <20090816235843.0f7f11de@lxorguk.ukuu.org.uk> <20090816163422.a147a918.akpm@linux-foundation.org> <20090817074820.3585206b@lxorguk.ukuu.org.uk> <1250495182.20837.27.camel@wall-e>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250495182.20837.27.camel@wall-e>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think the break is not so hard if you believe. All you have to do is
> to replace or kfifo_get() into kfifo_out_locked() and kfifo_put() into
> kfifo_in_locked() if you really need the old behavior.
> 
> The thing is that we get no progress without changes.

One thing that would be good to ensure is that old unconverted code
gets a clear compile time error, just in case some out of tree
code uses it. Bonus points also for having a short comment in kfifo.h that 
explains how to do the conversion.

Other than that I would be all for getting rid of embedded spinlocks
completely.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
