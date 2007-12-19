Return-Path: <linux-kernel-owner+w=401wt.eu-S1755954AbXLSQsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954AbXLSQsp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 11:48:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752845AbXLSQsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 11:48:22 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:51657 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752773AbXLSQsV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 11:48:21 -0500
Date: Wed, 19 Dec 2007 17:47:42 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: "Remy Bohmer" <linux@bohmer.net>
Cc: "Andrew Victor" <linux@maxim.org.za>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       "Russell King" <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
       kernel@avr32linux.org
Subject: Re: [PATCH v2 0/6] atmel_serial: Cleanups, irq handler splitup &
 DMA
Message-ID: <20071219174742.68e70c6c@dhcp-252-066.norway.atmel.com>
In-Reply-To: <3efb10970712190840m39876762yb4d31c36723c3b8a@mail.gmail.com>
References: <1198077130-9021-1-git-send-email-hskinnemoen@atmel.com>
	<3efb10970712190757m18f8851cq54061ff109790805@mail.gmail.com>
	<20071219170935.4df62471@dhcp-252-066.norway.atmel.com>
	<3efb10970712190840m39876762yb4d31c36723c3b8a@mail.gmail.com>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Dec 2007 17:40:44 +0100
"Remy Bohmer" <linux@bohmer.net> wrote:

> But... I tried that patch, and it works a lot better, no oopses
> anymore,

Good :)

> but I noticed that I sometimes get an input overrun (ttyS0: 1
> input overrun(s) ) during stress conditions.
> This is something I did not notice before, maybe it was already there,
> or has something changed in this area that it is now more sensitive
> for this?

Hmm...is this with or without DMA?

If it's with DMA, perhaps we should increase the size of the RX buffer
to compensate for moving the DMA RX code into tasklet context?

If it's without DMA, something very strange is going on -- the non-DMA
RX code is almost the only thing left in the hardirq handler, so I
would really expect overruns to be much less likely to occur now than
before...

Haavard
