Return-Path: <linux-kernel-owner+w=401wt.eu-S934478AbZKYIuM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934478AbZKYIuM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 03:50:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934054AbZKYIuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 03:50:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51092 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933936AbZKYIuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 03:50:09 -0500
Date: Wed, 25 Nov 2009 09:50:06 +0100
From: Jan Kara <jack@suse.cz>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Steve French <sfrench@us.ibm.com>, Jeff Layton <jlayton@redhat.com>
Subject: Re: linux-next: manual merge of the ext3 tree with the cifs tree
Message-ID: <20091125085006.GB549@quack.suse.cz>
References: <20091125140626.2b71fb0a.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091125140626.2b71fb0a.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

On Wed 25-11-09 14:06:26, Stephen Rothwell wrote:
> Today's linux-next merge of the ext3 tree got a conflict in fs/cifs/dir.c
> between commit cea62343956c24452700c06cf028b72414c58a74 ("[CIFS]
> Duplicate data on appending to some Samba servers") from the cifs tree
> and commit 618903228b94b67a1d04634a83ea9cdb99c09e37 ("vfs: Implement
> proper O_SYNC semantics") from the ext3 tree.
  Thanks for notification and fixup.

> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.
  Looking at the code, I don't see an easy way of resolving this by changing
either mine or CIFS tree - I have other patches depending on this and this
patch depending on others and I assume it's similar with CIFS... So I guess
we'll have to live with this conflict.

								Honza


> diff --cc fs/cifs/dir.c
> index 1f42f77,f1fe5cb..0000000
> --- a/fs/cifs/dir.c
> +++ b/fs/cifs/dir.c
> @@@ -214,7 -214,10 +214,8 @@@ int cifs_posix_open(char *full_path, st
>   		posix_flags |= SMB_O_EXCL;
>   	if (oflags & O_TRUNC)
>   		posix_flags |= SMB_O_TRUNC;
> - 	if (oflags & O_SYNC)
>  -	if (oflags & O_APPEND)
>  -		posix_flags |= SMB_O_APPEND;
> + 	/* be safe and imply O_SYNC for O_DSYNC */
> + 	if (oflags & O_DSYNC)
>   		posix_flags |= SMB_O_SYNC;
>   	if (oflags & O_DIRECTORY)
>   		posix_flags |= SMB_O_DIRECTORY;
