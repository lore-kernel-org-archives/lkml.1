Return-Path: <linux-kernel-owner+w=401wt.eu-S1765478AbXIUXPB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765478AbXIUXPB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 19:15:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763404AbXIUXOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 19:14:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57776 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763180AbXIUXOu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 19:14:50 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1190403225.6721.6.camel@heimdal.trondhjem.org>
References: <1190403225.6721.6.camel@heimdal.trondhjem.org> <20070921144703.8323.50492.stgit@warthog.procyon.org.uk> <20070921144800.8323.72246.stgit@warthog.procyon.org.uk>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: dhowells@redhat.com, viro@ftp.linux.org.uk, hch@infradead.org,
       sds@tycho.nsa.gov, casey@schaufler-ca.com, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 11/22] CacheFiles: Permit the page lock state to be monitored
X-Mailer: MH-E 8.0.3; nmh 1.2-20070115cvs; GNU Emacs 22.1.50
Date: Sat, 22 Sep 2007 00:14:41 +0100
Message-ID: <10150.1190416481@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Trond Myklebust <Trond.Myklebust@netapp.com> wrote:

> > This is used by CacheFiles to detect read completion on a page in the
> > backing filesystem so that it can then copy the data to the waiting netfs
> > page.
> 
> Won't it in any case want to lock the page too?

No.  Why would it?  All it wants to do is to read the page (copying it to the
netfs's page), assuming it becomes PG_uptodate.

> That would be the only way to ensure that the page is still mapped into the
> address space when you're writing it out...

I don't understand what you're getting at.  Write the page out where?  We've
just read it in from the cache, so why would we be writing it back out?

David
