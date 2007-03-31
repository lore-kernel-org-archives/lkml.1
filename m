Return-Path: <linux-kernel-owner+w=401wt.eu-S1752343AbXCaM74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343AbXCaM74 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 08:59:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752904AbXCaM74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 08:59:56 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38556 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752343AbXCaM74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 08:59:56 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0703310005350.32047@blonde.wat.veritas.com> 
References: <Pine.LNX.4.64.0703310005350.32047@blonde.wat.veritas.com>  <20070329203913.GA5190@skull.piratehaven.org> <20070330134359.ec6d95bc.akpm@linux-foundation.org> <Pine.LNX.4.64.0703302250050.28059@blonde.wat.veritas.com> <20070330151353.95cd56ed.akpm@linux-foundation.org> 
To: Hugh Dickins <hugh@veritas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Brian Pomerantz <bapper@piratehaven.org>, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH] fix page leak during core dump 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Sat, 31 Mar 2007 13:59:45 +0100
Message-ID: <2879.1175345985@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins <hugh@veritas.com> wrote:

> No, I think that's wrong: whereas the binfmt_elf one did its
> page_cache_release down below at the bottom of the block, this
> version does it in each subblock,

All but the first, which is why there's not a common one post if-complex.

> so there you're removing the dump_seek success one.  Can't we preserve that
> beauteous macro here and just do...
> ...
> -				DUMP_SEEK(file->f_pos + PAGE_SIZE);
>  				page_cache_release(page);
> +				DUMP_SEEK(file->f_pos + PAGE_SIZE);

Actually, that works just as well, I think.  I like it better than my
suggestion (see email in response to Andrew).

David
