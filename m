Return-Path: <linux-kernel-owner+w=401wt.eu-S1756041AbYKMXu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041AbYKMXu3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 18:50:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756120AbYKMXt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 18:49:57 -0500
Received: from ozlabs.org ([203.10.76.45]:47911 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754662AbYKMXt4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 18:49:56 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH] Allocate module.ref array dynamically
Date: Fri, 14 Nov 2008 10:19:48 +1030
User-Agent: KMail/1.10.1 (Linux/2.6.27-7-generic; KDE/4.1.2; i686; ; )
Cc: Eric Dumazet <dada1@cosmosbay.com>, Takashi Iwai <tiwai@suse.de>,
       Andreas Gruenbacher <agruen@suse.de>, Jan Blunck <jblunck@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Mike Travis <travis@sgi.com>
References: <s5htzaekp6o.wl%tiwai@suse.de> <200811131951.07686.rusty@rustcorp.com.au> <Pine.LNX.4.64.0811130830210.19293@quilx.com>
In-Reply-To: <Pine.LNX.4.64.0811130830210.19293@quilx.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811141019.49493.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 November 2008 01:10:32 Christoph Lameter wrote:
> On Thu, 13 Nov 2008, Rusty Russell wrote:
> > > The cpu alloc patchset gets rid of about half the hooks in the page
> > > allocator and slab allocator.
> >
> > Sure, but we could convert those today to alloc_percpu etc.
>
> The percpu_ptr macros etc are not upercase suggesting that it is a
> function but the functions do weird things like passing through the
> type. This is confusing.

No it's not, we have several like that.  And noone's going to somehow get 
confused and misuse it.  Finally, we don't change APIs just to meet some sense 
of neatness.

> alloc_percpu() does not allow specifying a GFP mask therefore does not
> support zeroing and is not extendable for the future.

It is defined to be zeroing.  And it is very unclear that (1) future 
implementations will be able to support GFP_ATOMIC reasonably, and (2) that we 
want people to do that.  If we do, we fix it.

> It does not allow
> specifying an alignment therefore tight packing is not possible.

It absolutely does.  That's why it takes a type!

> Plus the name alloc_percpu() suggests that it is a function but its a
> macro doing things with typing.

You said that before.

> CPU_PTR and THIS_CPU can be applied both to percpu pointers and
> percpu variables. The new API unifies the handling which is required in
> order for the new cpu_ops to work both on statically and dynamically
> allocated percpu data.

And if you called them per_cpu_ptr and __get_cpu_ptr they would have these 
same properties.  But now the names would be consistent.

So let's just reimplement the original API and be done.
Rusty.
