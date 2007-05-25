Return-Path: <linux-kernel-owner+w=401wt.eu-S1758461AbXEYHYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758461AbXEYHYR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 03:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750885AbXEYHYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 03:24:08 -0400
Received: from twin.jikos.cz ([213.151.79.26]:48959 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769AbXEYHYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 03:24:07 -0400
Date: Fri, 25 May 2007 09:23:53 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Zan Lynx <zlynx@acm.org>, Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc2-mm1
In-Reply-To: <1180058760.7001.6.camel@oberon.rnd.esoft.com>
Message-ID: <Pine.LNX.4.64.0705250910110.8531@twin.jikos.cz>
References: <20070523004233.5ae5f6fd.akpm@linux-foundation.org> 
 <1179962229.8575.4.camel@localhost>  <Pine.LNX.4.64.0705240131050.27422@twin.jikos.cz>
 <1180058760.7001.6.camel@oberon.rnd.esoft.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 May 2007, Zan Lynx wrote:

> [snip]
> > Do you please have any indication which kernel versions were OK with the 
> > same .config, with respect to the USB mouse/keyboard hogs you are seeing 
> > with 2.6.22-rc2-mm1?
> The last 2.6.21 -mm kernel worked well.
[...]
> drivers/hid/usbhid/hid-core.c: input irq status -75 received

Zan,

this has been reported also in bugzilla, so it's now handled in 
http://bugzilla.kernel.org/show_bug.cgi?id=8535

It's reported there that mainline is OK, and there are realy very few 
patches in the HID area which I can't imagine how they could be causing 
it, they are only a few simple quirks for a specific hardware.

Could you please try the following things in this order:

- disable CONFIG_HIDRAW and test whether it is still reproducible
- revert git-hid.patch and test whether it is still reproducible
- if so, I am afraid that it's some USB patch that is causing this, so 
  bisecting would be needed

I will meanwhile try to reproduce it myself here, but I have not been 
successful with it so far.

Thanks,

-- 
Jiri Kosina
