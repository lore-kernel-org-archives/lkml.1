Return-Path: <linux-kernel-owner+w=401wt.eu-S1755396AbZECJ7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396AbZECJ7Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 05:59:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752802AbZECJ7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 05:59:16 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:59910 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295AbZECJ7P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 05:59:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=DiwW6sUqUuTa2NaIcgCiNl9K+O/pqjJtJTi/II0CJxjtgng01qOslRgr9Z7h2uVba1
         AaAE143AgDPv9oxAQo/FbtwHfG9iHRwR1ecMBi8MhZmIuZjdfQC8n6qp/aVr97y5SQkF
         dntsk7OIB93YFgg+FRGKduZD8ln6sC7EGzubM=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0905030203520.16287@chino.kir.corp.google.com>
References: <20090501195638.GC4633@lenovo> <20090501200331.GA2645@elte.hu>
	 <20090501200937.GD4633@lenovo> <20090501202511.GE4633@lenovo>
	 <20090501203123.GA10878@sgi.com> <20090503084847.GA20394@elte.hu>
	 <alpine.DEB.2.00.0905030203520.16287@chino.kir.corp.google.com>
Date: Sun, 3 May 2009 12:59:13 +0300
X-Google-Sender-Auth: 9901061cd8ab3ac7
Message-ID: <84144f020905030259i59ea304ftdc9224e6a9b5c285@mail.gmail.com>
Subject: Re: [PATCH -tip] x86: uv - prevent NULL dereference in uv_system_init
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, Jack Steiner <steiner@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Sun, May 3, 2009 at 12:09 PM, David Rientjes <rientjes@google.com> wrote:
> SLUB stores two new slab allocation orders: the cache's adjustable order
> which is calculated at kmem_cache_create(), and the smallest order that
> can accommodate at least one object allocation.  The latter is used as a
> fallback when the former fails in the page allocator.
>
> So for __GFP_PANIC to work in this case, it could not be implemented in
> the page allocator (SLUB also passes __GFP_NORETRY for new slabs) but
> rather above it in allocate_slab().  It would then be a no-op for
> alloc_pages().

It's probably better to implement __GFP_PANIC in alloc_pages() because
of kmalloc_large(). You can easily mask the __GFP_PANIC from the first
call to alloc_slab_page() where we use __GFP_NOWARN to suppress
out-of-memory warnings.

But anyway, enough talk, show me the patch! :-)

                                          Pekka
