Return-Path: <linux-kernel-owner+w=401wt.eu-S1757962AbZBKRDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757962AbZBKRDT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 12:03:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756557AbZBKRDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 12:03:08 -0500
Received: from mx2.redhat.com ([66.187.237.31]:54728 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751169AbZBKRDF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 12:03:05 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090211163753.GA29372@us.ibm.com>
References: <20090211163753.GA29372@us.ibm.com> <20090206113556.GA3161@alice> <20090206161518.81e7d42c.akpm@linux-foundation.org> <19f34abd0902102355o5bf51096o9aa3737e87104fb9@mail.gmail.com> <20090211000740.f1de7cec.akpm@linux-foundation.org> <19f34abd0902110248n22f8de12lccfa99faafafb942@mail.gmail.com> 
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: dhowells@redhat.com, Vegard Nossum <vegard.nossum@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Sesterhenn <snakebyte@gmx.de>, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org, Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: namespaces?: bug at mm/slub.c:2750
Date: Wed, 11 Feb 2009 17:02:44 +0000
Message-ID: <1538.1234371764@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn <serue@us.ibm.com> wrote:

>  static void uid_hash_remove(struct user_struct *up)
>  {
> +	put_user_ns(up->user_ns);
>  	hlist_del_init(&up->uidhash_node);
>  }

Don't you need to do the hlist_del_init() first?  Otherwise, mightn't the
put_user_ns() cause the namespace to be freed before hlist_del_init() removes
the user_struct from it?

David
