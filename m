Return-Path: <linux-kernel-owner+w=401wt.eu-S1759127AbZEMAgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759127AbZEMAgu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 20:36:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758310AbZEMAfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 20:35:46 -0400
Received: from plexity.net ([206.123.115.38]:35621 "EHLO plexity.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756809AbZEMAfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 20:35:44 -0400
Date: Wed, 13 May 2009 00:34:51 +0000
From: Deepak Saxena <dsaxena@plexity.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] 8250: Don't restore NS16550 mode when console suspend
	is disabled
Message-ID: <20090513003451.GB28422@plexity.net>
Reply-To: dsaxena@plexity.net
References: <20090512210015.GA25540@plexity.net> <alpine.LFD.2.01.0905121452190.3343@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0905121452190.3343@localhost.localdomain>
Organization: Plexity, LLC
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On May 12 2009, at 15:00, Linus Torvalds was caught saying:
> 
> Hmm. I already applied this, but then after looking closer, I undid that. 
> Why? It looks buggy:
> 
> > -	if (up->capabilities & UART_NATSEMI) {
> > +	if ((up->capabilities & UART_NATSEMI) && 
> > +	     (!uart_console(&up->port) && console_suspend_enabled)) {
> >  		unsigned char tmp;
> 
> Isn't that second test wrong? Should it not be
> 
> 	if ((up->capabilities & UART_NATSEMI) &&
> 		(console_suspend_enabled || !uart_console(&up->port)) {
> 
> instead?

Yep, thinko on my end.

> 	/*
> 	 * Suspend the uart port unless it's a console. 
> 	 *
> 	 * But suspend even consoles if "console_suspend_enabled"
> 	 * is set.
> 	 */
> 	static inline int do_suspend_uart(struct uart_port *port)
> 	{
> 		return console_suspend_enabled || !uart_console(port);
> 	}
> 
> and then make all these things (including the _existing_ cases in 
> uart_suspend_port() use that helper function, rather than writing it out.

Sounds good. Alan?

~Deepak

-- 
In the end, they will not say, "those were dark times,"  they will ask
"why were their poets silent?" - Bertold Brecht

