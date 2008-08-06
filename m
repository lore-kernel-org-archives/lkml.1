Return-Path: <linux-kernel-owner+w=401wt.eu-S1761495AbYHFRcz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761495AbYHFRcz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 13:32:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755746AbYHFRc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 13:32:29 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:31247 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755668AbYHFRc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 13:32:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=Mp0TSLMWUtBUugpmRiN0QL6VHRKqvV7M+NNSJgpkEgHjYUu0+kBEleUb2jpHWfFR0j
         SK//SZqsSqmBzxMi/2scdVtNpSZ8gzxrL4H2kiaPKLcGUZ8/bd0KO7Ep5dpGn2sLLeag
         NNGUAhYq7b7CC3VAH+UXo66mkoq80tZw70XdE=
Message-ID: <6a89f9d50808061032k6c30887cg6bed0259f9620b1b@mail.gmail.com>
Date: Wed, 6 Aug 2008 19:32:26 +0200
From: "Stephane Marchesin" <marchesin@icps.u-strasbg.fr>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: [PATCH] Export shmem_file_setup and shmem_getpage for DRM-GEM
Cc: "Keith Packard" <keithp@keithp.com>, "John Stoffel" <john@stoffel.org>,
       "Hugh Dickins" <hugh@veritas.com>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Christoph Hellwig" <hch@infradead.org>,
       "Eric Anholt" <eric@anholt.net>, linux-kernel@vger.kernel.org
In-Reply-To: <20080806102437.2d5e5d11@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1217573919-7496-1-git-send-email-eric@anholt.net>
	 <Pine.LNX.4.64.0808041720500.25617@blonde.site>
	 <1217870748.24714.79.camel@koto.keithp.com>
	 <Pine.LNX.4.64.0808041855050.5717@blonde.site>
	 <1217877645.24714.87.camel@koto.keithp.com>
	 <Pine.LNX.4.64.0808042055240.17041@blonde.site>
	 <18583.47633.987143.236236@stoffel.org>
	 <1217910505.24714.152.camel@koto.keithp.com>
	 <6a89f9d50808060920t168d533g5d440b444e7c09fc@mail.gmail.com>
	 <20080806102437.2d5e5d11@infradead.org>
X-Google-Sender-Auth: b2c5619aec701e58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/6/08, Arjan van de Ven <arjan@infradead.org> wrote:
> On Wed, 6 Aug 2008 18:20:40 +0200
>  "Stephane Marchesin" <marchesin@icps.u-strasbg.fr> wrote:
>
>  > On 8/5/08, Keith Packard <keithp@keithp.com> wrote:
>  > > On Mon, 2008-08-04 at 22:25 -0400, John Stoffel wrote:
>  > >
>  > >  > What about the onboard memory of graphics cards?  Isn't that
>  > >  > where Textures and such are stored as well?  So once something
>  > >  > is loaded to the card, shouldn't you be able to free it in
>  > >  > system memory?  Or swap it out ahead of time?
>  > >
>  > >
>  > > Right now, I'm working only on Intel integrated graphics, which
>  > > doesn't have any on-board memory. My thinking is that we'd best
>  > > solve the easiest case first before attempting the harder discrete
>  > > graphics driver. Plus, Intel pays me do do integrated graphics, so
>  > > I have an incentive.
>  > >
>  >
>  > Right, but it sounds adventurous to merge this work upstream before it
>  > is generic enough to work on discrete cards. Right now it only works
>  > on intel integrated cards ; integrated cards are one business,
>  > discrete are a completely different world and the issues afoot
>  > completely different.
>  >
>  > Should this go upstream, the kernel guys have to keep in mind and
>  > accept the possibility that another memory manager might be needed at
>  > some point.
>
>
> the ATI driver guys already have the interface working.
>

No they don't. There is only preliminary code.

>  In addition.. since when is "oh you must also make it work for THAT" a
>  requirement? Traditionally, it's up to the second person to make
>  generic code work for them (within reason of course, but I'll argue
>  that the bar of reasonableness has been met here)
>

Right, but the current code will basically force the discrete card
drivers to implement backing store for all allocations. Do we want
this ? Also, for cards that can handle page-based memory allocations,
there is no way to make use of this feature, do we want this too ?

Stephane
