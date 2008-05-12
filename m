Return-Path: <linux-kernel-owner+w=401wt.eu-S1760881AbYELKz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760881AbYELKz3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 06:55:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755515AbYELKzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 06:55:18 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:49221 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755326AbYELKzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 06:55:16 -0400
Date: Mon, 12 May 2008 11:44:07 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bryan Wu <cooloney@kernel.org>
Cc: linux-kernel@vger.kernel.org, Oleksiy Kebkal <kebkal@gmail.com>,
       Oleksiy Kebkal <lesha@evologics.de>,
       Russell King <rmk@arm.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bryan Wu <cooloney@kernel.org>
Subject: Re: [PATCH 1/1] [serial/core]: This patch leaves RTS alone when
 CRTSCTS is not set.
Message-ID: <20080512114407.1dd79301@core>
In-Reply-To: <1210587614-10016-1-git-send-email-cooloney@kernel.org>
References: <1210587614-10016-1-git-send-email-cooloney@kernel.org>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +			 * Setup the RTS (in the case of hardware flow control)
> +			 * and DTR signals once the port is open and ready to
> +			 * respond.
>  			 */
> -			if (info->tty->termios->c_cflag & CBAUD)
> -				uart_set_mctrl(port, TIOCM_RTS | TIOCM_DTR);
> +			if (info->tty->termios->c_cflag & CBAUD) {
> +				uart_set_mctrl(port, TIOCM_DTR);
> +				if (info->flags & UIF_CTS_FLOW)
> +					uart_set_mctrl(port, TIOCM_RTS);
> +			}

Seems fine but we've now got 5 line blocks of duplicated code - and code
we will need to complicate further in future if we add other flow control
systems.

statc void uart_set_flow_control(port, int onoff)
{
	..
}

Would be worth writing and using for these cases

(Yes I am being fussy: I am currently trying to stamp out lots of code
duplication in the tty and serial layers so I don't want more added as it
is getting out of hand)

Alan
