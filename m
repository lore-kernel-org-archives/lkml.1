Return-Path: <linux-kernel-owner+w=401wt.eu-S1753045AbXDBEEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045AbXDBEEu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 00:04:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753051AbXDBEEu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 00:04:50 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:46299 "EHLO
	asav00.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045AbXDBEEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 00:04:49 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HAFIdEEZKhRO4UGdsb2JhbACHO4hCAQEq
From: Dmitry Torokhov <dtor@insightbb.com>
To: Dan Engel <dan@sourceharvest.com>
Subject: Re: [PATCH] hid: add two led codes to hid input mapping
Date: Mon, 2 Apr 2007 00:04:51 -0400
User-Agent: KMail/1.9.3
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org
References: <1175396188.7857.15.camel@monica.engel.home> <Pine.LNX.4.64.0704011941310.6040@jikos.suse.cz> <1175484539.12355.18.camel@monica.engel.home>
In-Reply-To: <1175484539.12355.18.camel@monica.engel.home>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704020004.51861.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

On Sunday 01 April 2007 23:28, Dan Engel wrote:
> On Sun, 2007-04-01 at 19:43 +0200, Jiri Kosina wrote:
> > On Sun, 1 Apr 2007, Dmitry Torokhov wrote:
> > 
> > > No, I do not want to add any more LED constants to input. In fact I 
> > > think that adding constants beyond keyboard indicators was a mistake. We 
> > > have led subsystem that provides interface to control arbitrary leds and 
> > > we should use it.
> > 
> > Ah, of course. Dan, could you please redo the patch to use the leds 
> > infrastructure and send it to me?
> 
> Perhaps I could find a way to do that, but it seem rather a round-about
> way to go about it. The fact is that the input subsystem is already the
> home of this device.
> 
> As far as I can tell, the led subsystem doesn't already provide any
> framework for mapping LED's to HID input events. I could possibly create
> a driver in the led subsystem that sends the corresponding events to the
> input subsystem, but those events would be dropped by the input system,
> anyway, since the event class would still have to be EV_LED and the code
> would still be unrecognized without those two mappings.
>

No, no, do not try to route the control through evdev. Since the LED
override is device-sepcific (i.e yours is the only device which will
react in that way) I'd recommend using sysfs attributes to control it.
Hm, we may need to wait for HID bus to clearly do that in a separate
driver...
 
> Given that the HID or input subsystem still needs to be in the loop,
> however the driver is written, can you give any advice for accomplishing
> that without adding the extra LED mappings?

Actually I want to keep input subystm out of the loop here, since LEDs
such as mail, charging, etc have nothing to do with user input but
rather reflect overall system/application state.

-- 
Dmitry
