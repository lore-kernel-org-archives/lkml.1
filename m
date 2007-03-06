Return-Path: <linux-kernel-owner+w=401wt.eu-S932526AbXCFUk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932526AbXCFUk1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 15:40:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932632AbXCFUk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 15:40:27 -0500
Received: from khc.piap.pl ([195.187.100.11]:34090 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932610AbXCFUkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 15:40:25 -0500
To: "Mike Frysinger" <vapier.adi@gmail.com>
Cc: rmk@arm.linux.org.uk,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-serial@vger.kernel.org, "Robin Getz" <rgetz@blackfin.uclinux.org>
Subject: Re: should RTS init in serial core be tied to CRTSCTS
References: <8bd0f97a0703011603m794e00f5x875eb68ad0db05de@mail.gmail.com>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Tue, 06 Mar 2007 21:40:22 +0100
In-Reply-To: <8bd0f97a0703011603m794e00f5x875eb68ad0db05de@mail.gmail.com> (Mike Frysinger's message of "Thu, 1 Mar 2007 19:03:02 -0500")
Message-ID: <m3bqj6jebt.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Mike Frysinger" <vapier.adi@gmail.com> writes:

>            /*
>             * Setup the RTS and DTR signals once the
>             * port is open and ready to respond.
>             */
>            if (info->tty->termios->c_cflag & CBAUD)
>                uart_set_mctrl(port, TIOCM_RTS | TIOCM_DTR);
> ...
>
> shouldnt TIOCM_RTS be passed down only when the 'r' is appended to the
> boot cmdline ?

How would it be useful?

CRTSCTS is for CTS only (i.e., the transmission is paused when CTS is
inactive), not for RTS. DTR and RTS should be active when the port is
open even without CRTSCTS (= without handshaking), it's used for
various purposes such as providing +12V to the device (and two pins
can supply more power than one - sure, it isn't the best idea).

I wouldn't touch that.
-- 
Krzysztof Halasa
