Return-Path: <linux-kernel-owner+w=401wt.eu-S1757130AbYCNCfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757130AbYCNCfu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 22:35:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753465AbYCNCfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 22:35:41 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58236 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752269AbYCNCfk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 22:35:40 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20080313152059.90681241.akpm@linux-foundation.org>
References: <20080313152059.90681241.akpm@linux-foundation.org> <20080313191432.28959.52722.stgit@warthog.procyon.org.uk> <20080313191437.28959.4396.stgit@warthog.procyon.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dhowells@redhat.com, torvalds@linux-foundation.org, kwc@citi.umich.edu,
       arunsr@cse.iitk.ac.in, dwalsh@redhat.com,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] KEYS: Don't generate user and user session keyrings unless they're accessed
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Fri, 14 Mar 2008 02:30:20 +0000
Message-ID: <4243.1205461820@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> hm, I didn't realise that the keys code had special knowlege of "root". 
> How does that play alongside the containers stuff?

The containers stuff lacks a keys container.  I'll have to attend to that at
some point.

The key code didn't so much have special knowledge of root, as UID 0 is
compiled into the kernel in various ways.

> would be more conventional.
> 
> But better would be to teach alloc_uid() about kmem_cache_zalloc() then
> take a chainsaw to it.

Yeah, I was thinking that.  That'd allow a slew of initialisations-to-zero to
be removed from that function, as indeed you have done in your attached patch.

> From: Andrew Morton <akpm@linux-foundation.org>
> 
> Use kmem_cache_zalloc(), remove large amounts of initialsiation code and
> ifdeffery.

"initialisation" perchance? :-)

> Note: this assumes that memset(*atomic_t, 0) correctly initialises the
> atomic_t.  This is true for all present archtiectures and if it becomes false
> for a future architecture then we'll need to make large changes all over the
> place anyway.
> 
> 
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Acked-by: David Howells <dhowells@redhat.com>

David
