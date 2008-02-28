Return-Path: <linux-kernel-owner+w=401wt.eu-S1758559AbYB1ENo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758559AbYB1ENo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 23:13:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755943AbYB1ENd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 23:13:33 -0500
Received: from namei.org ([69.55.235.186]:53343 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751978AbYB1ENd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 23:13:33 -0500
Date: Thu, 28 Feb 2008 15:13:07 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: "David P. Quigley" <dpquigl@tycho.nsa.gov>
cc: hch@infradead.org, viro@ftp.linux.org.uk, trond.myklebust@fys.uio.no,
       bfields@fieldses.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 08/11] NFS: Introduce lifecycle management for label
 attribute.
In-Reply-To: <1204150294-4678-9-git-send-email-dpquigl@tycho.nsa.gov>
Message-ID: <Xine.LNX.4.64.0802281451380.7262@us.intercode.com.au>
References: <1204150294-4678-1-git-send-email-dpquigl@tycho.nsa.gov>
 <1204150294-4678-9-git-send-email-dpquigl@tycho.nsa.gov>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Feb 2008, David P. Quigley wrote:

> +#ifdef CONFIG_NFS_V4_SECURITY_LABEL
> +	if (nfs_server_capable(dir, NFS_CAP_SECURITY_LABEL))
> +		nfs_fattr_alloc(&fattr, GFP_NOWAIT);
> +#endif

There are at least ten instances of the above.  (Why do some of them use 
GFP_NOWAIT ?)

> +#ifdef CONFIG_NFS_V4_SECURITY_LABEL
> +	if (server->caps & NFS_CAP_SECURITY_LABEL) {
> +		nfs_fattr_alloc(&fattr, GFP_KERNEL);
> +		nfs_fattr_alloc(&dir_fattr, GFP_KERNEL);
> +	}

And a few of these.

Static inline them, please.

> +#define	nfs_fattr_alloc(fattr, flags)
> +#define	nfs_fattr_fini(fattr)

The preferred way to do this in Linux is as a static inline.


- James
-- 
James Morris
<jmorris@namei.org>
