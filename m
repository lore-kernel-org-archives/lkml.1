Return-Path: <linux-kernel-owner+w=401wt.eu-S1758405AbYC0JSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758405AbYC0JSq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 05:18:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753076AbYC0JSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 05:18:36 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55446 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbYC0JSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 05:18:35 -0400
Date: Thu, 27 Mar 2008 09:18:10 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: Dmitry <dbaryshkov@gmail.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, hskinnemoen@atmel.com,
       domen.puncer@telargo.com, lethal@linux-sh.org, tony@atomide.com,
       paul@pwsan.com
Subject: Re: [PATCH 1/3] Clocklib: add generic framework for managing clocks.
Message-ID: <20080327091810.GA32396@flint.arm.linux.org.uk>
References: <20080326154913.GA15326@doriath.ww600.siemens.net> <20080326155203.GA15405@doriath.ww600.siemens.net> <20080326170441.795fb928@hskinnemo-gx620.norway.atmel.com> <bc64b4640803260952s58ad0645ve11766fdfa45e785@mail.gmail.com> <20080327100623.34d92c84@hskinnemo-gx620.norway.atmel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080327100623.34d92c84@hskinnemo-gx620.norway.atmel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2008 at 10:06:23AM +0100, Haavard Skinnemoen wrote:
> > +	int		users;
> 
> Reference counting, probably need that too.
> 
> > +	unsigned long	rate;
> 
> This one is redundant. Use getrate() instead.

... which means a separate getrate() functions for every clock.  Not really
practical for PXA.

> > +	int		delay;
> 
> Huh? A delay after enabling the clock? Why can't the enable() hook do
> that if it's really necessary?

... which means a separate enable() function for each clock.  The delay
there has not a lot to do with the actual register you're frobbing, but
the resy of the SoC.  So, again, not really practical for PXA.

The result for PXA is a tradeoff between reducing the data size and
increasing the text size, or increasing the data size and keeping
the existing data size.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
