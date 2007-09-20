Return-Path: <linux-kernel-owner+w=401wt.eu-S1756860AbXITPhN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756860AbXITPhN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 11:37:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756145AbXITPg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 11:36:58 -0400
Received: from web36603.mail.mud.yahoo.com ([209.191.85.20]:27764 "HELO
	web36603.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755740AbXITPg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 11:36:57 -0400
X-YMail-OSG: hCGPzH4VM1l88KYw1_PO2WeQjIk6HEl6Wo.Pa6NixPL9JC7eD04dSwpD6HVuUjnTq4cAgw4sbQ--
X-RocketYMMF: rancidfat
Date: Thu, 20 Sep 2007 08:36:57 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH 3/3] CRED: Move the effective capabilities into the cred struct
To: Trond Myklebust <Trond.Myklebust@netapp.com>,
       Andrew Morgan <morgan@kernel.org>
Cc: David Howells <dhowells@redhat.com>, viro@ftp.linux.org.uk,
       hch@infradead.org, sds@tycho.nsa.gov, casey@schaufler-ca.com,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
In-Reply-To: <1190295535.6763.29.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <176624.5520.qm@web36603.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Trond Myklebust <Trond.Myklebust@netapp.com> wrote:

> On Wed, 2007-09-19 at 21:11 -0700, Andrew Morgan wrote:
> > -----BEGIN PGP SIGNED MESSAGE-----
> > Hash: SHA1
> > 
> > David Howells wrote:
> > > Move the effective capabilities mask from the task struct into the
> credentials
> > > record.
> > > 
> > > Note that the effective capabilities mask in the cred struct shadows that
> in
> > > the task_struct because a thread can have its capabilities masks changed
> by
> > > another thread.  The shadowing is performed by update_current_cred()
> which is
> > > invoked on entry to any system call that might need it.
> > 
> > OOC If we were to simply drop support for one process changing the
> > capabilities of another, would we need this patch?
> 
> No. This has nothing to do about one process changing some other
> process' capabilities. It has to do with being able to pass security
> information around the kernel beyond the confines of the task struct.
> 
> This is needed in order to deal with asynchronous i/o where security
> checks may have to be deferred, and where the task struct may no longer
> be available.
> One example would be a failover situation when doing deferred writes: if
> the first choice of storage medium is unavailable, and the kernel tries
> to fail the write over to another storage. On NFS that might involve
> having to build up a new RPCSEC_GSS security context for the new server.
> Currently, you cannot do this safely because all the security info is
> cached in the task struct and much of it cannot be copied.

Ok, what can't be copied, and why can't it be copied?


Casey Schaufler
casey@schaufler-ca.com
