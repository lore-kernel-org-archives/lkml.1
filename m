Return-Path: <linux-kernel-owner+w=401wt.eu-S1759563AbXK0TEA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759563AbXK0TEA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 14:04:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757713AbXK0TDw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 14:03:52 -0500
Received: from smtp102.sbc.mail.mud.yahoo.com ([68.142.198.201]:20366 "HELO
	smtp102.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757340AbXK0TDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 14:03:52 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=6mzECkuJdhtMdBH8TZqc1N+dO0Ro0geiMEOUSiV9vbxl4x9Ru/C6OzY5uHkmpdoMQG6E79dHU1qXGVp2Yicv3Q4D1VoNJS7wlfy/w2ZwDdbyYTbdywjFAlm7mPenOhWJ9K05aYEzeJnCzrFBqol49s4Z4xeHK29sNQAsWm2Ceas=  ;
X-YMail-OSG: zz_ENBkVM1nX0rH05P7woQh1N.qRVi68IBJe00oBPEGKV8BO7WlxvxpcJ.bi9exs3.sb0TSgSA--
From: David Brownell <david-b@pacbell.net>
To: "eric miao" <eric.y.miao@gmail.com>
Subject: Re: [patch/rfc 1/4] GPIO implementation framework
Date: Tue, 27 Nov 2007 11:03:48 -0800
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
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711271103.49200.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 November 2007, eric miao wrote:

>    c) removal of "gpiochip_is_requested()", and use "gpio_desc->requested"
>       instead

That's problematic for GPIO code that needs to know if a given
GPIO has been requested ... since you don't export gpio_desc[]
(and shouldn't) that functionality has effectively been removed!

So that would break two patches now in MM (mcp23s08 support, and
the avr32 platform conversion) plus others not yet merged...


>    d) make gpio_ensure_requested() use gpio_desc, and simplify the code a
>       bit

That's problematic too ... since it no longer actually ensures
that the chip gets marked as requested.  :(



Since struct gpio_desc isn't exported, it might as well be
private to lib/gpiolib.c instead of public in the header...
