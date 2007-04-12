Return-Path: <linux-kernel-owner+w=401wt.eu-S932224AbXDLQiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224AbXDLQiR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 12:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932315AbXDLQiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 12:38:17 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:47601 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932224AbXDLQiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 12:38:16 -0400
Date: Thu, 12 Apr 2007 09:38:15 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Neil Brown <neilb@suse.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: SLUB: kmem_cache_destroy doesn't 
In-Reply-To: <17949.57189.565653.289035@notabene.brown>
Message-ID: <Pine.LNX.4.64.0704120937350.26701@schroedinger.engr.sgi.com>
References: <17949.57189.565653.289035@notabene.brown>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Apr 2007, Neil Brown wrote:

> And 
> 
>   # cat /sys/slab/raid5-md1/aliases
>   -1
> 
> is a bit suspicious.

Yuck!

> void kmem_cache_destroy(struct kmem_cache *s)
> {
> 	down_write(&slub_lock);
> 	if (s->refcount)
> 		s->refcount--;
> 	else {
> 		list_del(&s->list);
> 		WARN_ON(kmem_cache_close(s));
> 		sysfs_slab_remove(s);
> 		kfree(s);
> 	}
> 	up_write(&slub_lock);
> }
> 
> looks a bit odd.
> I would have thought the test should be:
> 
>         if (s->refcount > 1)

Correct. Does the change fix it?
