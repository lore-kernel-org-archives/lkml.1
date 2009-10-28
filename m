Return-Path: <linux-kernel-owner+w=401wt.eu-S1757279AbZJ1DnG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757279AbZJ1DnG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 23:43:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756671AbZJ1DnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 23:43:05 -0400
Received: from gir.skynet.ie ([193.1.99.77]:34649 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756302AbZJ1DnE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 23:43:04 -0400
Date: Wed, 28 Oct 2009 03:43:07 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: David Miller <davem@davemloft.net>
cc: airlied@gmail.com, andi@firstfloor.org, arnd@arndb.de,
       linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net
Subject: Re: is avoiding compat ioctls possible?
In-Reply-To: <20091027.203838.21218679.davem@davemloft.net>
Message-ID: <alpine.DEB.2.00.0910280341331.19088@skynet.skynet.ie>
References: <21d7e9970910271822p3751b2fdnd78e1bc3326b9b0b@mail.gmail.com> <87hbtkjkki.fsf@basil.nowhere.org> <21d7e9970910272005mbb268r7b16493a22ca275a@mail.gmail.com> <20091027.203838.21218679.davem@davemloft.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> > DrNick on irc suggested just doing:
> > if (is_compat_task()) ptr &= 0x00000000FFFFFFFF;
> > 
> > Is there a one liner I can just do in the actual ioctls instead of
> > adding 20 compat
> > ones?
> 
> Just do the right thing and pass all userland compat pointers
> through the correct compat_*() macros.

I wondered why the other ioctls worked,

(uint32_t __user *)(unsigned long)card_res->fb_id_ptr;

we already opencoded this (probably before it was macroisied or we just 
pasted it), so the radeon one is buggy, I should just go and compat_* all 
of these then and we should be all happy?

Dave.
