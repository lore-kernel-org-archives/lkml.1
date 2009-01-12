Return-Path: <linux-kernel-owner+w=401wt.eu-S1753978AbZALMAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978AbZALMAh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 07:00:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752182AbZALMAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 07:00:24 -0500
Received: from aeryn.fluff.org.uk ([87.194.8.8]:53521 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751778AbZALMAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 07:00:22 -0500
Date: Mon, 12 Jan 2009 11:59:49 +0000
From: Ben Dooks <ben-linux@fluff.org>
To: Trilok Soni <soni.trilok@gmail.com>
Cc: dtor@mail.ru, David Brownell <david-b@pacbell.net>,
       linux-kernel@vger.kernel.org
Subject: Re: gpio_keys: request_irq with level triggered flags
Message-ID: <20090112115949.GP12431@fluff.org.uk>
References: <5d5443650901120338h5cfbb102k6459938d1a6f110@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d5443650901120338h5cfbb102k6459938d1a6f110@mail.gmail.com>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 05:08:44PM +0530, Trilok Soni wrote:
> Hi Dmitry,
> 
> >From the gpio_keys.c, I can see that request_irq is assuming all the
> gpio line interrupts to be edge triggered one, but what if we have
> level triggered interrupts? Doesn't this flags need to come from
> platform data hooks too? So, that we can specify either
> (IRQF_TRIGGER_RISING |  IRQF_TRIGGER_FALLING ) or (IRQF_TRIGGER_HIGH |
> IRQF_TRIGGER_LOW) based on the platform data?

If you are going to change to level triggered IRQs, any active IRQs
will have to be masked until the key is release, otherwise the IRQ
handler will keep being re-entered whilst the IRQ is active.

> 
> -- 
> ---Trilok Soni
> http://triloksoni.wordpress.com
> http://www.linkedin.com/in/triloksoni
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
