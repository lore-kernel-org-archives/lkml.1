Return-Path: <linux-kernel-owner+w=401wt.eu-S1759227AbYEISID@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759227AbYEISID (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 14:08:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750774AbYEISHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 14:07:52 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:26807 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbYEISHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 14:07:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=o7HdDJFdHs4Rvxpb0Y67ypLFDq+dfowQCVFyaJDtVlbrc4+weFY0ksMHcKIrMk0kXH9NhT/4gBQSnwH24BzDInslkHIXR2tj1Y2ijlEnZhDApGxcAZoIGZYsoFdDnUUHPICiwnvd4A1weEeOjG8U+Un8ON8ox8jwaa7+b1LbUgI=
Message-ID: <19f34abd0805091107p1dc1646et2b255d7ba45af8f2@mail.gmail.com>
Date: Fri, 9 May 2008 20:07:48 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Pekka J Enberg" <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 1/3] kmemcheck: prepare for SLAB hooks
Cc: mingo@elte.hu, clameter@sgi.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0805090000540.28488@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0805090000540.28488@sbz-30.cs.Helsinki.FI>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 8, 2008 at 11:02 PM, Pekka J Enberg <penberg@cs.helsinki.fi> wrote:
> From: Pekka Enberg <penberg@cs.helsinki.fi>
>
> Make mm/slub_kmemcheck.c more generic in preparation for adding kmemcheck hooks
> to SLAB which does not use compound pages by default and has slightly different
> way for keeping track of object size than SLUB.
>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Christoph Lameter <clameter@sgi.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Vegard Nossum <vegard.nossum@gmail.com>
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
> ---
>  include/linux/slub_kmemcheck.h |   19 +++++++++++--------
>  mm/slub.c                      |    8 ++++----
>  mm/slub_kmemcheck.c            |   23 ++++++++++-------------
>  3 files changed, 25 insertions(+), 25 deletions(-)

[sniip]

> @@ -1757,7 +1757,7 @@
>        struct kmem_cache_cpu *c;
>        unsigned long flags;
>
> -       kmemcheck_slab_free(s, object);
> +       kmemcheck_slab_free(s, object, c->objsize);

Hm, "'c' is used uninitialized in this function". I guess it should be
moved a bit downwards. Can you fix it?

Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
