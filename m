Return-Path: <linux-kernel-owner+w=401wt.eu-S1755621AbZGNTEO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621AbZGNTEO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 15:04:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751522AbZGNTEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 15:04:13 -0400
Received: from mx2.netapp.com ([216.240.18.37]:17963 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332AbZGNTEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 15:04:12 -0400
X-IronPort-AV: E=Sophos;i="4.42,398,1243839600"; 
   d="scan'208";a="205629297"
Subject: Re: [PATCH][RFC] NFS: Propagate 'fsc' mount option through
 automounts
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: David Howells <dhowells@redhat.com>
Cc: steved@redhat.com, nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org
In-Reply-To: <6404.1247593654@redhat.com>
References: <1247161851.5766.44.camel@heimdal.trondhjem.org>
	 <1552.1247160463@redhat.com>  <6404.1247593654@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: NetApp
Date: Tue, 14 Jul 2009 15:03:20 -0400
Message-Id: <1247598200.6122.122.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
X-OriginalArrivalTime: 14 Jul 2009 19:04:12.0401 (UTC) FILETIME=[DFCFCE10:01CA04B5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-14 at 18:47 +0100, David Howells wrote:
> Trond Myklebust <Trond.Myklebust@netapp.com> wrote:
> 
> > Why not just use the mount path as the default uniquifier?
> 
> Because:
> 
>  (1) Which mount path?  You're now constructing the mount tree in its own
>      private namespace.

The natural thing would be to use the mount path that is required to
locate the super block's root dentry on the server (i.e. the mount path
for sb->s_root).
In the private namespace (since that reflects the namespace of the
server, and hence mnt->mnt_root == sb->s_root) this mount path will
always be the same as the contents of mnt->mnt_devname. 

(In the local namespace, however, sb->s_root != mnt->mnt_root, and so
mnt->mnt_devname is fixed up to reflect that difference. See
nfs_fix_devname()...)

>  (2) Due to the new VFS-pathwalk-based mount, the uniquifier is applied to the
>      root mount only, and if modified to inherit, would be applied to every
>      automount subordinate to that, rather than just the actual subject of the
>      mount.
>
>  (3) Due to the new VFS-pathwalk-based mount and the private namespace, the
>      default uniquifier for all instances of any particular mount is always
>      the same.

...and is that sufficient? If it is, then fine, let's leave it...

>  (4) If we work around some how the mounts now getting their mount path from
>      the private namespace, there are still real namespaces, chroots and
>      root-pivots to contend with.

Real namespaces, chroots and root-pivots are all changes to the client
only. They do not change the server's namespace, and hence the mount
path is invariant.

     Trond

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
