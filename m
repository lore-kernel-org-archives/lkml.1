Return-Path: <linux-kernel-owner+w=401wt.eu-S1751526AbZHXE7P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751526AbZHXE7P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 00:59:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751492AbZHXE7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 00:59:12 -0400
Received: from tundra.namei.org ([65.99.196.166]:36651 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751500AbZHXE7L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 00:59:11 -0400
Date: Mon, 24 Aug 2009 14:57:57 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
       Roland Kletzing <devzero@web.de>,
       "<David Safford" <safford@watson.ibm.com>, stable@kernel.org,
       Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH 2/2] ima: hashing large files bug fix
In-Reply-To: <3fa4204e315c0bc33ae378d4f01a53eab2e5e4bc.1250871856.git.zohar@linux.vnet.ibm.com>
Message-ID: <alpine.LRH.2.00.0908241456390.22597@tundra.namei.org>
References: <df9691ba169503565c2e3b71c593f9c43a6b3eb2.1250871856.git.zohar@linux.vnet.ibm.com> <3fa4204e315c0bc33ae378d4f01a53eab2e5e4bc.1250871856.git.zohar@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Aug 2009, Mimi Zohar wrote:

> Hashing files larger than INT_MAX causes process to loop.
> Dependent on redefining kernel_read() offset type to loff_t.
> 
> (http://bugzilla.kernel.org/show_bug.cgi?id=13909)
> 
> Cc: stable@kernel.org
> Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
> ---
>  security/integrity/ima/ima_crypto.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)

These look correct to me (I'll also push them to Linus via git).

Reviewed-by: James Morris <jmorris@namei.org>

> 
> diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
> index 63003a6..46642a1 100644
> --- a/security/integrity/ima/ima_crypto.c
> +++ b/security/integrity/ima/ima_crypto.c
> @@ -45,9 +45,9 @@ int ima_calc_hash(struct file *file, char *digest)
>  {
>  	struct hash_desc desc;
>  	struct scatterlist sg[1];
> -	loff_t i_size;
> +	loff_t i_size, offset = 0;
>  	char *rbuf;
> -	int rc, offset = 0;
> +	int rc;
>  
>  	rc = init_desc(&desc);
>  	if (rc != 0)
> @@ -67,6 +67,8 @@ int ima_calc_hash(struct file *file, char *digest)
>  			rc = rbuf_len;
>  			break;
>  		}
> +		if (rbuf_len == 0)
> +			break;
>  		offset += rbuf_len;
>  		sg_init_one(sg, rbuf, rbuf_len);
>  
> -- 
> 1.6.0.6
> 

-- 
James Morris
<jmorris@namei.org>
