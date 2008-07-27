Return-Path: <linux-kernel-owner+w=401wt.eu-S1758496AbYG0QlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758496AbYG0QlQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 12:41:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755730AbYG0QlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 12:41:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40199 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752611AbYG0QlC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 12:41:02 -0400
Date: Sun, 27 Jul 2008 18:40:57 +0200
From: Karsten Keil <kkeil@suse.de>
To: Adrian Bunk <bunk@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] release_tei namespace fix
Message-ID: <20080727164057.GB13004@pingi.kke.suse.de>
References: <20080727154926.GN9301@cs181140183.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080727154926.GN9301@cs181140183.pp.htv.fi>
Organization: SuSE Linux AG
X-Operating-System: Linux 2.6.16.54-0.2.5-smp x86_64
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 27, 2008 at 06:49:26PM +0300, Adrian Bunk wrote:
> This patch fixes the following build error caused by
> commit 1b2b03f8e514e4f68e293846ba511a948b80243c
> (Add mISDN core files):
> 
> <--  snip  -->
> 
> ...
>   LD      drivers/isdn/built-in.o
> drivers/isdn/hisax/built-in.o: In function `release_tei':
> (.text+0x21ce): multiple definition of `release_tei'
> drivers/isdn/mISDN/built-in.o:(.text+0x7c39): first defined here
> make[3]: *** [drivers/isdn/built-in.o] Error 1
> 
> <--  snip  -->
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> 
>  drivers/isdn/mISDN/layer2.c |    2 +-
>  drivers/isdn/mISDN/layer2.h |    2 +-
>  drivers/isdn/mISDN/tei.c    |    2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
> 
> bc16cf6ec9d5c2fd14043184c3babb8ebbd7ed87 
> diff --git a/drivers/isdn/mISDN/layer2.c b/drivers/isdn/mISDN/layer2.c
> index f5ad888..10396a5 100644
> --- a/drivers/isdn/mISDN/layer2.c
> +++ b/drivers/isdn/mISDN/layer2.c
> @@ -2030,7 +2030,7 @@ release_l2(struct layer2 *l2)
>  	skb_queue_purge(&l2->down_queue);
>  	ReleaseWin(l2);
>  	if (test_bit(FLG_LAPD, &l2->flag)) {
> -		release_tei(l2);
> +		release_l2_tei(l2);
>  		if (l2->ch.st)
>  			l2->ch.st->dev->D.ctrl(&l2->ch.st->dev->D,
>  			    CLOSE_CHANNEL, NULL);
> diff --git a/drivers/isdn/mISDN/layer2.h b/drivers/isdn/mISDN/layer2.h
> index de2dd02..90f6436 100644
> --- a/drivers/isdn/mISDN/layer2.h
> +++ b/drivers/isdn/mISDN/layer2.h
> @@ -96,7 +96,7 @@ extern int		tei_l2(struct layer2 *, u_int, u_long arg);
>  
>  /* from tei.c */
>  extern int 		l2_tei(struct layer2 *, u_int, u_long arg);
> -extern void 		release_tei(struct layer2 *);
> +extern void 		release_l2_tei(struct layer2 *);
>  extern int 		TEIInit(u_int *);
>  extern void 		TEIFree(void);
>  
> diff --git a/drivers/isdn/mISDN/tei.c b/drivers/isdn/mISDN/tei.c
> index 56a76a0..9d0066f 100644
> --- a/drivers/isdn/mISDN/tei.c
> +++ b/drivers/isdn/mISDN/tei.c
> @@ -945,7 +945,7 @@ l2_tei(struct layer2 *l2, u_int cmd, u_long arg)
>  }
>  
>  void
> -release_tei(struct layer2 *l2)
> +release_l2_tei(struct layer2 *l2)
>  {
>  	struct teimgr	*tm = l2->tm;
>  	u_long		flags;


I already had a fix for this, it's now ready for pulling from
git://git./linux/kernel/git/kkeil/ISDN-2.6 master 

-- 
Karsten Keil
SuSE Labs
ISDN and VOIP development
SUSE LINUX Products GmbH, Maxfeldstr.5 90409 Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
