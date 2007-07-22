Return-Path: <linux-kernel-owner+w=401wt.eu-S1761385AbXGVPwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761385AbXGVPwp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 11:52:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754844AbXGVPwh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 11:52:37 -0400
Received: from mx2.netapp.com ([216.240.18.37]:58020 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754562AbXGVPwh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 11:52:37 -0400
X-IronPort-AV: E=Sophos;i="4.16,569,1175497200"; 
   d="scan'208";a="84763932"
Subject: Re: [PATCH] fix broken handling of port=... in NFS option parsing
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Chuck Lever <chuck.lever@oracle.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20070722095906.GX21668@ftp.linux.org.uk>
References: <20070722095906.GX21668@ftp.linux.org.uk>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Network Appliance Inc
Date: Sun, 22 Jul 2007 11:52:34 -0400
Message-Id: <1185119554.6577.2.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 22 Jul 2007 15:52:34.0844 (UTC) FILETIME=[521295C0:01C7CC78]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-07-22 at 10:59 +0100, Al Viro wrote:
> 	Obviously broken on little-endian; fortunately, the option is
> not frequently used...
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
> diff --git a/fs/nfs/super.c b/fs/nfs/super.c
> index b34b7a7..b2a851c 100644
> --- a/fs/nfs/super.c
> +++ b/fs/nfs/super.c
> @@ -732,7 +732,7 @@ static int nfs_parse_mount_options(char *raw,
>  				return 0;
>  			if (option < 0 || option > 65535)
>  				return 0;
> -			mnt->nfs_server.address.sin_port = htonl(option);
> +			mnt->nfs_server.address.sin_port = htons(option);
>  			break;
>  		case Opt_rsize:
>  			if (match_int(args, &mnt->rsize))

ACK. Thanks Al!

   Trond
