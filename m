Return-Path: <linux-kernel-owner+w=401wt.eu-S1758086AbXLLQAT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758086AbXLLQAT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 11:00:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752635AbXLLQAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 11:00:05 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:18160 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550AbXLLQAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 11:00:04 -0500
In-Reply-To: <20071211222111.GF14204@stusta.de>
References: <20071211222111.GF14204@stusta.de>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <826FB063-41D0-4A43-9D61-8B21BEBD0CE2@oracle.com>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Chuck Lever <chuck.lever@oracle.com>
Subject: Re: [2.6 patch] fs/nfs/direct.c: remove dead code
Date: Wed, 12 Dec 2007 10:57:30 -0500
To: Adrian Bunk <bunk@kernel.org>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit b9148c6b should be reverted.  It was recently forward-ported  
from some years-old patches, and is clearly not needed now.

On Dec 11, 2007, at 5:21 PM, Adrian Bunk wrote:

> This code became dead after commit  
> b9148c6b80d802dbc2a7530b29915a80432e50c7
> (which BTW doesn't seem to have changed any behaviour) and can  
> therefore
> be removed.
>
> Spotted by the Coverity checker.
>
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
>
> ---
> --- linux-2.6/fs/nfs/direct.c.old	2007-12-02 21:54:53.000000000 +0100
> +++ linux-2.6/fs/nfs/direct.c	2007-12-02 21:55:10.000000000 +0100
> @@ -897,15 +897,12 @@ ssize_t nfs_file_direct_write(struct kio
>  	if (!count)
>  		goto out;	/* return 0 */
>
>  	retval = -EINVAL;
>  	if ((ssize_t) count < 0)
>  		goto out;
> -	retval = 0;
> -	if (!count)
> -		goto out;
>
>  	retval = nfs_sync_mapping(mapping);
>  	if (retval)
>  		goto out;
>
>  	retval = nfs_direct_write(iocb, iov, nr_segs, pos, count);
>

--
Chuck Lever
chuck[dot]lever[at]oracle[dot]com



