Return-Path: <linux-kernel-owner+w=401wt.eu-S1753617AbYL3XAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753617AbYL3XAf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 18:00:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752032AbYL3XAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 18:00:24 -0500
Received: from mx2.netapp.com ([216.240.18.37]:55648 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751754AbYL3XAX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 18:00:23 -0500
X-IronPort-AV: E=Sophos;i="4.36,304,1228118400"; 
   d="scan'208";a="105962711"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Pull request for FS-Cache, including NFS patches
Date: Tue, 30 Dec 2008 15:00:02 -0800
Message-ID: <7A24DF798E223B4C9864E8F92E8C93EC01AAFE6E@SACMVEXC1-PRD.hq.netapp.com>
In-Reply-To: <1230676568.11508.21.camel@heimdal.trondhjem.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Pull request for FS-Cache, including NFS patches
Thread-Index: AclqzwfTeNOSDC37SE6pkVH9tI/Y/wAAwS7g
From: "Muntz, Daniel" <Dan.Muntz@netapp.com>
To: "Trond Myklebust" <trond.myklebust@fys.uio.no>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Stephen Rothwell" <sfr@canb.auug.org.au>,
       "Bernd Schubert" <bernd.schubert@fastmail.fm>, <nfsv4@linux-nfs.org>,
       <linux-kernel@vger.kernel.org>, <steved@redhat.com>,
       <dhowells@redhat.com>, <linux-next@vger.kernel.org>,
       <linux-fsdevel@vger.kernel.org>, <rwheeler@redhat.com>
X-OriginalArrivalTime: 30 Dec 2008 23:00:04.0741 (UTC) FILETIME=[5A4C8350:01C96AD2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, and if you have a single user on the machine at a time (with cache
flushed inbetween, kernel refreshed), root can read /dev/kmem, swap,
intercept traffic and read cachefs data to its heart's content--hence,
those requirements.

  -Dan

-----Original Message-----
From: Trond Myklebust [mailto:trond.myklebust@fys.uio.no] 
Sent: Tuesday, December 30, 2008 2:36 PM
To: Muntz, Daniel
Cc: Andrew Morton; Stephen Rothwell; Bernd Schubert;
nfsv4@linux-nfs.org; linux-kernel@vger.kernel.org; steved@redhat.com;
dhowells@redhat.com; linux-next@vger.kernel.org;
linux-fsdevel@vger.kernel.org; rwheeler@redhat.com
Subject: RE: Pull request for FS-Cache, including NFS patches

On Tue, 2008-12-30 at 14:15 -0800, Muntz, Daniel wrote:
> >> As for security, look at what MIT had to do to prevent local disk 
> >> caching from breaking the security guarantees of AFS.
> >
> >See what David has added to the LSM code to provide the same 
> >guarantees
> for cachefs...
> >
> >Trond
> 
> Unless it (at least) leverages TPM, the issues I had in mind can't 
> really be addressed in code.  One requirement is to prevent a local 
> root user from accessing fs information without appropriate
permissions.
> This leads to unwieldly requirements such as allowing only one user on

> a machine at a time, blowing away the cache on logout, validating 
> (e.g.,
> refreshing) the kernel on each boot, etc.  Sure, some applications 
> won't care, but you're also potentially opening holes that users may 
> not consider.

You can't prevent a local root user from accessing cached data: that's
true with or without cachefs. root can typically access the data using
/dev/kmem, swap, intercepting tty traffic, spoofing user creds,...
If root can't be trusted, then find another machine.

The worry is rather that privileged daemons may be tricked into
revealing said data to unprivileged users, or that unprivileged users
may attempt to read data from files to which they have no rights using
the cachefs itself. That is a problem that is addressable by means of
LSM, and is what David has attempted to solve.

  Trond

