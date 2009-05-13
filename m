Return-Path: <linux-kernel-owner+w=401wt.eu-S1758422AbZEMASw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758422AbZEMASw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 20:18:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756893AbZEMASm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 20:18:42 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46870 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757718AbZEMASl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 20:18:41 -0400
Date: Wed, 13 May 2009 01:18:42 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Deepak Saxena <dsaxena@plexity.net>, linux-serial@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 8250: Don't restore NS16550 mode when console suspend
 is disabled
Message-ID: <20090513011842.22d9cd6c@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.01.0905121452190.3343@localhost.localdomain>
References: <20090512210015.GA25540@plexity.net>
	<alpine.LFD.2.01.0905121452190.3343@localhost.localdomain>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hmm. I already applied this, but then after looking closer, I undid that. 
> Why? It looks buggy:

I'm a bit suprised that as tty and serial maintainer this is the first
time I see the patch.

> Isn't that second test wrong? Should it not be
> 
> 	if ((up->capabilities & UART_NATSEMI) &&
> 		(console_suspend_enabled || !uart_console(&up->port)) {
> 
> instead?

The patch seems totally bogus anyway. If the console was in a high speed
mode it should be resumed in a high speed mode. What are the actual
details here.

Surely if my console is at 230Kbits/sec then resuming it at a totally
different speed is going to break things for people even if it happens to
help XO debug ?
