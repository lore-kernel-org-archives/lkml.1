Return-Path: <linux-kernel-owner+w=401wt.eu-S935992AbXLQWhe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935992AbXLQWhe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 17:37:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759605AbXLQWhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 17:37:14 -0500
Received: from mx1.redhat.com ([66.187.233.31]:39867 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761614AbXLQWhM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 17:37:12 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <200712141508.23756.nickpiggin@yahoo.com.au>
References: <200712141508.23756.nickpiggin@yahoo.com.au> <20071205193818.24617.79771.stgit@warthog.procyon.org.uk> <20071205193909.24617.26538.stgit@warthog.procyon.org.uk>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: dhowells@redhat.com, viro@ftp.linux.org.uk, hch@infradead.org,
       Trond.Myklebust@netapp.com, sds@tycho.nsa.gov, casey@schaufler-ca.com,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH 10/28] FS-Cache: Recruit a couple of page flags for cache management [try #2]
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Mon, 17 Dec 2007 22:36:06 +0000
Message-ID: <643.1197930966@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> I'd much prefer if you would handle this in the filesystem, and have it
> set PG_private whenever fscache needs to receive a callback, and DTRT
> depending on whether PG_fscache etc. is set or not.

That's tricky and slower[*].  One of the things I want to do is to modify
iso9660 to do be able to do caching, but PG_private is 'owned' by the generic
buffer cache code.

[*] though perhaps not significantly.

> Also, this wait_on_page_fscache_write / end_page_fscache_write stuff
> seems like it would belong in your fscache headers rather than generic
> mm code (ditto for your PG_fscache checks in the page allocator -- you
> should use their PG_owner_priv_? names for that).

I suppose that's reasonable, though I do want to mention the PG_fscache* bits
in linux/page-flags.h so that anyone looking at those bits to select one to
use can easily see a reason they might not want to.

David
