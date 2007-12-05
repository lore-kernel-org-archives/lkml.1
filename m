Return-Path: <linux-kernel-owner+w=401wt.eu-S1754136AbXLESE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136AbXLESE5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 13:04:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751839AbXLESEu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 13:04:50 -0500
Received: from mx1.redhat.com ([66.187.233.31]:59834 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751791AbXLESEt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 13:04:49 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1196876999.3325.5.camel@jcmlaptop>
References: <1196876999.3325.5.camel@jcmlaptop> <6306.1196874660@redhat.com>
To: Jon Masters <jonathan@jonmasters.org>
Cc: dhowells@redhat.com, Peter Staubach <staubach@redhat.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Steve Dickson <SteveD@redhat.com>, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org
Subject: Re: How to manage shared persistent local caching (FS-Cache) with NFS?
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Wed, 05 Dec 2007 18:03:58 +0000
Message-ID: <6513.1196877838@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jon Masters <jonathan@jonmasters.org> wrote:

> I think the shared superblock approach is the right one, but I'm a
> little concerned that there would now be different behavior for fscache
> and non-cached setups. Not sure of any better idea though.

The behaviour varies a bit anyway because there's a cache...

> > The R/O mount flag can be dealt with by moving readonlyness into the
> > vfsmount rather than having it a property of the superblock.  The
> > superblock would then be read-only only if all its vfsmounts are also
> > read-only.
> 
> Given that, how many connection parameters are there that are likely to
> actually differ on the same client, talking to the same server? Really?

I don't have figures on that, but I do know people have complained about it
for non-cached conditions.

> You could store the table in a NIS map, for example, and a udev rule or
> similar could trigger to load it later.

My point was meant to be that the presence and coverage of a cache is more
likely to reflect the client machine than would the NIS map for the NFS
automounts.  You wouldn't necessarily want to store this table in NIS.

David
