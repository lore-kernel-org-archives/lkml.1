Return-Path: <linux-kernel-owner+w=401wt.eu-S933010AbXCDQUE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933010AbXCDQUE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 11:20:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933012AbXCDQUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 11:20:04 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:3258 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933010AbXCDQUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 11:20:01 -0500
X-IronPort-AV: i="4.14,246,1170651600"; 
   d="scan'208"; a="23500083:sNHT24156993"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Mike Frysinger" <vapier.adi@gmail.com>
Subject: Re: should RTS init in serial core be tied to CRTSCTS
Date: Sun, 4 Mar 2007 11:20:44 -0500
User-Agent: KMail/1.9.5
Cc: rmk@arm.linux.org.uk,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-serial@vger.kernel.org
References: <8bd0f97a0703011603m794e00f5x875eb68ad0db05de@mail.gmail.com>
In-Reply-To: <8bd0f97a0703011603m794e00f5x875eb68ad0db05de@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703041120.45211.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 04 Mar 2007 16:19:53.0936 (UTC) FILETIME=[F1372D00:01C75E78]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 1 Mar 2007 19:03, Mike Frysinger pondered:
> the console= bootcmd allows for controlling of the initial state of
> flow control by adding/omitting the 'r' suffix ... however, the
> uart_startup() function in serial_core.c always calls down into the
> serial driver with TIOCM_RTS:
> static int uart_startup(...) {
> ...
>             /*
>              * Setup the RTS and DTR signals once the
>              * port is open and ready to respond.
>              */
>             if (info->tty->termios->c_cflag & CBAUD)
>                 uart_set_mctrl(port, TIOCM_RTS | TIOCM_DTR);
> ...
>
> shouldnt TIOCM_RTS be passed down only when the 'r' is appended to the
> boot cmdline ?  perhaps like this:
> uart_set_mctrl(port, (info->flags & UIF_CTS_FLOW ? TIOCM_RTS : 0) |
> TIOCM_DTR); assuming too that TIOCM_DTR should always be set ...

This would help a similar problem I am having. Simply using a serial console 
with Flow control enabled, turns flow control on. 

If the application wants the capability to turn Flow control on later, without 
booting with it on, the current code does not allow this...

Was this the intended use the the 'console=...r'?

Thanks
-Robin
