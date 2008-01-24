Return-Path: <linux-kernel-owner+w=401wt.eu-S1759179AbYAXVIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759179AbYAXVIu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 16:08:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757456AbYAXVIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 16:08:39 -0500
Received: from mx2.netapp.com ([216.240.18.37]:63226 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754163AbYAXVIh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 16:08:37 -0500
X-IronPort-AV: E=Sophos;i="4.25,246,1199692800"; 
   d="scan'208";a="145820388"
Subject: Re: [PATCH 24/27] NFS: Use local caching [try #2]
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: David Howells <dhowells@redhat.com>
Cc: nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
In-Reply-To: <20080123172246.11107.62216.stgit@warthog.procyon.org.uk>
References: <20080123172038.11107.86025.stgit@warthog.procyon.org.uk>
	 <20080123172246.11107.62216.stgit@warthog.procyon.org.uk>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Network Appliance Inc
Date: Thu, 24 Jan 2008 16:08:34 -0500
Message-Id: <1201208914.7054.33.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
X-OriginalArrivalTime: 24 Jan 2008 21:08:36.0401 (UTC) FILETIME=[48E01210:01C85ECD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-01-23 at 17:22 +0000, David Howells wrote:
> The attached patch makes it possible for the NFS filesystem to make use of the
> network filesystem local caching service (FS-Cache).
> 
> To be able to use this, an updated mount program is required.  This can be
> obtained from:
> 
> 	http://people.redhat.com/steved/fscache/util-linux/
> 
> To mount an NFS filesystem to use caching, add an "fsc" option to the mount:
> 
> 	mount warthog:/ /a -o fsc

Nope. The new text-based mount code should just work. There should be no
need to also support cachefs via the legacy binary formant.

> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 
>  fs/nfs/Makefile           |    1 
>  fs/nfs/client.c           |    5 +
>  fs/nfs/file.c             |   37 ++++
>  fs/nfs/fscache-def.c      |  289 +++++++++++++++++++++++++++++++++
>  fs/nfs/fscache.c          |  391 +++++++++++++++++++++++++++++++++++++++++++++
>  fs/nfs/fscache.h          |  148 +++++++++++++++++
>  fs/nfs/inode.c            |   47 +++++
>  fs/nfs/read.c             |   28 +++
>  fs/nfs/super.c            |    3 
>  fs/nfs/sysctl.c           |    1 
>  include/linux/nfs_fs.h    |    9 +
>  include/linux/nfs_fs_sb.h |   18 ++
>  12 files changed, 968 insertions(+), 9 deletions(-)
>  create mode 100644 fs/nfs/fscache-def.c
>  create mode 100644 fs/nfs/fscache.c
>  create mode 100644 fs/nfs/fscache.h
> 

This needs to be split up.

Scheduling an fscache write, retrieving pages from fscache, managing
fscache cache consistency, adding statistics are all examples of
completely separate tasks that should not be bunched together in a
single megapatch, particularly not since they touch core NFS code.

Trond
