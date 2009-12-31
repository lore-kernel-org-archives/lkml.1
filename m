Return-Path: <linux-kernel-owner+w=401wt.eu-S1752091AbZLaJAB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091AbZLaJAB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 04:00:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751605AbZLaJAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 04:00:00 -0500
Received: from www84.your-server.de ([213.133.104.84]:42995 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475AbZLaJAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 04:00:00 -0500
Subject: Re: [PATCH] [0/6] kfifo fixes/improvements
From: Stefani Seibold <stefani@seibold.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Andy Walls <awalls@radix.net>, Vikram Dhillon <dhillonv10@gmail.com>,
       Andi Kleen <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@osdl.org" <akpm@osdl.org>
In-Reply-To: <20091231073547.GA14333@core.coreip.homeip.net>
References: <20091228145749.GD4994@basil.fritz.box>
	 <1262016510.12656.25.camel@wall-e> <20091228172651.GE4994@basil.fritz.box>
	 <1262030653.15368.37.camel@wall-e> <20091228204003.GH4994@basil.fritz.box>
	 <1262076056.23095.21.camel@wall-e>
	 <64D5262E-28CF-41E8-9425-F8C5DD0A2265@gmail.com>
	 <ea6602020912291718n103694aft78ef15b65081a996@mail.gmail.com>
	 <20091230020830.GA7049@core.coreip.homeip.net>
	 <1262194152.5645.10.camel@palomino.walls.org>
	 <20091231073547.GA14333@core.coreip.homeip.net>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 31 Dec 2009 09:59:51 +0100
Message-ID: <1262249991.3521.7.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, den 30.12.2009, 23:35 -0800 schrieb Dmitry Torokhov:

> > I have a use case in linux/drivers/media/video/cx23885/cx23888-ir.c
> > right now.
> > 
> > I have a hardware fifo that can hold up to 8 values, 17 bits each - and
> > the high bit of the value is a flag indicating if more data is in the
> > hardware fifo.
> > 
> > The hardware fifo watermark for generating an interrupt is 4 or more
> > values in the hardware fifo.
> > 
> > I use a kfifo that needs to be protected with a spinlock.
> > 
> > It in much better in the IRQ context to drain the hardware fifo and then
> > put records in the kfifo all at once (or at least in groups of 8 or less
> > but usually greater than 1).
> 
> Hmm, so there you have a local buffer that you fill by reading from the
> device word by word, then you copy that data over into fifo and then you
> upper layer again fetches that fifo as byte stream...
> 
> I'd probably simply move the processing that you are doing in
> cx23888_ir_rx_read() into cx23888_ir_irq_handler() (since it is very
> simple) and then used kfifo in simple byte mode (since that is what
> upper layer seem to expect).
> 

Why using byte mode? He can use any type he like, the new macro based
implementation is record based! And a record can be a byte or any other
data type. Why do you discuss about code you didn't understand and want
not try? Why to discuss and waste time about less than 400 bytes of
library code? Terminate this useless discussion.


