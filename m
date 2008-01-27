Return-Path: <linux-kernel-owner+w=401wt.eu-S1758854AbYA0VgD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758854AbYA0VgD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 16:36:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755774AbYA0Vfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 16:35:51 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:38822 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755250AbYA0Vfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 16:35:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=OiUZdWCdECwcyNPr/VVxrrZnS5FJuAuhvqyhjKNIcFwPdKGaeP05J1ammpuw48TFWSxsQVFMnlZoKuvVKKMQoDMZbyPgaIbzYgqFd5N1P1Lc6e2WdYS1BRkQxxP6SEThqSVv6TjUoXnT5vUCPnM6kQ8sYfR9j3HnoKUFTpgf804=
Message-ID: <84144f020801271335v4f2491a2n18b12de2ef245499@mail.gmail.com>
Date: Sun, 27 Jan 2008 23:35:49 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: lib/idr.c: initialize struct idr_layer
Cc: "Jim Houston" <jim.houston@ccur.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Tejun Heo" <htejun@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <19f34abd0801271330j596cd9fbqbd3691548dff26@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0801271207j377fba5bg92cedceedbdd228@mail.gmail.com>
	 <84144f020801271300g316b87bgea6beb265b5c62d3@mail.gmail.com>
	 <19f34abd0801271317o4b17dc28l3c93d4d28e3e2e73@mail.gmail.com>
	 <Pine.LNX.4.64.0801272319570.540@sbz-30.cs.Helsinki.FI>
	 <19f34abd0801271330j596cd9fbqbd3691548dff26@mail.gmail.com>
X-Google-Sender-Auth: 2e09324636432655
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vegard,

On Jan 27, 2008 11:30 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> > Depends on how you track object initialization. An object returned by
> > kmem_cache_alloc() is always initialized if the cache it comes from has a
> > constructor.
>
> I think there's a pretty big chance I'm wrong (or misunderstanding
> something) here, so I'll just ask:
> setup_object() from mm/slub.c is what calls the ctor. Shouldn't this
> be called from slab_alloc() as well? (I'm marking the data
> "uninitialized" there before returning the object.) Otherwise you
> might get back an object that is initialized with the previous owner's
> data. Or is this intentional?

It's intentional. The caller of kmem_cache_free() is expected to put
the object in such a state that it can be recycled immediately when
kmem_cache_alloc() for that cache is called. You can find the design
rationale for that in Bonwick's original paper on slab:
http://citeseer.ist.psu.edu/bonwick94slab.html

                        Pekka
