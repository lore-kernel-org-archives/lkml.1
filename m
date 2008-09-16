Return-Path: <linux-kernel-owner+w=401wt.eu-S1754039AbYIPKog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039AbYIPKog (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 06:44:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752350AbYIPKo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 06:44:28 -0400
Received: from h155.mvista.com ([63.81.120.155]:16190 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752228AbYIPKo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 06:44:28 -0400
Message-ID: <48CF8E05.6050000@ru.mvista.com>
Date: Tue, 16 Sep 2008 14:44:21 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: roel kluin <roel.kluin@gmail.com>
Cc: ralf@linux-mips.org, yoichi_yuasa@tripeaks.co.jp,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [MIPS] vr41xx: unsigned irq cannot be negative
References: <48CF02EE.8050406@gmail.com>
In-Reply-To: <48CF02EE.8050406@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

roel kluin wrote:

> unsigned irq cannot be negative
>
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> diff --git a/arch/mips/vr41xx/common/irq.c b/arch/mips/vr41xx/common/irq.c
> index cba36a2..92dd1a0 100644
> --- a/arch/mips/vr41xx/common/irq.c
> +++ b/arch/mips/vr41xx/common/irq.c
> @@ -72,6 +72,7 @@ static void irq_dispatch(unsigned int irq)
>  	cascade = irq_cascade + irq;
>  	if (cascade->get_irq != NULL) {
>  		unsigned int source_irq = irq;
> +		int ret;
>   

   Keep an empty line after the declaration block please.

> @@ -79,8 +80,9 @@ static void irq_dispatch(unsigned int irq)
>  			desc->chip->mask(source_irq);
>  			desc->chip->ack(source_irq);
>  		}
> -		irq = cascade->get_irq(irq);
> -		if (irq < 0)
> +		ret = cascade->get_irq(irq);
> +		irq = ret;
> +		if (ret < 0)
>  			atomic_inc(&irq_err_count);
>  		else
>  			irq_dispatch(irq);
>   

  How about this:

		ret = cascade->get_irq(irq);
		if (ret < 0)
 			atomic_inc(&irq_err_count);
 		else
 			irq_dispatch(ret);


WBR, Sergei


