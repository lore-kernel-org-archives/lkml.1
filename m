Return-Path: <linux-kernel-owner+w=401wt.eu-S1753418AbXLERuv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418AbXLERuv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 12:50:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751624AbXLERuo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 12:50:44 -0500
Received: from panic.printk.net ([217.147.83.20]:34212 "EHLO panic.printk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751461AbXLERun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 12:50:43 -0500
Subject: Re: How to manage shared persistent local caching (FS-Cache) with
	NFS?
From: Jon Masters <jonathan@jonmasters.org>
To: David Howells <dhowells@redhat.com>
Cc: Peter Staubach <staubach@redhat.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Steve Dickson <SteveD@redhat.com>, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <6306.1196874660@redhat.com>
References: <6306.1196874660@redhat.com>
Content-Type: text/plain
Organization: World Organi[sz]ation Of Broken Dreams
Date: Wed, 05 Dec 2007 12:49:59 -0500
Message-Id: <1196876999.3325.5.camel@jcmlaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-33.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-12-05 at 17:11 +0000, David Howells wrote:

> The downside of this is that each shared superblock only has one NFS connection
> to the server, and so only one set of connection parameters can be used.
> However, since persistent local caching is novel to Linux, I think that it is
> entirely reasonable to overrule the attempts to make mounts with different
> parameters if they are to be shared and cached.

I think the shared superblock approach is the right one, but I'm a
little concerned that there would now be different behavior for fscache
and non-cached setups. Not sure of any better idea though.

> The R/O mount flag can be dealt with by moving readonlyness into the vfsmount
> rather than having it a property of the superblock.  The superblock would then
> be read-only only if all its vfsmounts are also read-only.

Given that, how many connection parameters are there that are likely to
actually differ on the same client, talking to the same server? Really?

> Would it be reasonable to have an outside way of setting directory options?
> For instance, if there was a table like this:
> 
> 	FS	SERVER	VOLUME	DIR		OPTIONS
> 	=======	=======	=======	===============	=========================
> 	nfs	home0	-	/home/*		fscache
> 	afs	redhat	data	/data/*		fscache
> 
> This could then be loaded into the kernel as a set of rules which directory
> lookup by the filesystem involved could attempt to match and apply.

You could store the table in a NIS map, for example, and a udev rule or
similar could trigger to load it later.

Jon.


