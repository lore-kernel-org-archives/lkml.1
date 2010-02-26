Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934872Ab0BZLXu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 06:23:50 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57049 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934303Ab0BZLXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 06:23:48 -0500
Date: Fri, 26 Feb 2010 11:27:15 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tobias Klauser <tklauser@distanz.ch>
Cc: linux-serial@vger.kernel.org, nios2-dev@sopc.et.ntust.edu.tw,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] serial: Add driver for the Altera JTAG UART
Message-ID: <20100226112715.207bbd13@lxorguk.ukuu.org.uk>
In-Reply-To: <20100226090456.GA32296@distanz.ch>
References: <1267108523-32767-1-git-send-email-tklauser@distanz.ch>
	<20100225152622.7eb479aa@lxorguk.ukuu.org.uk>
	<20100226090456.GA32296@distanz.ch>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Use tty_termios_copy_hw() to copy the old termios hardware settings back
> > so that the caller sees it cannot set them.
> 
> Would the following be sufficient?
> 
>   if (old)
>           tty_termios_copy_hw(termios, old);

That will do the trick yes.

>   spin_lock(&port->lock);
> 
>   if (isr & ALTERA_JTAGUART_CONTROL_RE_MSK)
>           altera_jtaguart_rx_chars(pp);
>   if (isr & ALTERA_JTAGUART_CONTROL_WE_MSK)
>           altera_jtaguart_tx_chars(pp);
> 
>   spin_unlock(&port->lock);

Yes - that stops ->tty becoming NULL while your handler is running

Alan
