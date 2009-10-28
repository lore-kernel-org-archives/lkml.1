Return-Path: <linux-kernel-owner+w=401wt.eu-S1757309AbZJ1Dyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757309AbZJ1Dyc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 23:54:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757244AbZJ1Dyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 23:54:31 -0400
Received: from gir.skynet.ie ([193.1.99.77]:37035 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756710AbZJ1Dyb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 23:54:31 -0400
Date: Wed, 28 Oct 2009 03:54:34 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: David Miller <davem@davemloft.net>
cc: dri-devel@lists.sourceforge.net, andi@firstfloor.org,
       linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: is avoiding compat ioctls possible?
In-Reply-To: <20091027.204530.142024242.davem@davemloft.net>
Message-ID: <alpine.DEB.2.00.0910280353080.19088@skynet.skynet.ie>
References: <21d7e9970910272005mbb268r7b16493a22ca275a@mail.gmail.com> <20091027.203838.21218679.davem@davemloft.net> <alpine.DEB.2.00.0910280341331.19088@skynet.skynet.ie> <20091027.204530.142024242.davem@davemloft.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> > we already opencoded this (probably before it was macroisied or we just 
> > pasted it), so the radeon one is buggy, I should just go and compat_* all 
> > of these then and we should be all happy?
> 
> It should be, it's only working because:
> 
> 1) A malicious userland hasn't put garbage in the upper bits for
>    you yet.
> 
> 2) Nobody has tested s390 yet :-)
> 

So will an inline like this work?

static inline void *__user convert_user_ptr(uint64_t ioctl_ptr)
{
#ifdef CONFIG_COMPAT
	if (is_compat_task())
		return compat_ptr((compat_uptr_t)ioctl_ptr);
	else
#endif
		return (void __user *)(unsigned long)ioctl_ptr;
}

then I can convert all the code to just use that instead of explicity 
casts or brokenness.

Dave.
