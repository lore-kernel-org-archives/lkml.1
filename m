Return-Path: <linux-kernel-owner+w=401wt.eu-S932105AbZJ0TnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105AbZJ0TnZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 15:43:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753566AbZJ0TnY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 15:43:24 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:38922 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186AbZJ0TnX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 15:43:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mDkgk3W13sWhVSxxPfcja/ApgB7gQqp3HulKA9TI75sksV5HnSiSblLFgkHXs7WApq
         8bmK4j16ksDsqBljJk55vzzF+TsceL4LlJGAn8FU7yG7jhYhFpYBN5jQhQxKCNSTu+II
         O7IQ6BS/TVctzDvEllJ2CMMTcrYd29oWNPvcw=
MIME-Version: 1.0
In-Reply-To: <a3b1332815576dc4d496937b8a5ab69d36818d00.1256314995.git.nicolas.ferre@atmel.com>
References: <acfa557032a93e2d3186981b16f7048a5a31028a.1256314995.git.nicolas.ferre@atmel.com>
	 <20090930155557.7dae503b@hskinnemoen-d830>
	 <a3b1332815576dc4d496937b8a5ab69d36818d00.1256314995.git.nicolas.ferre@atmel.com>
Date: Tue, 27 Oct 2009 21:43:26 +0200
Message-ID: <cd73a99e0910271243x744c956bl598fef9fd4144840@mail.gmail.com>
Subject: Re: [PATCH 3/3 v2] at91/atmel-mci: inclusion of sd/mmc driver in 
	at91sam9g45 chip and board
From: Andrew Victor <avictor.za@gmail.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-mmc@vger.kernel.org, haavard.skinnemoen@atmel.com,
       akpm@linux-foundation.org, kernel@avr32linux.org,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Nicolas,

> +       if (data->slot[0].wp_pin)
> +               at91_set_gpio_input(data->slot[0].wp_pin, 1);

> +static struct mci_platform_data __initdata mci0_data = {
> +       .slot[0] = {
> +               .bus_width      = 4,
> +               .detect_pin     = AT91_PIN_PD10,
> +               .wp_pin         = -1,
> +       },

Causes at91_set_gpio_input() to be called for pin -1.  Which shouldn't be valid.
AT91 platforms use 0 to indicate an un-connected GPIO pin, so the
assignment of "wp_pin" should probably just be removed.


Regards,
  Andrew Victor
