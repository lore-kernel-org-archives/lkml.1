Return-Path: <linux-kernel-owner+w=401wt.eu-S1030701AbXCFXXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030701AbXCFXXT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 18:23:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030703AbXCFXXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 18:23:19 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:31413 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030701AbXCFXXS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 18:23:18 -0500
X-IronPort-AV: i="4.14,255,1170651600"; 
   d="scan'208"; a="23739270:sNHT4718752675"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Krzysztof Halasa" <khc@pm.waw.pl>
Subject: Re: should RTS init in serial core be tied to CRTSCTS
Date: Tue, 6 Mar 2007 18:24:08 -0500
User-Agent: KMail/1.9.5
Cc: "Mike Frysinger" <vapier.adi@gmail.com>, rmk@arm.linux.org.uk,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-serial@vger.kernel.org
References: <8bd0f97a0703011603m794e00f5x875eb68ad0db05de@mail.gmail.com> <m3bqj6jebt.fsf@maximus.localdomain>
In-Reply-To: <m3bqj6jebt.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703061824.08834.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 06 Mar 2007 23:23:10.0336 (UTC) FILETIME=[6779C800:01C76046]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 6 Mar 2007 15:40, Krzysztof Halasa pondered:
> "Mike Frysinger" <vapier.adi@gmail.com> writes:
>  >            /*
>  >             * Setup the RTS and DTR signals once the
>  >             * port is open and ready to respond.
>  >             */
>  >            if (info->tty->termios->c_cflag & CBAUD)
>  >                uart_set_mctrl(port, TIOCM_RTS | TIOCM_DTR);
>  > ...
>  >
>  > shouldnt TIOCM_RTS be passed down only when the 'r' is appended to the
>  > boot cmdline ?
>
>  How would it be useful?

It is useful on (broken) legacy serial equipment, where RTS should be 
completely under the applications control.

Glitches on RTS aren't acceptable, and confuse some devices.

>  CRTSCTS is for CTS only (i.e., the transmission is paused when CTS is
>  inactive), not for RTS. DTR and RTS should be active when the port is
>  open even without CRTSCTS (= without handshaking),

That depends on the equipment that you are attached to. Some very early 
(broken) systems actually invert the meaning of RTS, so while the kernel 
thinks it is "opening" the port, it actually closes it...

>  it's used for 
>  various purposes such as providing +12V to the device (and two pins
>  can supply more power than one - sure, it isn't the best idea).

I understand - the request wasn't to change the default operation - just add a 
method of controlling things, so those minority of people who want the 
control can have it.

-Robin
