Return-Path: <linux-kernel-owner+w=401wt.eu-S936983AbXLQWo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936983AbXLQWo3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 17:44:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932963AbXLQWnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 17:43:53 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38580 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933676AbXLQWnv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 17:43:51 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <200712141451.56870.nickpiggin@yahoo.com.au>
References: <200712141451.56870.nickpiggin@yahoo.com.au> <20071205193818.24617.79771.stgit@warthog.procyon.org.uk> <20071205193904.24617.94077.stgit@warthog.procyon.org.uk>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: dhowells@redhat.com, viro@ftp.linux.org.uk, hch@infradead.org,
       Trond.Myklebust@netapp.com, sds@tycho.nsa.gov, casey@schaufler-ca.com,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH 09/28] FS-Cache: Release page->private after failed readahead [try #2]
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Mon, 17 Dec 2007 22:42:13 +0000
Message-ID: <674.1197931333@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> This is pretty nasty.

Why?  If the fs doesn't set PG_private or PG_fscache on any pages before
calling read_cache_pages(), there's no difference.

Furthermore, the differences only crop up in the error handling paths.

> I would suggest either to have the function return the number of pages that
> were added to pagecache,

Which helps how?

> or just open code it.

Well, I could give an alternative read_cache_pages(), I suppose, for just this
situation, but that means there are two parallel functions which then both
need to be maintained.

David
