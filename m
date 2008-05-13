Return-Path: <linux-kernel-owner+w=401wt.eu-S1758720AbYEMGOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758720AbYEMGOS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 02:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756472AbYEMGOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 02:14:10 -0400
Received: from qb-out-0506.google.com ([72.14.204.234]:6804 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756175AbYEMGOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 02:14:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=RBOeEdkwUlRMgu9ueBfwGUPFE8RRReBoWf8gT5LYrgLnqyizzAWKrbZCgvDdUBoVgwcgHTlZB8l/x8xtLYN9+rJOv8VmRg3ocI634gGWAp+G8RAdX8gE7tZ5MTeL/1xS26tCHMNw5bNphBcUdfG+ca9m11Hlx2rexf+bv8ARgR0=
Message-ID: <84144f020805122314m54039e0bg38a16e91da996a1d@mail.gmail.com>
Date: Tue, 13 May 2008 09:14:05 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Benny Halevy" <bhalevy@panasas.com>
Subject: Re: [PATCH] SLUB: clear c->freelist in __slab_alloc()/load_freelist:/SlabDebug path
Cc: "Christoph Lameter" <clameter@sgi.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <4828A940.2090604@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4828A940.2090604@panasas.com>
X-Google-Sender-Auth: 2d8100786f017295
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2008 at 11:32 PM, Benny Halevy <bhalevy@panasas.com> wrote:
> In the __slab_alloc()/load_freelist:/SlabDebug(c->page) path we only
>  use the object at the head of c->page->freelist
>  and the tail goes back to c->page->freelist.
>  We then set c->node = -1 to force __slab_alloc in next allocation.
>  c->freelist therefore needs to be cleared as it is invalid at this point.
>
>  @@ -1606,6 +1606,7 @@ debug:
>         if (!alloc_debug_processing(s, c->page, object, addr))
>                 goto another_slab;
>
>  +       c->freelist = NULL;
>         c->page->inuse++;
>         c->page->freelist = object[c->offset];
>         c->node = -1;

Makes sense. Christoph?
