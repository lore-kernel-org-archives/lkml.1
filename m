Return-Path: <linux-kernel-owner+w=401wt.eu-S1758522AbYA3Pqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758522AbYA3Pqo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 10:46:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755479AbYA3Pqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 10:46:35 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:63249 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751482AbYA3Pqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 10:46:34 -0500
Date: Wed, 30 Jan 2008 16:46:31 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: michael <trimarchi@gandalf.sssup.it>
Cc: Remy Bohmer <linux@bohmer.net>, fabio@gandalf.sssup.it,
       Andrew Victor <linux@maxim.org.za>, Chip Coldwell <coldwell@redhat.com>,
       Marc Pignat <marc.pignat@hevs.ch>, David Brownell <david-b@pacbell.net>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH -mm v4 6/9] atmel_serial: Split the interrupt handler
Message-ID: <20080130164631.7de4f6bd@dhcp-252-066.norway.atmel.com>
In-Reply-To: <47A09723.7020000@gandalf.sssup.it>
References: <20080129224316.GA23155@gandalf.sssup.it>
	<479FB2D7.4020804@gandalf.sssup.it>
	<20080130104113.48ec376f@dhcp-252-066.norway.atmel.com>
	<47A051A7.7030004@gandalf.sssup.it>
	<20080130133659.55ebd828@dhcp-252-066.norway.atmel.com>
	<47A09723.7020000@gandalf.sssup.it>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jan 2008 16:26:27 +0100
michael <trimarchi@gandalf.sssup.it> wrote:

> > I have no idea. Could you post some more specifics about what you
> > modified, for example a diff?
> >
> >     
> 
> ...
> /* The interrupt handler does not take the lock */
> spin_lock_irqsave(&port->lock, flags);
> atmel_tx_chars(port);
> spin_unlock_irqrestore(&port->lock, flags);

Sorry, this isn't going to work.

Please post a diff with the changes you did to the driver, and whatever
output you got when it crashed.

It's really difficult to help you when I don't know (a) what code
you're actually running, or (b) anything about the crash.

> The atmel_tx_chars using the serial device registers like the interrupt 
> routine
> and so I think that it is possible to have interference during send 
> operation.

No, it's only called from the tasklet, and the interrupt handler doesn't
touch the TX data register. There shouldn't be any need to disable
interrupts around the call to atmel_tx_chars(). In fact, this may very
well be the cause of the overruns you're seeing.

Haavard
