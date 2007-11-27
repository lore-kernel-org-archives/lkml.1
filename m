Return-Path: <linux-kernel-owner+w=401wt.eu-S1759123AbXK0R0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759123AbXK0R0m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 12:26:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757516AbXK0R0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 12:26:35 -0500
Received: from smtp114.sbc.mail.mud.yahoo.com ([68.142.198.213]:23165 "HELO
	smtp114.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757104AbXK0R0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 12:26:34 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=PqW6qiA8IsNoh8pnpx1Qkm86N7JL+6htWc0ur6ZqWhOXKpsS/Mr94S1abbW/SYeQEHD9rsGbzttRJZka9HBuQtOvuKW1PjfMmrJ13oHNVlBqSRLSUMZnwBQyzv5BUY1jcV8E8PWORMc6uNexzOmXQKGUiDG0GvESNcpvJWii0qc=  ;
X-YMail-OSG: xRwBNI0VM1lfE6J7DxHv11mkVhR2FxIxZiZpz9ar1VV4tYauQ4T65mpNyUDA03wb3I8Le4SGww--
From: David Brownell <david-b@pacbell.net>
To: "eric miao" <eric.y.miao@gmail.com>
Subject: Re: [patch/rfc 1/4] GPIO implementation framework
Date: Tue, 27 Nov 2007 09:26:30 -0800
User-Agent: KMail/1.9.6
Cc: "Linux Kernel list" <linux-kernel@vger.kernel.org>,
       "Felipe Balbi" <felipebalbi@users.sourceforge.net>,
       "Bill Gatliff" <bgat@billgatliff.com>,
       "Haavard Skinnemoen" <hskinnemoen@atmel.com>,
       "Andrew Victor" <andrew@sanpeople.com>,
       "Tony Lindgren" <tony@atomide.com>, "Jean Delvare" <khali@linux-fr.org>,
       "Kevin Hilman" <khilman@mvista.com>, "Paul Mundt" <lethal@linux-sh.org>,
       "Ben Dooks" <ben@trinity.fluff.org>
References: <200710291809.29936.david-b@pacbell.net> <200711261746.55235.david-b@pacbell.net> <f17812d70711270258v1e2b47aam74da33687728a78@mail.gmail.com>
In-Reply-To: <f17812d70711270258v1e2b47aam74da33687728a78@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200711270926.30948.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, I'll be looking at it ... the one thing I strongly dislike is
this change:

On Tuesday 27 November 2007, eric miao wrote:
> 4. use a loop for "gpio_desc[]" instead of a loop for "gpio_chips[]" in
>    gpiolib_show(), change is straight forward; since it is now per gpio
>    based, the gpio_chip.dbg_show() is removed as well

That removes the ability to display all kinds of significant
chip-specific state ... like whether a given signal has active
pullups or pulldowns, uses open-drain signaling, and so forth.

It also makes access a lot slower ... e.g. rather than one
batch of I2C or SPI operations for all N signals on a chip,
it's got to do N batches.

Plus it just needlessly breaks existing code.

I'll put together a version without that problem.

- Dave
