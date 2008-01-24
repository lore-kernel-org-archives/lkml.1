Return-Path: <linux-kernel-owner+w=401wt.eu-S1757154AbYAXVQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757154AbYAXVQA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 16:16:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759263AbYAXVPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 16:15:38 -0500
Received: from mx2.netapp.com ([216.240.18.37]:3369 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757463AbYAXVPf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 16:15:35 -0500
X-IronPort-AV: E=Sophos;i="4.25,246,1199692800"; 
   d="scan'208";a="145822797"
Subject: Re: [PATCH 23/27] NFS: Fix memory leak [try #2]
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: David Howells <dhowells@redhat.com>
Cc: nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
In-Reply-To: <20080123172241.11107.75955.stgit@warthog.procyon.org.uk>
References: <20080123172038.11107.86025.stgit@warthog.procyon.org.uk>
	 <20080123172241.11107.75955.stgit@warthog.procyon.org.uk>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Network Appliance Inc
Date: Thu, 24 Jan 2008 16:15:29 -0500
Message-Id: <1201209329.7054.41.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
X-OriginalArrivalTime: 24 Jan 2008 21:15:30.0290 (UTC) FILETIME=[3F928520:01C85ECE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-01-23 at 17:22 +0000, David Howells wrote:
> Fix a memory leak whereby multiple clientaddr=xxx mount options just overwrite
> the duplicated client_address option pointer, without freeing the old memory.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 
>  fs/nfs/super.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> 
> diff --git a/fs/nfs/super.c b/fs/nfs/super.c
> index 0b0c72a..7f5e747 100644
> --- a/fs/nfs/super.c
> +++ b/fs/nfs/super.c
> @@ -936,6 +936,7 @@ static int nfs_parse_mount_options(char *raw,
>  			string = match_strdup(args);
>  			if (string == NULL)
>  				goto out_nomem;
> +			kfree(mnt->client_address);
>  			mnt->client_address = string;
>  			break;
>  		case Opt_mountaddr:

Thanks. This fix has already been applied to the NFS git tree.
