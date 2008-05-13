Return-Path: <linux-kernel-owner+w=401wt.eu-S1761679AbYEMVrv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761679AbYEMVrv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 17:47:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757946AbYEMVrm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 17:47:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37663 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757647AbYEMVrl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 17:47:41 -0400
Subject: Re: [PATCH] wireless, airo: waitbusy() won't delay
From: Dan Williams <dcbw@redhat.com>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: breed@users.sourceforge.net, linux-wireless@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <4829F62B.8030003@gmail.com>
References: <4829F62B.8030003@gmail.com>
Content-Type: text/plain
Date: Tue, 13 May 2008 17:43:13 -0400
Message-Id: <1210714993.987.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-05-13 at 22:12 +0200, Roel Kluin wrote:
> There will be no delay even when COMMAND_BUSY (defined 0x8000) is set:
> 0x8000 & (delay < 10000) will evaluate to 0 - when delay is 0.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

Good catch.

Acked-by: Dan Williams <dcbw@redhat.com>

> ---
> diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
> index 45f47c1..efb7444 100644
> --- a/drivers/net/wireless/airo.c
> +++ b/drivers/net/wireless/airo.c
> @@ -2904,7 +2904,7 @@ EXPORT_SYMBOL(init_airo_card);
>  
>  static int waitbusy (struct airo_info *ai) {
>  	int delay = 0;
> -	while ((IN4500 (ai, COMMAND) & COMMAND_BUSY) & (delay < 10000)) {
> +	while ((IN4500 (ai, COMMAND) & COMMAND_BUSY) && (delay < 10000)) {
>  		udelay (10);
>  		if ((++delay % 20) == 0)
>  			OUT4500(ai, EVACK, EV_CLEARCOMMANDBUSY);
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

