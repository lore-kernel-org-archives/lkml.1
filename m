Return-Path: <linux-kernel-owner+w=401wt.eu-S1756912AbYKVAjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756912AbYKVAjb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 19:39:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753925AbYKVAjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 19:39:21 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53397 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753455AbYKVAjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 19:39:21 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20081121101718.aa1dfc25.akpm@linux-foundation.org>
References: <20081121101718.aa1dfc25.akpm@linux-foundation.org> <20081121000913.6506d7b6.akpm@linux-foundation.org> <20081120144139.10667.75519.stgit@warthog.procyon.org.uk> <20081120144145.10667.39594.stgit@warthog.procyon.org.uk> <18617.1227263040@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dhowells@redhat.com, trond.myklebust@fys.uio.no, viro@ZenIV.linux.org.uk,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 01/45] Create a dynamically sized pool of threads for doing very slow work items [ver #41]
Date: Sat, 22 Nov 2008 00:38:58 +0000
Message-ID: <19593.1227314338@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> Those two objectives seem incompatible.  What does a caller do when the
> limit has been hit?  Do the work synchronously?

No.  The work is queued for later processing by the pool.  The piece of memory
that records the pending work is much smaller than the memory required to hold
a thread.  The threads in the pool actually do the work.  The submitter of the
work gets on with its life - unless it has to be synchronous.

David
