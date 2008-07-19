Return-Path: <linux-kernel-owner+w=401wt.eu-S1755512AbYGSPj5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512AbYGSPj5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 11:39:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754002AbYGSPjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 11:39:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:53840 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005AbYGSPjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 11:39:48 -0400
Date: Sat, 19 Jul 2008 08:39:42 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: Re  [patch 2/3] fastboot: turn the USB hostcontroller initcalls
 into async initcalls
Message-ID: <20080719083942.2daa2959@infradead.org>
In-Reply-To: <Pine.LNX.4.44L0.0807191116370.3491-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.0807191116370.3491-100000@netrider.rowland.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Jul 2008 11:25:29 -0400 (EDT)
Alan Stern <stern@rowland.harvard.edu> wrote:

> On 18 July, 2008, Arjan van de Ven wrote:
> 
> > From: Arjan van de Ven <arjan@linux.intel.com>
> > Subject: [PATCH] fastboot: turn the USB hostcontroller initcalls
> > into async initcalls
> > 
> > the USB host controller init calls take a long time, mostly due to a
> > "minimally 100 msec" delay *per port* during initialization.
> > These are prime candidates for going in parallel to everything else.
> > 
> > The USB device ordering is not affected by this due to the
> > serialized-within-eachother property of async initcalls.
> 
> 
> Where is this "minimally 100 msec" per-port delay you refer to?  
> Offhand I can't recall any such delays in the init routines.
> 

it's here (in drivers/usb/core/hub.c::hub_power_on):

                                "non-switchable hub\n");
        for (port1 = 1; port1 <= hub->descriptor->bNbrPorts; port1++)
                set_port_feature(hub->hdev, port1, USB_PORT_FEAT_POWER);

        /* Wait at least 100 msec for power to become stable */
        msleep(max(pgood_delay, (unsigned) 100));
}

at least my eeepc901 hits that like 6 or 7 times
(because if I shorten the 100 the boot goes a ton faster.. but that's
obviously just a bad hack)
-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

