Return-Path: <linux-kernel-owner+w=401wt.eu-S1752122AbXE3KgL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122AbXE3KgL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 06:36:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751447AbXE3Kf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 06:35:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55111 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888AbXE3Kf6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 06:35:58 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1180050860.8872.42.camel@heimdal.trondhjem.org>
References: <1180050860.8872.42.camel@heimdal.trondhjem.org> <1180046115.8872.27.camel@heimdal.trondhjem.org> <20070524133821.3ee9c9f3.akpm@linux-foundation.org> <20070523191518.24135.81257.stgit@warthog.cambridge.redhat.com> <20070523191524.24135.2609.stgit@warthog.cambridge.redhat.com> <27608.1180042522@redhat.com> <29320.1180048725@redhat.com> 
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] AFS: Add a function to excise a rejected write from the pagecache
X-Mailer: MH-E 8.0; nmh 1.2-20070115cvs; GNU Emacs 22.0.50
Date: Wed, 30 May 2007 11:35:23 +0100
Message-ID: <10564.1180521323@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Trond Myklebust <trond.myklebust@fys.uio.no> wrote:

> All I do is to protect new calls to read() and write() with a call to
> check if the page cache needs invalidating.

What about mmap()?  What if someone gets a mapping on a section of file that
subsequently has a write rejected on it?  If you invalidate only on
read()/write(), what do you do about such a mapping?

> That won't stop any existing append writes from punching ugly holes into the
> file, but trying to recover from that sort of thing would be _really_
> painful!

Definitely.

David
