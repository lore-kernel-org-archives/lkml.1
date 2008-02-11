Return-Path: <linux-kernel-owner+w=401wt.eu-S1760257AbYBKWod@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760257AbYBKWod (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 17:44:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755412AbYBKWoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 17:44:22 -0500
Received: from relay1.sgi.com ([192.48.171.29]:38069 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754806AbYBKWoV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 17:44:21 -0500
Date: Mon, 11 Feb 2008 14:44:21 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Matt Mackall <mpm@selenic.com>
cc: Pekka J Enberg <penberg@cs.helsinki.fi>, jdike@addtoit.com,
       blaisorblade@yahoo.it, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slob: fix linking for user mode linux
In-Reply-To: <1202769569.12383.49.camel@cinder.waste.org>
Message-ID: <Pine.LNX.4.64.0802111443130.28253@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0802120032160.27876@sbz-30.cs.Helsinki.FI>
 <1202769569.12383.49.camel@cinder.waste.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Feb 2008, Matt Mackall wrote:

> Can someone explain why the magic is needed (and preferably capture it
> in a comment somewhere sensible)? I took a peek at this and have no idea
> what's going on. 

UML defined its own external __kmalloc and things. Isnt there some other 
way to fix it? I guess including slab.h is not possible here?


/*
 * Copyright (C) 2005 Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
 * Licensed under the GPL
 */

#ifndef __UM_MALLOC_H__
#define __UM_MALLOC_H__

#include "kern_constants.h"

extern void *__kmalloc(int size, int flags);
static inline void *kmalloc(int size, int flags)
{
        return __kmalloc(size, flags);
}

extern void kfree(const void *ptr);

extern void *vmalloc(unsigned long size);
extern void vfree(void *ptr);

#endif /* __UM_MALLOC_H__ */
