Return-Path: <linux-kernel-owner+w=401wt.eu-S964862AbXCSVZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964862AbXCSVZj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 17:25:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753462AbXCSVZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 17:25:39 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:48420 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470AbXCSVZi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 17:25:38 -0400
To: akpm@linux-foundation.org, mpm@selenic.com
Subject: Re: [PATCH] slab: deal with NULL pointers passed to kmem_cache_free
X-IlohaMail-Blah: penberg@cs.helsinki.fi
X-IlohaMail-Method: mail() [mem]
X-IlohaMail-Dummy: moo
X-Mailer: IlohaMail/0.8.12+pk-11 (On: iloha.cs.Helsinki.FI)
In-Reply-To: <20070319141038.212d4ac9.akpm@linux-foundation.org>
Message-ID: <az5Ytbv5.1174339536.7416370.penberg@cs.helsinki.fi>
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
CC: "Christoph Lameter" <clameter@sgi.com>,
       "Pekka J Enberg" <penberg@cs.helsinki.fi>,
       "ast@domdv.de" <ast@domdv.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Date: Mon, 19 Mar 2007 23:25:36 +0200 (EET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On 3/19/2007, "Andrew Morton" <akpm@linux-foundation.org> wrote:
> Would prefer to do:
> 
> static inline void kmem_cache_free_if_not_null(struct kmem_cache *cachep,
> 						void *objp)
> {
> 	if (objp)
> 		kmem_cache_free(cachep, objp);
> }
> 
> so that we don't add extra overhead to all the thousands of existing,
> well-behaved callsites.

That bloats kernel text all the same so it's much cleaner to just make
the callers explicitly check for NULL then. That said, I'm sorry but I
just don't buy the "overhead" part of your argument since it's one
branch and no extra data cache pressure especially as we're already
doing the BUG_ON and page flag checking.

But, since you're NAKing my patch, we need to get the mempool for from
the original thread in to fix the oops.

                                     Pekka
