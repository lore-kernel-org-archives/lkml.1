Return-Path: <linux-kernel-owner+w=401wt.eu-S1754315AbZHKMnF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315AbZHKMnF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 08:43:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754245AbZHKMnB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 08:43:01 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:37130 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbZHKMm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 08:42:57 -0400
Subject: Re: Question about userspace-consumer
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Felipe Balbi <me@felipebalbi.com>
Cc: Mike Rapoport <mike@compulab.co.il>, linux-kernel@vger.kernel.org
In-Reply-To: <20090811094020.GA6762@rakim.wolfsonmicro.main>
References: <20090810200553.GB4652@gandalf>
	 <20090810215800.GB4528@sirena.org.uk> <20090811054438.GA7176@gandalf>
	 <20090811094020.GA6762@rakim.wolfsonmicro.main>
Content-Type: text/plain
Date: Tue, 11 Aug 2009 11:30:16 +0100
Message-Id: <1249986616.5807.28.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-11 at 10:40 +0100, Mark Brown wrote:
> On Tue, Aug 11, 2009 at 08:44:42AM +0300, Felipe Balbi wrote:
> > On Mon, Aug 10, 2009 at 10:58:01PM +0100, Mark Brown wrote:
> 
> > > Looking at that I'm not sure why you wish to push this into user space?
> 
> > we need some daemon monitoring battery statuses and taking actions on
> > that. Imagine, for example, usb charging where we can:
> 
> > a. charge up to 100mA when unconfigured
> > b. charge up to 500mA when configured
> > c. charge up to 2.5A when with dedicated charger
> > d. charge up to 2.5mA when bus is suspended
> 
> It's more complex than that - those are the limits at the USB port that
> define the power that can be drawn by the system.  The actual power
> available to the battery subsytem will be less since the rest of the
> system needs to be powered.  In many cases even with 500mA available
> the battery will need to be used to provide additional power in order to
> keep the system operational rather than being charged.
> 
> For USB powered operation at least some of the management here would
> usually be implemented in hardware to provide the responsiveness
> required.  Waiting for software to get involved would often allow the
> main system supply to collapse.
> 
> > handling all of those cases on kernel space seems a little bit odd,
> > especially because we still need to take care of state-of-charge,
> > pack temperature, time-to-charge, etc etc etc.
> 
> > a big looping polling for that stuff in kernel space didn't seem ok to
> > me.
> 
> No matter what you're still going to need at least some of the code
> in-kernel in order to handle the monitoring daemon exiting.  For
> example, if the battery is in fast charge then something will need to
> back the charger off at least as the charge completes (if not
> immediately user space exits) otherwise the battery or entire system is
> likely to be damaged.
> 
> Like I say some user space control does seem reasonable but I'd not
> expect an entirely user space implementation.

I agree, I think this probably deserves both user and kernel space
components although the dividing line between them is a little uncertain
atm. 

Generally, I'd expect the kernel side to provide a guaranteed *safe*
environment for charging wrt system stability and battery status. A
simple state machine would probably suffice.

I think userspace is where we would manage policy. We would also store
past battery history in order to better manage future charging and
charge level estimation. 

Liam

