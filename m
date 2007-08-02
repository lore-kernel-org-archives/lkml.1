Return-Path: <linux-kernel-owner+w=401wt.eu-S1755952AbXHBD5O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952AbXHBD5O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 23:57:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753174AbXHBD5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 23:57:04 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56410 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753033AbXHBD5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 23:57:03 -0400
Date: Wed, 1 Aug 2007 20:56:13 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org
Subject: Re: [RFC PATCH] type safe allocator
In-Reply-To: <E1IGAAI-0006K6-00@dorka.pomaz.szeredi.hu>
Message-ID: <alpine.LFD.0.999.0708012051100.3582@woody.linux-foundation.org>
References: <E1IGAAI-0006K6-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 1 Aug 2007, Miklos Szeredi wrote:
>
> I wonder why we don't have type safe object allocators a-la new() in
> C++ or g_new() in glib?
> 
>   fooptr = k_new(struct foo, GFP_KERNEL);

I would object to this if only because of the horrible name.

C++ is not a good language to take ideas from, and "new()" was not it's 
best feature to begin with. "k_new()" is just disgusting.

I'd call it something like "alloc_struct()" instead, which tells you 
exactly what it's all about. Especially since we try to avoid typedefs in 
the kernel, and as a result, it's basically almost always a struct thing.

That said, I'm not at all sure it's worth it. Especially not with all the 
various variations on a theme (zeroed, arrays, etc etc).

Quite frankly, I suspect you would be better off just instrumenting 
"sparse" instead, and matching up the size of the allocation with the type 
it gets assigned to.

		Linus
