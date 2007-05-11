Return-Path: <linux-kernel-owner+w=401wt.eu-S1759999AbXEKKDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759999AbXEKKDy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 06:03:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756716AbXEKKDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 06:03:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56546 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752342AbXEKKDn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 06:03:43 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20070511025822.a5aa5240.akpm@linux-foundation.org>
References: <20070511025822.a5aa5240.akpm@linux-foundation.org> <20070510161946.96ff0784.akpm@linux-foundation.org> <20070510143334.19485.26042.stgit@warthog.cambridge.redhat.com> <8792.1178876963@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/2] AFS: Fix interminable loop in afs_write_back_from_locked_page()
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Fri, 11 May 2007 11:03:37 +0100
Message-ID: <11025.1178877817@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> Yes, it's a shame that there doesn't seem to be a fine-grained way of
> turning on -W's useful bits.

You can turn off -W's undesirable bits.  For net/rxrpc/ and fs/afs/ at least,
adding:

	CFLAGS += -W -Wno-unused-parameter

to the Makefile generates no warnings.  Perhaps this should be added to the
master Makefile.

Adding -Wsign-compare finds some stuff that I will fix.  It also finds some
stuff in the main and the networking headers.  This is a really useful option
and found some tricky bugs in CacheFiles.  I would endorse adding this
generally too.

David
