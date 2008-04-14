Return-Path: <linux-kernel-owner+w=401wt.eu-S1751563AbYDNI6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751563AbYDNI6x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 04:58:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751296AbYDNI6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 04:58:46 -0400
Received: from gate.crashing.org ([63.228.1.57]:45210 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235AbYDNI6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 04:58:45 -0400
Subject: Re: pci: add to global list before sysfs?
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080414103504.24025b44@mjolnir.drzeus.cx>
References: <20080404191350.7f0183a5@mjolnir.drzeus.cx>
	 <20080404210132.GA14418@suse.de>
	 <20080405115727.1265e8a9@mjolnir.drzeus.cx>
	 <20080405155323.GA27252@suse.de>
	 <20080405185501.41ec42a7@mjolnir.drzeus.cx>
	 <1208122634.6958.59.camel@pasglop>
	 <20080414103504.24025b44@mjolnir.drzeus.cx>
Content-Type: text/plain
Date: Mon, 14 Apr 2008 18:58:36 +1000
Message-Id: <1208163516.6958.155.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-04-14 at 10:35 +0200, Pierre Ossman wrote:
> On Mon, 14 Apr 2008 07:37:14 +1000
> Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> 
> > 
> > You don't need a timer. You can just use the notifier mechanism I added
> > a while ago that should call you on device addition and removal on the
> > bus type you are interested in.
> > 
> 
> Another solution presented itself, but do you have some pointers on
> where I get more information about the notifiers in case I need them
> in the future?

In device.h:

/*
 * Bus notifiers: Get notified of addition/removal of devices
 * and binding/unbinding of drivers to devices.
 * In the long run, it should be a replacement for the platform
 * notify hooks.
 */
struct notifier_block;

extern int bus_register_notifier(struct bus_type *bus,
				 struct notifier_block *nb);
extern int bus_unregister_notifier(struct bus_type *bus,
				   struct notifier_block *nb);

/* All 4 notifers below get called with the target struct device *
 * as an argument. Note that those functions are likely to be called
 * with the device semaphore held in the core, so be careful.
 */
#define BUS_NOTIFY_ADD_DEVICE		0x00000001 /* device added */
#define BUS_NOTIFY_DEL_DEVICE		0x00000002 /* device removed */
#define BUS_NOTIFY_BOUND_DRIVER		0x00000003 /* driver bound to device */
#define BUS_NOTIFY_UNBIND_DRIVER	0x00000004 /* driver about to be
						      unbound */
Do you need more info ?

Cheers,
Ben.


