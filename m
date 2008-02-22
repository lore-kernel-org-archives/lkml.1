Return-Path: <linux-kernel-owner+w=401wt.eu-S1758162AbYBVQuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758162AbYBVQuQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 11:50:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752841AbYBVQtz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 11:49:55 -0500
Received: from mx1.redhat.com ([66.187.233.31]:59540 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751706AbYBVQtx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 11:49:53 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <200802220852.26584.chris.mason@oracle.com>
References: <200802220852.26584.chris.mason@oracle.com> <28196.1203605703@redhat.com> <20080220160557.4715.66608.stgit@warthog.procyon.org.uk> <17916.1203636833@redhat.com>
To: Chris Mason <chris.mason@oracle.com>
Cc: dhowells@redhat.com, Daniel Phillips <phillips@phunq.net>,
       Trond.Myklebust@netapp.com, chuck.lever@oracle.com,
       casey@schaufler-ca.com, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 00/37] Permit filesystem local caching
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Fri, 22 Feb 2008 16:47:27 +0000
Message-ID: <25210.1203698847@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Mason <chris.mason@oracle.com> wrote:

> Thanks for trying this, of course I'll ask you to try again with the latest 
> v0.13 code, it has a number of optimizations especially for CPU usage.

Here you go.  The numbers are very similar.

David

=================================
FEW BIG FILES TEST ON BTRFS v0.13
=================================

Completely cold caches:

	[root@andromeda ~]# time cat /warthog/bigfile >/dev/null
	real    0m2.202s
	user    0m0.000s
	sys     0m1.716s
	[root@andromeda ~]# time cat /warthog/biggerfile >/dev/null
	real    0m4.212s
	user    0m0.000s
	sys     0m0.896s

Warm BTRFS pagecache, cold NFS pagecache:

	[root@andromeda ~]# time cat /warthog/bigfile >/dev/null
	real    0m0.197s
	user    0m0.000s
	sys     0m0.192s
	[root@andromeda ~]# time cat /warthog/biggerfile >/dev/null
	real    0m0.376s
	user    0m0.000s
	sys     0m0.372s

Warm on-disk cache, cold pagecaches:

	[root@andromeda ~]# time cat /warthog/bigfile >/dev/null
	real    0m1.543s
	user    0m0.004s
	sys     0m1.448s
	[root@andromeda ~]# time cat /warthog/biggerfile >/dev/null
	real    0m3.111s
	user    0m0.000s
	sys     0m2.856s


==================================================
MANY SMALL/MEDIUM FILE READING TEST ON BTRFS v0.13
==================================================

Completely cold caches:

	[root@andromeda ~]# time tar cf - /warthog/aaa >/dev/zero
	real    0m31.575s
	user    0m0.176s
	sys     0m6.316s

Warm BTRFS pagecache, cold NFS pagecache:

	[root@andromeda ~]# time tar cf - /warthog/aaa >/dev/zero
	real    0m16.081s
	user    0m0.164s
	sys     0m5.528s

Warm on-disk cache, cold pagecaches:

	[root@andromeda ~]# time tar cf - /warthog/aaa >/dev/zero
	real    2m15.245s
	user    0m0.064s
	sys     0m2.808s

