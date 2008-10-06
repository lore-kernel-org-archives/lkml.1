Return-Path: <linux-kernel-owner+w=401wt.eu-S1755178AbYJGNHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178AbYJGNHr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 09:07:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753929AbYJGNGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 09:06:51 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:34072 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753726AbYJGNGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 09:06:50 -0400
Date: Mon, 6 Oct 2008 17:10:03 +0200
From: Pavel Machek <pavel@suse.cz>
To: David Brownell <david-b@pacbell.net>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Victor <linux@maxim.org.za>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH/RFC] hardware irq debouncing support
Message-ID: <20081006151003.GB1380@ucw.cz>
References: <200809241251.32606.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809241251.32606.david-b@pacbell.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-09-24 12:51:32, David Brownell wrote:
> Hardware IRQ debouncing is common for IRQ controllers which are
> part of GPIO modules ... they often deal with mechanical switches,
> buttons, and so forth.  This patch:
> 
>  - Provides simple support for that in genirq
> 
>  - Includes sample implementations for some Linux systems
>    which already include non-generic support for this:
> 
>      * Atmel SOCs (AT91, AT32 -- the same GPIO module)
>      * OMAP2/OMAP3 (not quite as simple)
> 
> Control over how long to debounce is less common, and often applies
> to banks of GPIOs not individual signals ... not addressed here.
> 
> Drivers can request this (where available) with a new IRQF_DEBOUNCED
> flag/hint passed to request_irq():
> 
>     IF that flag is set when a handler is registered
> 	AND the relevant irq_chip supports debouncing
> 	AND the IRQ isn't already flagged as being debounced
>     THEN the irq_chip is asked to enable debouncing for this IRQ
> 	UNTIL the IRQ's last handler is unregistered.
>     ELSE
>         nothing is done ... the hint is ignored
>     FI
> 
> Comments?

How is this going to work with shared interrupt lines? If one handler
wants debouncing and second handler does not, you'll loose interrupts
for second handler?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
