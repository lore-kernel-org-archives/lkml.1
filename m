Return-Path: <linux-kernel-owner+w=401wt.eu-S935835AbZLPWkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935835AbZLPWkf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 17:40:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934361AbZLPWkb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 17:40:31 -0500
Received: from mail-out1.uio.no ([129.240.10.57]:50310 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935165AbZLPWka (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 17:40:30 -0500
Subject: Re: [PATCH -next] nfs: fix ISO C90 warning
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-nfs@vger.kernel.org
In-Reply-To: <20091216142334.6a0ba115.randy.dunlap@oracle.com>
References: <20091215165309.58e98eea.sfr@canb.auug.org.au>
	 <20091216142334.6a0ba115.randy.dunlap@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Dec 2009 17:40:19 -0500
Message-Id: <1261003219.13878.6.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 5 msgs/h 1 sum rcpts/h 7 sum msgs/h 1 total rcpts 2060 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 979212F0FBAB6397314FECFE88D9E86093EA063D
X-UiO-SPAM-Test: remote_host: 68.40.206.115 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 48 max/h 3 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-16 at 14:23 -0800, Randy Dunlap wrote: 
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix gcc ISO C90 warning:
> 
> fs/nfs/callback.c:356: warning: ISO C90 forbids mixed declarations and code
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  fs/nfs/callback.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-next-20091215.orig/fs/nfs/callback.c
> +++ linux-next-20091215/fs/nfs/callback.c
> @@ -352,8 +352,8 @@ static int check_gss_callback_principal(
>  static int nfs_callback_authenticate(struct svc_rqst *rqstp)
>  {
>  	struct nfs_client *clp;
> -	RPC_IFDEBUG(char buf[RPC_MAX_ADDRBUFLEN]);
>  	int ret = SVC_OK;
> +	RPC_IFDEBUG(char buf[RPC_MAX_ADDRBUFLEN]);
>  

What version of gcc is giving rise to this warning?

RPC_IFDEBUG is a macro that either evaluates to its argument, or to
nothing, depending on whether or not RPC_DEBUG is defined or not. In
neither case should it evaluate to anything illegal under C90 rules
afaics.

Trond

