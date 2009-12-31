Return-Path: <linux-kernel-owner+w=401wt.eu-S1752170AbZLaJdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170AbZLaJdf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 04:33:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752002AbZLaJdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 04:33:35 -0500
Received: from mail-px0-f189.google.com ([209.85.216.189]:48133 "EHLO
	mail-px0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001AbZLaJde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 04:33:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WZbt8irSY7kUxbkQwpM8vmxqai3wnJJ92JEFADlmZyg/xicegWT8RwOSHpfOz0qmFF
         I6n8AnvyLpecibrcKkjNYKsZLTCg6TZzcoHT2QisRFWHJGLyV8CSqr6Z8C96VZK8qH6w
         X+fANVeKBCJWsUZoJAQ4fFZaGFoTeHhSg2HPU=
Date: Thu, 31 Dec 2009 01:33:29 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Stefani Seibold <stefani@seibold.net>
Cc: Andy Walls <awalls@radix.net>, Vikram Dhillon <dhillonv10@gmail.com>,
       Andi Kleen <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@osdl.org" <akpm@osdl.org>
Subject: Re: [PATCH] [0/6] kfifo fixes/improvements
Message-ID: <20091231093329.GA2396@core.coreip.homeip.net>
References: <20091228172651.GE4994@basil.fritz.box>
 <1262030653.15368.37.camel@wall-e>
 <20091228204003.GH4994@basil.fritz.box>
 <1262076056.23095.21.camel@wall-e>
 <64D5262E-28CF-41E8-9425-F8C5DD0A2265@gmail.com>
 <ea6602020912291718n103694aft78ef15b65081a996@mail.gmail.com>
 <20091230020830.GA7049@core.coreip.homeip.net>
 <1262194152.5645.10.camel@palomino.walls.org>
 <20091231073547.GA14333@core.coreip.homeip.net>
 <1262249991.3521.7.camel@wall-e>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1262249991.3521.7.camel@wall-e>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 31, 2009 at 09:59:51AM +0100, Stefani Seibold wrote:
> Am Mittwoch, den 30.12.2009, 23:35 -0800 schrieb Dmitry Torokhov:
> 
> > > I have a use case in linux/drivers/media/video/cx23885/cx23888-ir.c
> > > right now.
> > > 
> > > I have a hardware fifo that can hold up to 8 values, 17 bits each - and
> > > the high bit of the value is a flag indicating if more data is in the
> > > hardware fifo.
> > > 
> > > The hardware fifo watermark for generating an interrupt is 4 or more
> > > values in the hardware fifo.
> > > 
> > > I use a kfifo that needs to be protected with a spinlock.
> > > 
> > > It in much better in the IRQ context to drain the hardware fifo and then
> > > put records in the kfifo all at once (or at least in groups of 8 or less
> > > but usually greater than 1).
> > 
> > Hmm, so there you have a local buffer that you fill by reading from the
> > device word by word, then you copy that data over into fifo and then you
> > upper layer again fetches that fifo as byte stream...
> > 
> > I'd probably simply move the processing that you are doing in
> > cx23888_ir_rx_read() into cx23888_ir_irq_handler() (since it is very
> > simple) and then used kfifo in simple byte mode (since that is what
> > upper layer seem to expect).
> > 
> 
> Why using byte mode? He can use any type he like, the new macro based
> implementation is record based! And a record can be a byte or any other
> data type. Why do you discuss about code you didn't understand and want
> not try? Why to discuss and waste time about less than 400 bytes of
> library code? Terminate this useless discussion.
> 

Yes, indeed. 

-- 
Dmitry
