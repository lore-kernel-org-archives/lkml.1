Return-Path: <linux-kernel-owner+w=401wt.eu-S1757048AbYC0J2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757048AbYC0J2S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 05:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751378AbYC0J2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 05:28:04 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:49688 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751360AbYC0J2C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 05:28:02 -0400
Date: Thu, 27 Mar 2008 10:26:48 +0100
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Dmitry <dbaryshkov@gmail.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, hskinnemoen@atmel.com,
       domen.puncer@telargo.com, lethal@linux-sh.org, tony@atomide.com,
       paul@pwsan.com
Subject: Re: [PATCH 1/3] Clocklib: add generic framework for managing
 clocks.
Message-ID: <20080327102648.225d6b4f@hskinnemo-gx620.norway.atmel.com>
In-Reply-To: <20080327091810.GA32396@flint.arm.linux.org.uk>
References: <20080326154913.GA15326@doriath.ww600.siemens.net>
	<20080326155203.GA15405@doriath.ww600.siemens.net>
	<20080326170441.795fb928@hskinnemo-gx620.norway.atmel.com>
	<bc64b4640803260952s58ad0645ve11766fdfa45e785@mail.gmail.com>
	<20080327100623.34d92c84@hskinnemo-gx620.norway.atmel.com>
	<20080327091810.GA32396@flint.arm.linux.org.uk>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Mar 2008 09:26:48.0766 (UTC) FILETIME=[AECB1DE0:01C88FEC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Mar 2008 09:18:10 +0000
Russell King <rmk+lkml@arm.linux.org.uk> wrote:

> On Thu, Mar 27, 2008 at 10:06:23AM +0100, Haavard Skinnemoen wrote:
> > > +	int		users;
> > 
> > Reference counting, probably need that too.
> > 
> > > +	unsigned long	rate;
> > 
> > This one is redundant. Use getrate() instead.
> 
> ... which means a separate getrate() functions for every clock.  Not really
> practical for PXA.

You can extend the struct, put the rate there and use the same
getrate() function for all the clocks that need to keep track of the
current rate this way.

> > > +	int		delay;
> > 
> > Huh? A delay after enabling the clock? Why can't the enable() hook do
> > that if it's really necessary?
> 
> ... which means a separate enable() function for each clock.  The delay
> there has not a lot to do with the actual register you're frobbing, but
> the resy of the SoC.  So, again, not really practical for PXA.

Same thing, extend the struct and use the same enable() function for
all the clocks that need this delay. We can't add fields to the generic
struct clk for every platform quirk out there...

Haavard
