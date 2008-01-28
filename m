Return-Path: <linux-kernel-owner+w=401wt.eu-S1757433AbYA1Wa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433AbYA1Wa0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 17:30:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752534AbYA1WaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 17:30:12 -0500
Received: from mail.hauppauge.com ([167.206.143.4]:4473 "EHLO
	mail.hauppauge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684AbYA1WaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 17:30:10 -0500
X-Greylist: delayed 926 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Jan 2008 17:30:06 EST
Message-ID: <479E53B8.6030505@linuxtv.org>
From: mkrufky@linuxtv.org
To: bunk@kernel.org
Cc: mchehab@infradead.org, v4l-dvb-maintainer@linuxtv.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] dvb/frontends/tda18271-common.c: fix off-by-one
Date: Mon, 28 Jan 2008 17:14:16 -0500
MIME-Version: 1.0
X-Mailer: Internet Mail Service (5.5.2657.72)
in-reply-to: <20080128221241.GG8767@does.not.exist>
x-originalarrivaltime: 28 Jan 2008 22:08:28.0397 (UTC) FILETIME=[4F8629D0:01C861FA]
user-agent: Thunderbird 2.0.0.9 (Windows/20071031)
Content-Type: text/plain;
	charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> This patch fixes an off-by-one error spotted by the Coverity checker.
>
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
>   
Reviewed-by: Michael Krufky <mkrufky@linuxtv.org>

Thank you, Adrian.

Mauro, please merge this and queue for upstream.

Cheers,

Mike


> ---
> --- linux-2.6/drivers/media/dvb/frontends/tda18271-common.c.old
2008-01-28 16:27:55.000000000 +0200
> +++ linux-2.6/drivers/media/dvb/frontends/tda18271-common.c	2008-01-28
16:28:38.000000000 +0200
> @@ -166,17 +166,17 @@ int tda18271_read_extended(struct dvb_fr
>  	/* read all registers */
>  	ret = i2c_transfer(priv->i2c_adap, msg, 2);
>  
>  	tda18271_i2c_gate_ctrl(fe, 0);
>  
>  	if (ret != 2)
>  		tda_err("ERROR: i2c_transfer returned: %d\n", ret);
>  
> -	for (i = 0; i <= TDA18271_NUM_REGS; i++) {
> +	for (i = 0; i < TDA18271_NUM_REGS; i++) {
>  		/* don't update write-only registers */
>  		if ((i != R_EB9)  &&
>  		    (i != R_EB16) &&
>  		    (i != R_EB17) &&
>  		    (i != R_EB19) &&
>  		    (i != R_EB20))
>  		regs[i] = regdump[i];
>  	}
>
>   

