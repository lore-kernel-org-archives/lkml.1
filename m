Return-Path: <linux-kernel-owner+w=401wt.eu-S1756031AbYANMPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031AbYANMPT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 07:15:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754403AbYANMPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 07:15:06 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:50801 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753648AbYANMPE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 07:15:04 -0500
Date: Mon, 14 Jan 2008 13:14:29 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: "Mike Frysinger" <vapier.adi@gmail.com>
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, "Marc Pignat" <marc.pignat@hevs.ch>,
       wim@iguana.be, linux-kernel@vger.kernel.org
Subject: Re: [RFC, PATCH] watchdog on gpio
Message-ID: <20080114131429.40453e5f@siona>
In-Reply-To: <8bd0f97a0801140145s5e13083ej926aa9d5f87e3a99@mail.gmail.com>
References: <200801101611.08867.marc.pignat@hevs.ch>
	<8bd0f97a0801140004q6a32c2ceh397a2208d3012f0e@mail.gmail.com>
	<20080114090329.6efa2921@lxorguk.ukuu.org.uk>
	<8bd0f97a0801140128i2ebf9236uabe0e0b8cf15fbe@mail.gmail.com>
	<20080114092905.227c5a38@lxorguk.ukuu.org.uk>
	<8bd0f97a0801140145s5e13083ej926aa9d5f87e3a99@mail.gmail.com>
Organization: Atmel
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jan 2008 04:45:25 -0500
"Mike Frysinger" <vapier.adi@gmail.com> wrote:

> there is no hard requirement anywhere that says platform resources
> must be in the board resources file.  marking the functions as __init
> instead of __devinit will basically cause a kernel crash if someone
> tries to use dynamic platform resources.  there is no option that i'm
> aware of that prevents dynamic platform resources which means there is
> no way for the driver to say "i wont work with standard dynamic
> platform resources".

There is: platform_driver_probe(). It takes the probe function as a
parameter so that it can be left out of the platform_driver struct.
After it returns, there are no references to the probe function left
around, so if you call platform_driver_probe() instead of
platform_driver_register(), the probe function can be __init.

I agree that the driver is not safe in its current form.

Haavard
