Return-Path: <linux-kernel-owner+w=401wt.eu-S1754888AbYHAI3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888AbYHAI3R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 04:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752051AbYHAI3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 04:29:05 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:65126 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbYHAI3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 04:29:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NKDXyz01wtt2jn43ILRy47qoVxMZGN+DLqMa4SngykVUFiDLLIr2qr1cwa3m4JnFtA
         54b14nF4/Ez50aUElSa88jqR+UmPrUyOwUexQPCsGCqubJYVogtXBHUDvhVr4SiJP64G
         f6lrPN6bhzLORr6wcedeEkdJFdELqy4zAeQMA=
Date: Fri, 1 Aug 2008 12:28:53 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-kernel@vger.kernel.org, Anton Vorontsov <cbou@mail.ru>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] power: support for Texas Instruments BQ27x00 battery
	managers.
Message-ID: <20080801082853.GA19224@zarina>
Reply-To: cbouatmailru@gmail.com
References: <1213794512-8245-1-git-send-email-giometti@linux.it> <20080619233411.GA27198@zarina> <20080620061345.GA9339@gundam.enneenne.com> <20080623063817.GA24051@zarina> <20080731210354.GW8465@enneenne.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20080731210354.GW8465@enneenne.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2008 at 11:03:54PM +0200, Rodolfo Giometti wrote:
> Sorry for the long delay... I was very busy in these days! :'(

No problem. ;-)

> On Mon, Jun 23, 2008 at 10:38:17AM +0400, Anton Vorontsov wrote:
> 
> > Here is the patch to show the idea. I only tested it to build, so no
> > guaranties that it will work on the actual hardware. :-)
> > 
> > This patch should be separated: one patch is for I2C subsystem
> > maintainer (drivers/i2c/* changes) and another (drivers/power/* +
> > include/linux/bq27x00.h) is for me.
> 
> On my system I need to specify 2 battery chips into the platform
> specific file as follow (file is arch/arm/mach-pxa/wr1100.c):
> 
> 	static struct i2c_board_info __initdata wr1100_i2c_mux_devices[] = {
> 	        {
> 	                I2C_BOARD_INFO("bq27200", 0x55),
> 	        },
> 	};
> 		
>         i2c_register_board_info(2, wr1100_i2c_mux_devices,
>                                         ARRAY_SIZE(wr1100_i2c_mux_devices));
>         i2c_register_board_info(3, wr1100_i2c_mux_devices,
>                                         ARRAY_SIZE(wr1100_i2c_mux_devices));
> 
> By using your solution I cannot use this code, is that right?

Why not? I think there should be no problem.

[...]
> if you agree, I prefere resend my
> patch without the #ifdef and the w1 support (since I cannot test it at
> all) but living the possibility to add that support later.

Yes, that would be also fine.

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
