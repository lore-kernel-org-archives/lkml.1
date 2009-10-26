Return-Path: <linux-kernel-owner+w=401wt.eu-S1754395AbZJZAyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395AbZJZAyo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 20:54:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752033AbZJZAyn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 20:54:43 -0400
Received: from mail.perches.com ([173.55.12.10]:1046 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751815AbZJZAyn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 20:54:43 -0400
Subject: Re: [PATCH 6/9] ser_gigaset: checkpatch cleanup
From: Joe Perches <joe@perches.com>
To: Tilman Schmidt <tilman@imap.cc>
Cc: David Miller <davem@davemloft.net>, Karsten Keil <isdn@linux-pingi.de>,
       Hansjoerg Lipp <hjlipp@web.de>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, isdn4linux@listserv.isdn4linux.de,
       i4ldeveloper@listserv.isdn4linux.de
In-Reply-To: <20091023-patch-gigaset-06.tilman@imap.cc>
References: <20091023-patch-gigaset-00.tilman@imap.cc>
	 <20091023-patch-gigaset-06.tilman@imap.cc>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 25 Oct 2009 17:54:46 -0700
Message-ID: <1256518486.14711.13.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-10-25 at 20:30 +0100, Tilman Schmidt wrote:
> Duly uglified as demanded by checkpatch.pl.
> diff --git a/drivers/isdn/gigaset/ser-gigaset.c b/drivers/isdn/gigaset/ser-gigaset.c
> index 3071a52..ac3409e 100644
> --- a/drivers/isdn/gigaset/ser-gigaset.c
> +++ b/drivers/isdn/gigaset/ser-gigaset.c
> @@ -164,9 +164,15 @@ static void gigaset_modem_fill(unsigned long data)
>  {
>  	struct cardstate *cs = (struct cardstate *) data;
>  	struct bc_state *bcs;
> +	struct sk_buff *nextskb;
>  	int sent = 0;
>  
> -	if (!cs || !(bcs = cs->bcs)) {
> +	if (!cs) {
> +		gig_dbg(DEBUG_OUTPUT, "%s: no cardstate", __func__);
> +		return;
> +	}
> +	bcs = cs->bcs;
> +	if (!bcs) {
>  		gig_dbg(DEBUG_OUTPUT, "%s: no cardstate", __func__);
>  		return;
>	}

perhaps:
	if (!cs || !cs->bcs) {
		gig_dbg(DEBUG_OUTPUT, "%s: no cardstate", __func__);
		return;
	}
	bcs = cs->bcs;

[]

> @@ -404,16 +412,20 @@ static void gigaset_device_release(struct device *dev)
>  static int gigaset_initcshw(struct cardstate *cs)
>  {
>  	int rc;
> +	struct ser_cardstate *scs;
>  
> -	if (!(cs->hw.ser = kzalloc(sizeof(struct ser_cardstate), GFP_KERNEL))) {
> +	scs = kzalloc(sizeof(struct ser_cardstate), GFP_KERNEL);
> +	if (!scs) {
>  		pr_err("out of memory\n");
>  		return 0;
>  	}
> +	cs->hw.ser = scs;

Why not no temporary and just:

	cs->hw.ser = kzalloc...
	if (!cs->hw.ser)


