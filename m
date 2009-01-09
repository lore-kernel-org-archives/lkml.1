Return-Path: <linux-kernel-owner+w=401wt.eu-S1754143AbZAIPIN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143AbZAIPIN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 10:08:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754177AbZAIPHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 10:07:37 -0500
Received: from 201-217-static-ppp.3menatwork.com ([64.235.217.201]:45158 "EHLO
	server.hugovil.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754026AbZAIPHg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 10:07:36 -0500
Date: Fri, 9 Jan 2009 10:07:25 -0500
From: Hugo Villeneuve <hugo@hugovil.com>
To: "Thiago Galesi" <thiagogalesi@gmail.com>
Cc: "Florian Fainelli" <florian@openwrt.org>, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org
Subject: Re: FPGA programming driver architecture
Message-Id: <20090109100725.77a07e74.hugo@hugovil.com>
In-Reply-To: <82ecf08e0901081414u15af3c2dy9c88a242db024dc7@mail.gmail.com>
References: <20081212150314.6ea24996.hugo@hugovil.com>
	<200812131358.03010.florian@openwrt.org>
	<20090108151827.72f50cee.hugo@hugovil.com>
	<82ecf08e0901081414u15af3c2dy9c88a242db024dc7@mail.gmail.com>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Default is to whitelist mail, not delayed by milter-greylist-3.0 (server.hugovil.com [64.235.217.201]); Fri, 09 Jan 2009 10:07:28 -0500 (EST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Jan 2009 20:14:36 -0200
"Thiago Galesi" <thiagogalesi@gmail.com> wrote:

> > > > Hi,
> > > > I have written some code to program a FPGA in Linux, for two
> > > > different types of boards: one uses a serial interface (SPI) and
> > > > the second a parallel interface. I have been able to sucessfully
> > > > program both boards. I'm now trying to clean my code and make it
> > > > more generic, as well as better in line with the Linux driver
> > > > model.
> 
> Considering the several FPGA models available and ways to program it,
> I guess the important thing to consider is what can be made generic.
> (that is what will become fpgaload)

I have a pretty good idea of what goes into the core and
what goes into the specific interface modules (spi, parallel, etc).

> Also, there may be cases where after FPGA is programmed it "becomes a
> device" (PCI or whatever)

This is exactly the case for my board, but it doesn´t change anything
to the programming side of things, apart for the fact that the FPGA
must be configured before using any in-FPGA PCI bus for example.

> > > - fpgaload-core which contains all the code that can be shared
> > > between the drivers like requesting firmware, providing sysfs
> > > attributes,
> > > - fpgaload-spi would handle the low-level SPI connection
> > > - fpgaload-par would handle the low-level parallel connection
> 
> I think this maybe split into three layers (maybe)
> 
> 1 - low level connection: paralell / spi / i2c / whatever
> 2 - vendor: xylinx, altera, etc
> 3 - generic stuff
> 
> Take a look at the MTD and SPI drivers and how they split things

I think that for the moment, I will focus on implementing the core
module and the parallel/SPI interfaces only. Later we may want to add
more fonctionality (vendors, JTAG, etc).

But for now, my main problem is that I need to have some insight on how
I actually implement the different modules:

Bus driver?
class driver?
platform driver?

Can anybody give some advice on that?

Thank-you, Hugo.

---------------
Hugo Villeneuve
www.hugovil.com
---------------
