Return-Path: <linux-kernel-owner+w=401wt.eu-S1753395AbYJ1MEF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395AbYJ1MEF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 08:04:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752627AbYJ1MDz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 08:03:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:54471 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752588AbYJ1MDy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 08:03:54 -0400
Subject: Re: [Regulator RFC] da903x: Where should usb charge pump support
	go?
From: Liam Girdwood <lrg@kernel.org>
To: felipe.balbi@nokia.com
Cc: ext Jonathan Cameron <jic23@cam.ac.uk>, eric miao <eric.y.miao@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Mark Brown <broonie@sirena.org.uk>
In-Reply-To: <20081028112341.GF27144@gandalf.research.nokia.com>
References: <4906F500.7080100@cam.ac.uk>
	 <20081028112341.GF27144@gandalf.research.nokia.com>
Content-Type: text/plain
Date: Tue, 28 Oct 2008 12:03:02 +0000
Message-Id: <1225195382.28382.168.camel@dell-desktop.example.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-10-28 at 13:23 +0200, Felipe Balbi wrote:
> On Tue, Oct 28, 2008 at 11:18:24AM +0000, ext Jonathan Cameron wrote:
> > Dear All,
> > 
> > The new da903x driver is proving to be a good replacement for the out of kernel
> > driver I've been using previously.
> > 
> > Unfortunately there is still quite a lot of functionality to to add.
> > 
> > The key one for me is control of the USB charge pump. So the question is, does
> > this fit within the regulator framework (i.e. should I add it to the regulator
> > driver) or should this be a seperate driver (and if so where?)
> > 
> > Personally I'm not convinced it fits cleanly within the regulator framework
> > given it is probably only ever going to get called from one driver and has
> > somewhat odd properties!
> 
> I was thinking the same and even mailed Liam and Mark about it. The
> design I was thinking was the charger chip would be done in regulator
> framework and the battery chip (or current gauge) would be using power
> supply fw and regulator consumer device.
> 
> The constraints would be basically the current and/or voltage range your
> charger chip supports.
> 
> I still didn't have much time to hack on it, but seemed to be pretty
> reasonable.
> 
> If someone has better idea, I'd trully like to hear that.
> 

Fwiw, we have done something similar with the wm8350 charger and exposed
it through the kernel power supply framework. The charger is connected
directly to the wm8350 line input and not controllable through any
regulator hence it was not made a regulator consumer.

Jonathan, since this charge pump has an 'odd' interface and one user it
may just be easier to initially add outwith the framework. It should
probably live in drivers/mfd with the da903x core.

Fwiw, we should look at supporting charge pumps in the regulator
framework as we already support voltage and current sink regulators. 

Liam

