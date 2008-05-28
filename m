Return-Path: <linux-kernel-owner+w=401wt.eu-S1752724AbYE1IRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724AbYE1IRY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 04:17:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751123AbYE1IRL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 04:17:11 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:38703 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831AbYE1IRJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 04:17:09 -0400
Date: Wed, 28 May 2008 10:14:25 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: David Brownell <david-b@pacbell.net>
Cc: Ben Nizette <bn@niasdigital.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, kernel@avr32linux.org
Subject: Re: Latest gpio gumph
Message-ID: <20080528101425.611e0145@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <200805272144.33334.david-b@pacbell.net>
References: <1211942475.27810.37.camel@moss.renham>
	<200805272144.33334.david-b@pacbell.net>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 May 2008 08:14:16.0136 (UTC) FILETIME=[D208FC80:01C8C09A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell <david-b@pacbell.net> wrote:
>   - an avr32 patch, appended (no response on the avr32 list)

Sorry about the lack of response.

I'm not all that enthusiastic about this patch though...

> From: David Brownell <dbrownell@users.sourceforge.net>
> Subject: AVR32: minor GPIO handling updates
> 
>  * gpio_direction_output() should disable the pullups just like
>    at32_select_gpio(... AT32_GPIOF_OUTPUT) does, for consistency
>    between those alternative initialization paths.

But then we need to keep track of whether pullups used to be enabled so
that we can re-enable it in gpio_direction_input(), don't we?

I can't see the harm of keeping the pullup enabled while the port is
configured as output. For consistency, I'd rather honor the pullup flag
in at32_select_gpio() regardless of AT32_GPIOF_OUTPUT.

>  * On the odd chance some code uses a pin as a GPIO IRQ without
>    calling gpio_request() or gpio_direction_input(), the debug
>    dump should still show its pin status.

Hmm. I guess that makes sense, though I would be lying if I said I care
all that much. I think gpiolib is going pretty far to accommodate buggy
drivers that don't call gpio_request() as it is.

Haavard
