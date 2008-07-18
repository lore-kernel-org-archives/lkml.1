Return-Path: <linux-kernel-owner+w=401wt.eu-S1758610AbYGRTHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758610AbYGRTHd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 15:07:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754829AbYGRTH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 15:07:26 -0400
Received: from mail.fieldses.org ([66.93.2.214]:34743 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754557AbYGRTHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 15:07:25 -0400
Date: Fri, 18 Jul 2008 15:07:22 -0400
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Benny Halevy <bhalevy@panasas.com>
Subject: Re: [PATCH 2/2] nfs: nfs4xdr.c do-while is not a compound statement
Message-ID: <20080718190722.GA12007@fieldses.org>
References: <1216355584.6029.139.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216355584.6029.139.camel@brick>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, applied.--b.

On Thu, Jul 17, 2008 at 09:33:04PM -0700, Harvey Harrison wrote:
> The WRITEMEM macro produces sparse warnings of the form:
> fs/nfsd/nfs4xdr.c:2668:2: warning: do-while statement is not a compound statement
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
>  fs/nfsd/nfs4xdr.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
> index 9612d66..0957ec1 100644
> --- a/fs/nfsd/nfs4xdr.c
> +++ b/fs/nfsd/nfs4xdr.c
> @@ -1162,11 +1162,11 @@ nfsd4_decode_compound(struct nfsd4_compoundargs *argp)
>  	*p++ = htonl((u32)((n) >> 32));				\
>  	*p++ = htonl((u32)(n));					\
>  } while (0)
> -#define WRITEMEM(ptr,nbytes)     do if (nbytes > 0) {		\
> +#define WRITEMEM(ptr,nbytes)     do { if (nbytes > 0) {		\
>  	*(p + XDR_QUADLEN(nbytes) -1) = 0;                      \
>  	memcpy(p, ptr, nbytes);					\
>  	p += XDR_QUADLEN(nbytes);				\
> -} while (0)
> +}} while (0)
>  #define WRITECINFO(c)		do {				\
>  	*p++ = htonl(c.atomic);					\
>  	*p++ = htonl(c.before_ctime_sec);				\
> -- 
> 1.5.6.3.569.ga9185
> 
