Return-Path: <linux-kernel-owner+w=401wt.eu-S1759625AbZFQJhn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759625AbZFQJhn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 05:37:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754446AbZFQJhf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 05:37:35 -0400
Received: from outbound.icp-qv1-irony-out4.iinet.net.au ([203.59.1.150]:30616
	"EHLO outbound.icp-qv1-irony-out4.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754146AbZFQJhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 05:37:34 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Al8CAKNVOEp8qN0Z/2dsb2JhbAAI1CqECwU
X-IronPort-AV: E=Sophos;i="4.42,235,1243785600"; 
   d="scan'208";a="424041707"
Subject: Re: [PATCH v2] gpiolib: Add gpio_debounce and gpio_alt_func
	features to GPIOLIB
From: Ben Nizette <bn@niasdigital.com>
To: Alek Du <alek.du@intel.com>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ben Dooks <ben-linux@fluff.org>, Florian Fainelli <florian@openwrt.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <20090617145955.355ef2a9@dxy.sh.intel.com>
References: <20090615171502.2a981bf5@dxy.sh.intel.com>
	 <20090615125146.GC19873@fluff.org.uk>
	 <200906151504.51934.florian@openwrt.org>
	 <20090615130906.GA14476@trinity.fluff.org>
	 <20090616092848.7bb60f21@dxy.sh.intel.com>
	 <20090616083948.GB14476@trinity.fluff.org>
	 <20090617145955.355ef2a9@dxy.sh.intel.com>
Content-Type: text/plain
Date: Wed, 17 Jun 2009 19:36:44 +1000
Message-Id: <1245231404.2668.9.camel@linux-51e8.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-06-17 at 14:59 +0800, Alek Du wrote:
> Changes from v1:
> 
> Removed gpio_detect since we should do that with irq_chip.set_type function.
> 
> 
> From 6b3c9398acf338c263170fcb74c0b2b345ad5369 Mon Sep 17 00:00:00 2001
> From: Alek Du <alek.du@intel.com>
> Date: Wed, 17 Jun 2009 14:50:51 +0800
> Subject: [PATCH] GPIO: Add gpio_debounce and gpio_alt_func features to GPIOLIB
> 
> Add gpio_debounce and gpio_alt_func features to GPIOLIB:
> * gpio_debounce is to adjust signal HW debounce value (need HW support)
> * gpio_alt_func is to set GPIO as alternative function (need HW support)


Please justify the existence of these functions, particularly, who's
supposed to actually call them?  There's no real changelogging here.

First the hardware debounce call.  Hardware debounce functionality
varies massively between chips.  Therefore a driver cannot depend on any
particular behaviour unless it already knows what platform it's running
on.  If it knows the platform it can access the functions directly and
the interface needs no abstraction.  If the driver doesn't know the
platform it can't get any value from the call.  Worse, people are going
to start /expecting/ some behaviour from the call and wonder why their
driver fails subtly on slightly different systems.

Who's supposed to set the alternate functions?  As I see it, only the
board code.  The driver shouldn't ever have to do this itself, all the
pin mux'ing should be done well before the driver needs to access its
pins.  Even if the driver does need to set up it's own pins then it
needs to know /which/ alternate function it is which once again requires
platform knowledge.  If it requires platform knowledge it should be done
in platform code, not driver code, or can at least be done with
non-abstracted calls.

These both seem like needless feature creep and misdirection to me.

	--Ben.


