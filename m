Return-Path: <linux-kernel-owner+w=401wt.eu-S1757867AbYA0VaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757867AbYA0VaY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 16:30:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754483AbYA0VaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 16:30:13 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:31494 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbYA0VaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 16:30:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ssvZRp0vEm/tzeOgELZF5HPejUrwD2O+QaQY4Pte4yGBagHdLJuP7uTSHcGLn0egwYzZcmbmnwPPqB0az3q13TS/mbMgo6ly2iaNWHbNujlIY7UAiMajWGZf6Jn77+PFOlrhDkLbDs17rv16ew9qrvWEHsePN6L6mE2Ek/XNN3g=
Message-ID: <19f34abd0801271330j596cd9fbqbd3691548dff26@mail.gmail.com>
Date: Sun, 27 Jan 2008 22:30:10 +0100
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Pekka J Enberg" <penberg@cs.helsinki.fi>
Subject: Re: lib/idr.c: initialize struct idr_layer
Cc: "Jim Houston" <jim.houston@ccur.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Tejun Heo" <htejun@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0801272319570.540@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0801271207j377fba5bg92cedceedbdd228@mail.gmail.com>
	 <84144f020801271300g316b87bgea6beb265b5c62d3@mail.gmail.com>
	 <19f34abd0801271317o4b17dc28l3c93d4d28e3e2e73@mail.gmail.com>
	 <Pine.LNX.4.64.0801272319570.540@sbz-30.cs.Helsinki.FI>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 27, 2008 10:21 PM, Pekka J Enberg <penberg@cs.helsinki.fi> wrote:
> On Sun, 27 Jan 2008, Vegard Nossum wrote:
> > Though in this case, idr_pre_get() actually *is* called first. Hmm...
> > I think there's a pretty big chance that kmemcheck is at fault :-(
>
> Depends on how you track object initialization. An object returned by
> kmem_cache_alloc() is always initialized if the cache it comes from has a
> constructor.

I think there's a pretty big chance I'm wrong (or misunderstanding
something) here, so I'll just ask:
setup_object() from mm/slub.c is what calls the ctor. Shouldn't this
be called from slab_alloc() as well? (I'm marking the data
"uninitialized" there before returning the object.) Otherwise you
might get back an object that is initialized with the previous owner's
data. Or is this intentional?

Thanks.

Vegard
