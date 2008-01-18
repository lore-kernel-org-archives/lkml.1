Return-Path: <linux-kernel-owner+w=401wt.eu-S1764964AbYARWSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764964AbYARWSV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 17:18:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762013AbYARWSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 17:18:13 -0500
Received: from ozlabs.org ([203.10.76.45]:47781 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762595AbYARWSL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 17:18:11 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH 3/3] Makes lguest's irq handler typesafe
Date: Sat, 19 Jan 2008 09:17:38 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Ash Willis <ashwillis@programmer.net>, linux-pcmcia@lists.infradead.org,
       virtualization@lists.linux-foundation.org, Tejun Heo <htejun@gmail.com>
References: <200801190722.26154.rusty@rustcorp.com.au> <200801190727.36567.rusty@rustcorp.com.au> <47910FF5.20206@pobox.com>
In-Reply-To: <47910FF5.20206@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801190917.39349.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 19 January 2008 07:45:41 Jeff Garzik wrote:
> Rusty Russell wrote:
> > -static irqreturn_t lguest_interrupt(int irq, void *_vq)
> > +static irqreturn_t lguest_interrupt(int irq, struct virtqueue *vq)
> >  {
> > -	struct virtqueue *vq = _vq;
> >  	struct lguest_device_desc *desc = to_lgdev(vq->vdev)->desc;
>
> Ugh.
>
> This will be a compatibility nightmare.  I don't see how void* is so
> evil for this, or timers.

The compiler checks types, and we should use it (though note that when I 
typesafed the kthread code I didn't find any bugs, so safety arguments must 
be muted).  The gratuitous casts back and forth are annoying and silly.

The compatibility nightmare is one reason for the previous patch (which you  
didn't understand, I hope it's now clear).

> It's not like there's a huge cost associated with a pointer alias.

True, but this is not about performance.  It's about making code simpler and 
compiler-checkable.

Rusty.
