Return-Path: <linux-kernel-owner+w=401wt.eu-S1757584AbZBKSD0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757584AbZBKSD0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 13:03:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750945AbZBKSDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 13:03:17 -0500
Received: from mx2.redhat.com ([66.187.237.31]:38822 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753942AbZBKSDR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 13:03:17 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090211172416.GA30756@us.ibm.com>
References: <20090211172416.GA30756@us.ibm.com> <20090211163753.GA29372@us.ibm.com> <20090206113556.GA3161@alice> <20090206161518.81e7d42c.akpm@linux-foundation.org> <19f34abd0902102355o5bf51096o9aa3737e87104fb9@mail.gmail.com> <20090211000740.f1de7cec.akpm@linux-foundation.org> <19f34abd0902110248n22f8de12lccfa99faafafb942@mail.gmail.com> <1538.1234371764@redhat.com> 
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: dhowells@redhat.com, Vegard Nossum <vegard.nossum@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Sesterhenn <snakebyte@gmx.de>, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org, Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: namespaces?: bug at mm/slub.c:2750
Date: Wed, 11 Feb 2009 18:03:01 +0000
Message-ID: <2532.1234375381@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn <serue@us.ibm.com> wrote:

> It's called under uidhash_lock spinlock so should be ok, but in
> principle you're right so it's probably a good idea.

The lock is nothing to do with it.  put_user_ns() may call kfree() on the
user_namespace, but the user_struct given to uid_hash_remove() may still be
attached to it.

David
