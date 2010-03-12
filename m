Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756929Ab0CLJGr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 04:06:47 -0500
Received: from ns.penguin.cz ([84.21.108.25]:44238 "EHLO ns.penguin.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756603Ab0CLJGn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 04:06:43 -0500
Subject: Re: bit errors on spitz
From: Stanislav Brabec <utx@penguin.cz>
To: Andy Green <andy@warmcat.com>
Cc: Eric Miao <eric.y.miao@gmail.com>, dbaryshkov@gmail.com,
       Cyril Hrubis <metan@ucw.cz>, arminlitzel@web.de,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@opfer-online.de,
       lenz@cs.wisc.edu, rpurdie@rpsys.net,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Pavel Machek <pavel@ucw.cz>, thommycheck@gmail.com,
       zaurus-devel@www.linuxtogo.org, omegamoon@gmail.com
In-Reply-To: <4B995EE1.1050609@warmcat.com>
References: <20100305212708.GC21773@elf.ucw.cz>
	 <f17812d71003072137u51be17a1ie3e50e30dea16f77@mail.gmail.com>
	 <20100308072858.GA29939@atrey.karlin.mff.cuni.cz>
	 <20100308082530.GA1982@atrey.karlin.mff.cuni.cz>
	 <4B98EF5D.5000609@warmcat.com> <1268322155.3990.114.camel@hammer.suse.cz>
	 <4B995EE1.1050609@warmcat.com>
Content-Type: text/plain; charset="ISO-8859-2"
Date: Fri, 12 Mar 2010 10:07:04 +0100
Message-ID: <1268384824.4963.35.camel@utx.utx.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Green wrote: 
> On 03/11/10 15:42, Somebody in the thread at some point said:
> > Andy Green wrote:
> >
> >> I saw very similar failures for a long time on our iMX31 based device.
> >> Eventually I found a Freescale errata where the RAM inside the USB2
> >> macrocell started to make single bit errors below 1.38V Vcore; ours was
> >> 1.4V at that time but dipped on CPU load.
> >
> > Good tip. It seems that nobody ported driver for the voltage control
> > chip ISL6271 from 2.4 kernel, and bootloader probably does not set
> > correct values.

> Unless there's more to it in the way the zaurus using it that regulator 
> isn't programmable digitally.

OOPS, I made a mistake and linked ISL6721 instead of ISL6271 there.
Now it is fixed:
http://www.penguin.cz/~utx/zaurus/datasheets/power/XScale/ISL6271A.pdf

This one has I2C. It is connected to GPIO 3 (PWR_SCL) and GPIO 4
(PWR_SDA).

It is visible between the black plastic and the large circular coil:
http://www.penguin.cz/~utx/zaurus/teardown#pcbt

> Reading about your CF Card WLAN related issues they suck down a good 
> amount of power when their radio is up, I would definitely suggest 
> monitoring with a 'scope the various rails (Vcore, RAM and whatever it 
> is the CF Card is powered by) while putting it under load.

I guess that Zaurus has a good power design and that voltage should be
constant enough. CF has a dedicated step down (plus 2.8V power detector
(Why so low, if CF standard requres more?)), HDD has a dedicated step
up/down. USB has dedicated step up. Companion chips use dedicated 3.3V
step down. Audio uses dedicated linear regulator. CPU has several
dedicated step downs, CPU 3.3V uses step-up to 5V and then down to 3.3V
(which is shared only with IOPORT).

Nearest common point between CF card power and CPU power is the battery.


________________________________________________________________________

Stanislav Brabec
http://www.penguin.cz/~utx/zaurus


