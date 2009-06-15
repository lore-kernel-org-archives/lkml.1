Return-Path: <linux-kernel-owner+w=401wt.eu-S1754601AbZFOKDF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601AbZFOKDF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 06:03:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751426AbZFOKCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 06:02:55 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:43183 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbZFOKCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 06:02:54 -0400
Date: Mon, 15 Jun 2009 11:02:53 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ben Dooks <ben-linux@fluff.org>
Cc: Alek Du <alek.du@intel.com>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] gpiolib: Add gpio_detect, gpio_debounce and
	gpio_alt_func features to GPIOLIB
Message-ID: <20090615100253.GC6106@sirena.org.uk>
References: <20090615171502.2a981bf5@dxy.sh.intel.com> <20090615095023.GA19873@fluff.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090615095023.GA19873@fluff.org.uk>
X-Cookie: Prunes give you a run for your money.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 10:50:23AM +0100, Ben Dooks wrote:
> On Mon, Jun 15, 2009 at 05:15:02PM +0800, Alek Du wrote:

> > * gpio_alt_func is to set pin as alternative function or GPIO.

> gpio_alt_func is feature creep, I don't really belive this is the
> best place to put it as it will be difficult to actually make this
> generic for all gpio platforms.

Since the proposed API just passes a value through to the driver for the
GPIO chip it looks generic enough - each chip can define whatever set of
constants it likes.  I'd expect a large proportion of driver specific
APIs would end up just the same.

Given the number of manufacturers that don't use a separate term like
the PXA MFP for the alternative functions of their GPIOs it makes sense
to have a gpiolib API for this.  Without one you end up having each
driver needing to add its own API, and since the pins are just referred
to as GPIOs in the documentation the API will have that in the name and
look like it ought to be connected with gpiolib.
