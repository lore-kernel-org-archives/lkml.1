Return-Path: <linux-kernel-owner+w=401wt.eu-S1763904AbXHAJ5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763904AbXHAJ5n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 05:57:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753105AbXHAJ5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 05:57:36 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:36027 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769AbXHAJ5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 05:57:35 -0400
To: andi@firstfloor.org
CC: miklos@szeredi.hu, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
In-reply-to: <p73myxbpm8r.fsf@bingen.suse.de> (message from Andi Kleen on 01
	Aug 2007 12:44:52 +0200)
Subject: Re: [RFC PATCH] type safe allocator
References: <E1IGAAI-0006K6-00@dorka.pomaz.szeredi.hu> <p73myxbpm8r.fsf@bingen.suse.de>
Message-Id: <E1IGAx0-0006TK-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 01 Aug 2007 11:57:06 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > I wonder why we don't have type safe object allocators a-la new() in
> > C++ or g_new() in glib?
> > 
> >   fooptr = k_new(struct foo, GFP_KERNEL);
> > 
> > is nicer and more descriptive than
> > 
> >   fooptr = kmalloc(sizeof(*fooptr), GFP_KERNEL);
> > 
> > and more safe than
> > 
> >   fooptr = kmalloc(sizeof(struct foo), GFP_KERNEL);
> 
> How is it more safe? It seems 100% equivalent to me,
> just a different syntax.

Note the (type *) cast:

#define k_new(type, flags) ((type *) kmalloc(sizeof(type), flags))

Miklos
