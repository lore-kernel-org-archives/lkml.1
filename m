Return-Path: <linux-kernel-owner+w=401wt.eu-S1756762AbXL2TDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762AbXL2TDU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 14:03:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753253AbXL2TDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 14:03:13 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:52215 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735AbXL2TDM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 14:03:12 -0500
Date: Sat, 29 Dec 2007 20:03:09 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: David Brownell <david-b@pacbell.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Jean Delvare <khali@linux-fr.org>, eric miao <eric.y.miao@gmail.com>
Subject: Re: [patch 2.6.24-rc6-mm 1/9] gpiolib: add drivers/gpio directory
Message-ID: <20071229190309.GB20099@uranus.ravnborg.org>
References: <200712281927.32575.david-b@pacbell.net> <200712281953.20103.david-b@pacbell.net> <20071229065837.GB16569@uranus.ravnborg.org> <200712291019.39969.david-b@pacbell.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712291019.39969.david-b@pacbell.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 29, 2007 at 10:19:39AM -0800, David Brownell wrote:
> On Friday 28 December 2007, Sam Ravnborg wrote:
> > kconfig symbols that are "select" targets should be named "HAVE_" so in
> > this case you could use HAVE_GPIO_LIB.
> > This is by convention only but introduced to make it visible that this is
> > a config symbol supposed to be selected.
> 
> Not widely adopted yet, but of course such things take time.

Yes - which is why I am a bit more careful to note it.
> 
> 
> > Then on top of that the HAVE_ symbols should not have any dependencies
> > so we avoid that "select" selects a symbol where the dependencies are
> > not fulfilled.
> 
> That limitation of "select" still seems more buglike to me than
> anything else, FWIW.  Not that it matters in this case.
But I had not yet figured out how to fix it - and limiting select
to symbols without dependencies avoid the worst offendes/abusers.

> Pretty much like the folowing, then?
> 
>   - Use "ccflags-$(CONGIF_DEBUG_GPIO) += -DDEBUG" instead of
>     those ugly (but traditional) conditionals.

s/CONGIF/CONFIG/


>  
> +ccflags-$(CONGIF_DEBUG_GPIO)	+= -DDEBUG
> +
s/CONGIF/CONFIG/

Otherwise OK.

	Sam
