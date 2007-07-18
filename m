Return-Path: <linux-kernel-owner+w=401wt.eu-S1762758AbXGRJY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762758AbXGRJY0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 05:24:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751521AbXGRJYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 05:24:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41247 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753116AbXGRJYL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 05:24:11 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20070717175017.8b8a8976.akpm@linux-foundation.org>
References: <20070717175017.8b8a8976.akpm@linux-foundation.org> <20070717124732.22619.34179.stgit@warthog.cambridge.redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] AFS: Fix file locking
X-Mailer: MH-E 8.0; nmh 1.2-20070115cvs; GNU Emacs 22.0.50
Date: Wed, 18 Jul 2007 10:23:35 +0100
Message-ID: <5540.1184750615@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> Here we use
> 
> 	vnode->flags & (1 << foo)
> 
> > +		set_bit(AFS_VNODE_LOCKING, &vnode->flags);
> 
> and elsewhere we use set_bit(foo, &vnode->flags) and clear_bit()

Ah...  IIRC I was originally testing multiple bits in one go (test_bit()'s do
not merge because of the volatile pointer).

However, as I'm doing only one test now, I'll convert it to test_bit().

David
