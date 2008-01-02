Return-Path: <linux-kernel-owner+w=401wt.eu-S1759419AbYABQ1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759419AbYABQ1m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 11:27:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755100AbYABQ1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 11:27:34 -0500
Received: from mx1.redhat.com ([66.187.233.31]:53943 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753842AbYABQ1d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 11:27:33 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <200712211208.24026.nickpiggin@yahoo.com.au>
References: <200712211208.24026.nickpiggin@yahoo.com.au> <200712181800.23578.nickpiggin@yahoo.com.au> <643.1197930966@redhat.com> <6481.1198175619@redhat.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: dhowells@redhat.com, viro@ftp.linux.org.uk, hch@infradead.org,
       Trond.Myklebust@netapp.com, sds@tycho.nsa.gov, casey@schaufler-ca.com,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH 10/28] FS-Cache: Recruit a couple of page flags for cache management [try #2]
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Wed, 02 Jan 2008 16:27:03 +0000
Message-ID: <18996.1199291223@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> Then make a PG_private2 bit and use that.

To what end?  Are you suggesting I should have:

	PG_private2 = PG_private | PG_fscache

That's redundant information and doesn't help anything really.

My suggestion (PG_private and PG_fscache separate and independent) is pretty
efficient to actually render into machine instructions, especially if the two
bits are placed in the lower part of the word.  On x86, the test for both bits
can be done with a single TEST instruction, and on most RISC archs, a MOVE and
a single AND will usually suffice.

David
