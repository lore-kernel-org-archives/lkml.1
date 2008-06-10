Return-Path: <linux-kernel-owner+w=401wt.eu-S1754083AbYFJK57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083AbYFJK57 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 06:57:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751314AbYFJK5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 06:57:49 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:23192 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbYFJK5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 06:57:49 -0400
Date: Tue, 10 Jun 2008 12:57:37 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Uli Luckas <u.luckas@road.de>
Cc: LKML <linux-kernel@vger.kernel.org>, adaplas@gmail.com,
       Linux I2C <i2c@lm-sensors.org>, Ryan Mallon <ryan@bluewatersys.com>,
       David Brownell <david-b@pacbell.net>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Eric Miao <eric.y.miao@gmail.com>
Subject: Re: Frame buffers and early i2c
Message-ID: <20080610125737.0622da44@hyperion.delvare>
In-Reply-To: <200806101131.19763.u.luckas@road.de>
References: <200806091647.42757.u.luckas@road.de>
	<200806092359.36080.u.luckas@road.de>
	<20080610082527.0e6d643a@hyperion.delvare>
	<200806101131.19763.u.luckas@road.de>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2008 11:31:19 +0200, Uli Luckas wrote:
> On Tuesday, 10. June 2008, Jean Delvare wrote:
> > So you prefer to post to one random list than the two lists where your
> > target audience is? Interesting approach. If you really don't want to
> > post to two lists at once, just send two separate posts?
> >
> And have two seperate threads of communication??? lfml is where they all are 
> and avery maintainer has different preferences. Anyway, I got your point and 
> will come to the i2c list in the future if you prefere.

If you believe that every kernel developer reads LKML, you're seriously
mistaken. We have a hundred of dedicated mailing lists for a reason. I
would have missed your post if you hadn't Cc'd directly.

> Just changing the initcall to subsys really did the trick. I thought, this was 
> the first thing I tried and I thought it crashed my device. But obviousely I 
> had some other problem.
> If Russell gives his Ack, could this be pushed upstream through i2c?
> (...)
> Initialize the pxa i2c bus during subsystem initialization to make it
> available during driver initialization (e.g. display powerup for pxafb).
> 
> Signed-off-by: Uli Luckas <u.luckas@road.de>
> ---
>  drivers/i2c/busses/i2c-pxa.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-pxa.c b/drivers/i2c/busses/i2c-pxa.c
> index eb69fba..78c0fc4 100644
> --- a/drivers/i2c/busses/i2c-pxa.c
> +++ b/drivers/i2c/busses/i2c-pxa.c
> @@ -1134,5 +1134,5 @@ static void __exit i2c_adap_pxa_exit(void)
>  MODULE_LICENSE("GPL");
>  MODULE_ALIAS("platform:pxa2xx-i2c");
>  
> -module_init(i2c_adap_pxa_init);
> +subsys_initcall(i2c_adap_pxa_init);
>  module_exit(i2c_adap_pxa_exit);

That's fine with me.

-- 
Jean Delvare
