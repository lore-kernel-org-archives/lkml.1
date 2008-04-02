Return-Path: <linux-kernel-owner+w=401wt.eu-S1754313AbYDBKqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313AbYDBKqu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 06:46:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752651AbYDBKql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 06:46:41 -0400
Received: from wx-out-0506.google.com ([66.249.82.227]:39800 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563AbYDBKqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 06:46:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=kySexQFrPFaOMAwal/jsiG9V4nco/8D1lVj91/JGbFFmS7lhyvOSvKeS39PhawRB7Ee7ZQLZzHXj8krSRPw5aZn/wuTV9bJ0sL9lEQf6ZRBUiM7qvLDVU8ySfZcIPy0ItSnbhIwfnIQ62C/6NsdHyzYCF0AcoZgXiHJSeMO17sg=
Message-ID: <84144f020804020346v6c6de91fr795dec55e0543105@mail.gmail.com>
Date: Wed, 2 Apr 2008 13:46:39 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: paulmck@linux.vnet.ibm.com
Subject: Re: kmemcheck caught read from freed memory (cfq_free_io_context)
Cc: "Jens Axboe" <jens.axboe@oracle.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Vegard Nossum" <vegard.nossum@gmail.com>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Christoph Lameter" <clameter@sgi.com>
In-Reply-To: <20080402104025.GC2813@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0804011408v19e13b6cje1ca89a2a471484c@mail.gmail.com>
	 <1207085788.29991.6.camel@lappy> <20080402071709.GC12774@kernel.dk>
	 <20080402104025.GC2813@linux.vnet.ibm.com>
X-Google-Sender-Auth: 7e2d2d41e15b7eaa
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Wed, Apr 2, 2008 at 1:40 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
>  I am still confused.
>
>  o       The kmem_cache has SLAB_DESTROY_BY_RCU.
>
>  o       This means that a given slab should not be returned to the
>         system until a grace period elapses.

Yeah, that's what I thought too, that this is a SLUB bug but Peter
convinced me otherwise. SLUB keeps the _page_ around so the pointer
will be _valid_, although it might not be _your_ pointer so the caller
needs to do some validation step. Or at least that's how I understood
what Peter was saying.

                      Pekka
