Return-Path: <linux-kernel-owner+w=401wt.eu-S1760389AbYFRAQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760389AbYFRAQS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 20:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757176AbYFRAQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 20:16:07 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:50562 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756775AbYFRAQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 20:16:06 -0400
From: "Hans-Peter Jansen" <hpj@urpla.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: 2.6.25.3: serial problem (minicom)
Date: Wed, 18 Jun 2008 02:15:45 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, "R.L. Horn" <lists@eastcheap.org>
References: <alpine.LNX.1.00.0806131635260.1294@hani.compact.internal> <alpine.LNX.1.00.0806162306400.10919@hani.compact.internal> <20080617095827.0f4f77de@lxorguk.ukuu.org.uk>
In-Reply-To: <20080617095827.0f4f77de@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806180215.45925.hpj@urpla.net>
X-Provags-ID: V01U2FsdGVkX1+eIONQnUw3YJ9Esx1a/jGIRRO1sUp9Pf3iRPa
 QfomYxUkAyjdITe26noMZyrr1zKsK1O5HZ0Py4JwOClSYQ/sAS
 n+iHYQ2s70UUToBpioC8Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 17. Juni 2008 schrieb Alan Cox:
> On Mon, 16 Jun 2008 23:22:54 -0500 (CDT)
>
> "R.L. Horn" <lists@eastcheap.org> wrote:
> > On Mon, 16 Jun 2008, Alan Cox wrote:
> > > Whatever it implies the behaviour should not have changed between
> > > 2.6.24 and 2.6.25. Nobody AFAIK sat down and decided to change it.
> >
> > And, besides, I've gotten reports that the usb-serial drivers still
> > behave the same as with 2.6.24.
> >
> > It looks like the call to tty_termios_encode_baud_rate() in
> > drivers/serial/8250.c is the culprit.  If I comment it out, everything
> > appears to go back to normal (seemingly with no undesired side
> > effects).
> >
> > Why the call is there (it didn't replace anything else in the 2.6.24.7
> > version of 8250.c, though it did in serial_core.c) remains a mystery to
> > me.
>
> Ah ok I know what the bug is - it was fixed in 2.6.26-rc as follows
>
> +       /* Don't rewrite B0 */
> +       if (tty_termios_baud_rate(termios))
> +               tty_termios_encode_baud_rate(termios, baud, baud);
>  }

Alan, could this issue lead to dysfunctional serial dcf77 receivers, too? 
(and could you point my to the related git changeset?)

I'm using ntpd "127.127.8.0 mode 16" devices since a decade now (RAWDCF 
receiver: DTR=low/RTS=high) and after upgrading to openSUSE 11.0, which is 
using 2.6.25.5, those get no power anymore :-(.

Or do you have another idea? I currently prepare a test system, and would be 
ready for kernel patching tomorrow..

TIA, Pete
