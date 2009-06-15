Return-Path: <linux-kernel-owner+w=401wt.eu-S1752720AbZFOX3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720AbZFOX3S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 19:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751937AbZFOX3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 19:29:11 -0400
Received: from smtp103.sbc.mail.gq1.yahoo.com ([67.195.15.62]:40717 "HELO
	smtp103.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751426AbZFOX3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 19:29:10 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=d54YTQPVfQyCpQia9yQNcP4aFfarpEXzwTgcCwXfW0dwsgSbsQK7AI+qYn5Es9dP2SaPl++gO+Ywpa5p0gMKDOTISRCxd3DuQquAV0S1Gy9v042rx8F7DetIpla+dHlwHU1hgOEBtysN1sti+sjlWi91QM0R1yJqOhlhbixPQBY=  ;
X-Yahoo-SMTP: HIlLYKCswBDnjrunw3O.NnLyvismjGf1HBYfVTvuneM-
X-YMail-OSG: 4ki8vRsVM1mjVFaPyJ9Jpt.1FyjiZf7THh1Mi7I3zLgirM1wIrv9dARG6RKoQdV8bqV.ikjDMNc9ZY32l6YYIC86CuDA.iOQ.KDQAZ7Kd0ZMdUb64zqU5IAwm50bSGAP2eONNp3RaCNNlKV5RnM.SRKtf0ly3Gwmtsg7l98YMQwI3kqQb9kTMKW.2SiLC0NPf2Ky59wGYIq8aQXFmhc3Be0dMOeOFuGJqOVOOQ6eR1LJBbGKhgvkO1sZVrjowJH4apDwwc4EKiqatKH3gC4Cp6.trOYOyy17THwuxu8-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Baruch Siach <baruch@tkos.co.il>
Subject: Re: [PATCH v5] gpio: driver for PrimeCell PL061 GPIO controller
Date: Mon, 15 Jun 2009 16:29:11 -0700
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       "Russell King - ARM Linux" <linux@arm.linux.org.uk>
References: <1244708976-22122-1-git-send-email-baruch@tkos.co.il>
In-Reply-To: <1244708976-22122-1-git-send-email-baruch@tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200906151629.11350.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 June 2009, Baruch Siach wrote:
> +static unsigned int pl061_irq_startup(unsigned irq)
> +{
> +       if (gpio_request(irq_to_gpio(irq), "IRQ") == 0)
> +               pr_warning("%s: warning: GPIO%d has not been requested\n",
> +                               __func__, irq_to_gpio(irq));

No, that's the responsibility of whoever is setting this up.

Normally, platform setup code would request the GPIO since it's
being dedicated to some task on the board ... and then pass the
gpio_to_irq() value as a device resource, or maybe the GPIO itself
(if the driver had to deal with GPIOs per se).

Also, irq_to_gpio() can be problematic in some systems; avoid it.


> +
> +       pl061_irq_enable(irq);
> +
> +       return 0;
> +}

Remove that gpio_request(), and the irq_to_gpio(), and you get:

Acked-by: David Brownell <dbrownell@users.sourceforge.net>

The driver is a trifle unusual in having only eight bits per bank,
but that's just hardware.  Software looks clean, thanks.


