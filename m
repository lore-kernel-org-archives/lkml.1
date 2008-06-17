Return-Path: <linux-kernel-owner+w=401wt.eu-S1755965AbYFQJQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965AbYFQJQU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 05:16:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752077AbYFQJQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 05:16:13 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60911 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753181AbYFQJQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 05:16:12 -0400
Date: Tue, 17 Jun 2008 09:58:27 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "R.L. Horn" <lists@eastcheap.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.25.3: serial problem (minicom)
Message-ID: <20080617095827.0f4f77de@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LNX.1.00.0806162306400.10919@hani.compact.internal>
References: <alpine.LNX.1.00.0806131635260.1294@hani.compact.internal>
	<20080614102900.6830ed46@lxorguk.ukuu.org.uk>
	<alpine.LNX.1.00.0806150032050.1283@hani.compact.internal>
	<20080616111329.3ae97879@lxorguk.ukuu.org.uk>
	<alpine.LNX.1.00.0806162306400.10919@hani.compact.internal>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.8; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jun 2008 23:22:54 -0500 (CDT)
"R.L. Horn" <lists@eastcheap.org> wrote:

> On Mon, 16 Jun 2008, Alan Cox wrote:
> 
> > Whatever it implies the behaviour should not have changed between 2.6.24
> > and 2.6.25. Nobody AFAIK sat down and decided to change it.
> 
> And, besides, I've gotten reports that the usb-serial drivers still behave 
> the same as with 2.6.24.
> 
> It looks like the call to tty_termios_encode_baud_rate() in 
> drivers/serial/8250.c is the culprit.  If I comment it out, everything 
> appears to go back to normal (seemingly with no undesired side effects).
> 
> Why the call is there (it didn't replace anything else in the 2.6.24.7 
> version of 8250.c, though it did in serial_core.c) remains a mystery to 
> me.

Ah ok I know what the bug is - it was fixed in 2.6.26-rc as follows

+       /* Don't rewrite B0 */
+       if (tty_termios_baud_rate(termios))
+               tty_termios_encode_baud_rate(termios, baud, baud);
 }
 
