Return-Path: <linux-kernel-owner+w=401wt.eu-S1758801AbXEJJ5H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758801AbXEJJ5H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 05:57:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758497AbXEJJ4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 05:56:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51979 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755147AbXEJJ4t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 05:56:49 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
In-Reply-To: <46425C55.6050000@yahoo.com.au>
References: <46425C55.6050000@yahoo.com.au> <20070508194358.27477.74888.stgit@warthog.cambridge.redhat.com> <20070508194411.27477.7552.stgit@warthog.cambridge.redhat.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: David Howells <dhowells@redhat.com>, akpm@osdl.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 3/3] AFS: Implement basic file write support
X-Mailer: MH-E 8.0; nmh 1.2-20070115cvs; GNU Emacs 22.0.50
Date: Thu, 10 May 2007 10:56:32 +0100
Message-ID: <27482.1178790992@warthog.cambridge.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> Why do you call SetPageUptodate when the page is not up to date?
> That leaks uninitialised data, AFAIKS.

It only seems that way.  If afs_prepare_write() is called, but doesn't return
an error, then afs_commit_write() will be called, and it seems that the copy
in of the data will be guaranteed not to fail by the caller.

Furthermore, afs_prepare_page() will have filled in the missing bits.

And whilst all that is going on, the page lock will be help by the caller, so
that no-one else can access the partially complete page.

I suppose I could call SetPageUptodate() in afs_commit_write() instead.

David
