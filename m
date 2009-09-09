Return-Path: <linux-kernel-owner+w=401wt.eu-S1754006AbZIIS26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006AbZIIS26 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 14:28:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752293AbZIIS25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 14:28:57 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:46954 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163AbZIIS25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 14:28:57 -0400
Date: Wed, 9 Sep 2009 13:28:57 -0500
From: Scott Wood <scottwood@freescale.com>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Alemao <xcarandiru@gmail.com>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: MPC85xx External/Internal Interrupts
Message-ID: <20090909182857.GB8215@b07421-ec1.am.freescale.net>
References: <d970ff420909040604h1bb3874eg5c79f79f85e713a3@mail.gmail.com> <d970ff420909041228h3638e840r34c0c0e79f178e55@mail.gmail.com> <d970ff420909041229hb3aa96dya329e06ea56dd1ac@mail.gmail.com> <20090906110641.GA11350@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090906110641.GA11350@Chamillionaire.breakpoint.cc>
User-Agent: Mutt/1.4.1i
X-Brightmail-Tracker: AAAAAQAAAWE=
X-Brightmail-Tracker: AAAAAQAAAWE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 06, 2009 at 01:06:41PM +0200, Sebastian Andrzej Siewior wrote:
> irq_of_parse_and_map() creates a mapping between the hardware irq number
> as specified in the device tree and the linux number (virq) which is
> used within the linux api in request_irq() for instance.
> irq_of_parse_and_map() is essential to create a mapping between those
> two. The interrupt controller on the MPC8555 (mpic) specifies the first
> few interrupt numbers as external sources followed by internal sources. 
> Now, during the init sequenze of the mpic every interrupt source
> (internal and external) becomes its uniqe vector number which identifies
> the source by a number. This number is the hardware interrupt number
> i.e. that thing in the device tree. The init sequence is a for loop
> which starts at 0 for the first interrupt source which happens to be
> external interrupt 0, 1 for external interrupt 1 and so on. At the time
> it reaches the first internal interrupt source the vector number is 16.
> That's why you always have an offset of 16 between every internal
> interupt source number in the MPC855ERM document and those weired
> numbers in the device tree :)

This seems to be a common point of confusion -- we should probably put
something in the dts bindings that explains it.  Am I correct in assuming
that this particular internal/external split is Freescale-specific and
not a general OpenPIC thing?

-Scott
