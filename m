Return-Path: <linux-kernel-owner+w=401wt.eu-S1756705AbYLEStg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756705AbYLEStg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 13:49:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753195AbYLESt2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 13:49:28 -0500
Received: from mx2.redhat.com ([66.187.237.31]:34904 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751439AbYLESt2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 13:49:28 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.LFD.2.00.0812050848060.3386@nehalem.linux-foundation.org>
References: <alpine.LFD.2.00.0812050848060.3386@nehalem.linux-foundation.org> <20081205162318.20732.73054.stgit@warthog.procyon.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       bfields@fieldses.org, hugh@veritas.com, hch@infradead.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] EXPORTFS: Don't return NULL from fh_to_dentry()/fh_to_parent() [ver #4]
Date: Fri, 05 Dec 2008 18:49:14 +0000
Message-ID: <23235.1228502954@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> It's not like returning NULL doesn't make sense. Quite frankly, I think it 
> makes a lot more sense than returning -ESTALE, which is a very unnatural 
> error for most filesystems.

The d_obtain_alias() function will immediately return -ESTALE if given a NULL
inode, though, and sometimes it'll return some other error.

It would also seem odd to sometimes return NULL to indicate an error, and
sometimes return a -ve error code to indicate an error.  Perhaps one or the
other should be selected for consistency.

David
