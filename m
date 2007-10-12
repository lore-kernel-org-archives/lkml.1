Return-Path: <linux-kernel-owner+w=401wt.eu-S1759547AbXJLQmo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759547AbXJLQmo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 12:42:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759677AbXJLQmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 12:42:17 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:2980 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758997AbXJLQmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 12:42:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=CL5qyTn5SybLCyvWMhuokWdqH4VnjnoYROcTopqTliUq/GyhX6p957fj6Ta3iNclsF+W+fGrqbsF543Bl23BCk/83ONY/8g7tU2xfFgAyqYXtYIEePfx7K8SXLQIIZFma7zaS4a5J1iMbqmjeuYpumGu6HdfEk/RF1OmPVJAzSg=
Date: Fri, 12 Oct 2007 18:41:31 +0200
To: Bryan Wu <bryan.wu@analog.com>
Cc: dmitry.torokhov@gmail.com, linux-input@atrey.karlin.mff.cuni.cz,
       linux-joystick@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH try #2] Input/Joystick Driver: add support AD7142 joystick driver
Message-ID: <20071012164131.GA12559@Ahmed>
References: <1192174727.6247.20.camel@roc-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1192174727.6247.20.camel@roc-laptop>
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2007 at 03:38:47PM +0800, Bryan Wu wrote:
>
> Signed-off-by: Bryan Wu <bryan.wu@analog.com>
> ---

Hi Bryan,

Why creating module's own kthread to call ad7142_decode and process keycodes 
instead of using a tasklet ?

Isn't disabling device interrupts from the begining of the ISR "ad7142_interrupt"
till the kthread "ad7142_thread" got waked-up and scheduled a long time,
espicially if there's a high load on the userspace side ?

Minor issues below.

> +
> +/* R    ADC stage 0 - 11 result (uncompensated) actually located in SRAM */
> +#define ADCRESULT_S0		0x0B
> +#define ADCRESULT_S1		0x0C
> +#define ADCRESULT_S2		0x0D
> +#define ADCRESULT_S3		0x0E
> +#define ADCRESULT_S4		0x0F
> +#define ADCRESULT_S5		0x10
> +#define ADCRESULT_S6		0x11
> +#define ADCRESULT_S7		0x12
> +#define ADCRESULT_S8		0x13
> +#define ADCRESULT_S9		0x14
> +#define ADCRESULT_S10		0x15
> +#define ADCRESULT_S11		0x16
> +

Keeping last two lines aligned with their above counterparts ?

> +static int
> +ad7142_probe(struct i2c_adapter *adap, int addr, int kind)
> +{
> +	struct i2c_client *client;
> +	int rc;
> +
> +	client = kmalloc(sizeof(struct i2c_client), GFP_KERNEL);
> +	if (!client)
> +		return -ENOMEM;
> +	memset(client, 0, sizeof(struct i2c_client));

kzalloc.

Regards,

-- 
Ahmed S. Darwish
HomePage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com
