Return-Path: <linux-kernel-owner+w=401wt.eu-S1758956AbZIGGWH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758956AbZIGGWH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 02:22:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758897AbZIGGWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 02:22:06 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:17361 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753322AbZIGGWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 02:22:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=d0gK+loezf24e/Uv0xl0doCXLEGZGQTp2d2ZM0AmQypADnHbLpmnpGOIga1Fugy10z
         rtH1FfwBwHFAaDlTqO7tdHgrppIuHgmJGMxdjV5yzRnbYSKFHmOm4YRvJ/9Fy62ze397
         jxrSKx9zr98jee0gx6Jagt708CDkQhswPeoC4=
MIME-Version: 1.0
In-Reply-To: <20090727151900.GB4052@pc-ras4041.res.insa>
References: <1246352745-31323-1-git-send-email-albin.tonnerre@free-electrons.com>
	 <20090727162312.35c2f9d4@hskinnemoen-d830>
	 <20090727151900.GB4052@pc-ras4041.res.insa>
Date: Mon, 7 Sep 2009 08:22:06 +0200
Message-ID: <cd73a99e0909062322j683952e6m803dd6b703bf758d@mail.gmail.com>
Subject: Re: [PATCH] Add poll_get_char and poll_put_char uart_ops to 
	atmel_serial.
From: Andrew Victor <avictor.za@gmail.com>
To: Albin Tonnerre <albin.tonnerre@free-electrons.com>
Cc: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Albin,

Any reason you're not using the register access macro's like the rest
of the driver?

> +       while (!(__raw_readl(aup->uart.membase + ATMEL_US_CSR) & ATMEL_US_RXRDY))

while (!(UART_GET_CSR(..) & ATMEL_US_RXRDY))

> +       return __raw_readl(aup->uart.membase + ATMEL_US_RHR);

return UART_GET_CHAR(..);

> +       __raw_writel(ch, aup->uart.membase + ATMEL_US_THR);

UART_PUT_CHAR(..., ch);


Otherwise the patch looks fine to me.

Regards,
  Andrew Victor
