Return-Path: <linux-kernel-owner+w=401wt.eu-S1758945AbZFPBel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758945AbZFPBel (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 21:34:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751548AbZFPBed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 21:34:33 -0400
Received: from mga14.intel.com ([143.182.124.37]:13012 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751428AbZFPBec (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 21:34:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,225,1243839600"; 
   d="scan'208";a="154793590"
Date: Tue, 16 Jun 2009 09:28:48 +0800
From: Alek Du <alek.du@intel.com>
To: Ben Dooks <ben-linux@fluff.org>
CC: Florian Fainelli <florian@openwrt.org>, Ben Dooks <ben-linux@fluff.org>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] gpiolib: Add gpio_detect, gpio_debounce and
 gpio_alt_func features to GPIOLIB
Message-ID: <20090616092848.7bb60f21@dxy.sh.intel.com>
In-Reply-To: <20090615130906.GA14476@trinity.fluff.org>
References: <20090615171502.2a981bf5@dxy.sh.intel.com>
	<20090615125146.GC19873@fluff.org.uk>
	<200906151504.51934.florian@openwrt.org>
	<20090615130906.GA14476@trinity.fluff.org>
Organization: Intel Corp.
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Jun 2009 21:09:06 +0800
Ben Dooks <ben-linux@fluff.org> wrote:

> > 
> > I would expect your architecture IRQ handler to have a set_type callback for 
> > the GPIO lines capables of generating an interrupt. See how we have beeing 
> > doing it for rb532 for instance: 
> > http://www.linux-mips.org/git?p=linux-queue.git;a=blob;f=arch/mips/rb532/irq.c;h=f07882029a90d3d155c17b462812c2936229458c;hb=HEAD#l173
> 
> Yes, or if the GPIO driver is exporting interrupts, the relevant handler
> for that chip should have the .set_type method defined.
> 

In the .set_type method, you finally will call the GPIO driver's function to set interrupt trigger mode, right?
Current GPIOLIB do not provide such an interface. Current driver always exports a separate function to do that --
that's not good.
My patch provide a general API to do that.


Thanks,
Alek
