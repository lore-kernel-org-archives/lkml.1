Return-Path: <linux-kernel-owner+w=401wt.eu-S1760880AbZANJXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760880AbZANJXu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 04:23:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754895AbZANJXc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 04:23:32 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51277 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755001AbZANJXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 04:23:30 -0500
Date: Wed, 14 Jan 2009 01:22:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Manfred Spraul <manfred@colorfullife.com>, krh@redhat.com, dcm@acm.org,
       Nadia.Derbey@bull.net, linux1394-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, paulmck@us.ibm.com, stable@kernel.org
Subject: Re: [PATCH] lib/idr.c: Zero memory properly in idr_remove_all
Message-Id: <20090114012234.bce79d7b.akpm@linux-foundation.org>
In-Reply-To: <496DA95B.6070401@s5r6.in-berlin.de>
References: <1231571060.3538.18.camel@localhost.localdomain>
	<49686465.70501@s5r6.in-berlin.de>
	<20090110011557.9d94e111.akpm@linux-foundation.org>
	<496872E0.9030007@s5r6.in-berlin.de>
	<1231773620.6365.21.camel@gaara.bos.redhat.com>
	<496B9FC7.3090108@colorfullife.com>
	<1231792712.6365.31.camel@gaara.bos.redhat.com>
	<496BAD1C.5060201@colorfullife.com>
	<20090113144802.39dc4c23.akpm@linux-foundation.org>
	<84144f020901132319g50dc9e50o283b0d263f287eea@mail.gmail.com>
	<20090114001745.9575ab02.akpm@linux-foundation.org>
	<496DA95B.6070401@s5r6.in-berlin.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jan 2009 09:59:07 +0100 Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> > --- a/lib/idr.c~lib-idrc-use-kmem_cache_zalloc-for-the-idr_layer-cache
> > +++ a/lib/idr.c
> > @@ -121,7 +121,7 @@ int idr_pre_get(struct idr *idp, gfp_t g
> >  {
> >  	while (idp->id_free_cnt < IDR_FREE_MAX) {
> >  		struct idr_layer *new;
> > -		new = kmem_cache_alloc(idr_layer_cache, gfp_mask);
> > +		new = kmem_cache_zalloc(idr_layer_cache, gfp_mask);
> >  		if (new == NULL)
> >  			return (0);
> >  		move_to_free_list(idp, new);
> ...
> 
> I wonder if it would be more robust --- or even necessary --- to instead
> add proper initialization code to get_from_free_list().
> 
> As far as David and I tested the new idr using code in firewire, we
> called idr_remove_all() *and* idr_destroy() before any subsequent
> idr_get_new().  But in practice, idr_get_new() may of course also happen
> between idr_remove_all() and idr_destroy().
> 
> And then this fix won't be sufficient, would it?

Maybe I'm having a thick day, but I'm not following you at all here.

What do you think the remaining problem is?  get_from_free_list()
starts out with a not-fully-zeroed object?  Something else?

