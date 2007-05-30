Return-Path: <linux-kernel-owner+w=401wt.eu-S1751974AbXE3Ifw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974AbXE3Ifw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 04:35:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750942AbXE3Ifn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 04:35:43 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50220 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803AbXE3Ifm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 04:35:42 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20070529215736.GO6815@fieldses.org>
References: <20070529215736.GO6815@fieldses.org> <20070529145426.19366.35289.stgit@warthog.cambridge.redhat.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] AFS: Implement file locking [try #2]
X-Mailer: MH-E 8.0; nmh 1.2-20070115cvs; GNU Emacs 22.0.50
Date: Wed, 30 May 2007 09:35:32 +0100
Message-ID: <32087.1180514132@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

J. Bruce Fields <bfields@fieldses.org> wrote:

> --without having tried to understand how they're actually used, these
> data structures (like the pending_locks and granted_locks lists) seem to
> duplicate stuff that's already kept in fs/locks.c.  Is there a reason
> they're required?

Yes.  I need to get the server lock first, before going to the VFS locking
routines.  The VFS routines as they stand aren't particularly useful, and they
permit things that AFS doesn't support (such as lock upgrading).

David
