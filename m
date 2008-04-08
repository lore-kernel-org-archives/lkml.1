Return-Path: <linux-kernel-owner+w=401wt.eu-S1758087AbYDHUIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758087AbYDHUIV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 16:08:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754633AbYDHUIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 16:08:10 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:53427 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754689AbYDHUIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 16:08:09 -0400
Date: Tue, 8 Apr 2008 21:07:21 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Dmitry <dbaryshkov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       haavard.skinnemoen@atmel.com, lethal@linux-sh.org,
       philipp.zabel@gmail.com, pavel@ucw.cz, tony@atomide.com, paul@pwsan.com
Subject: Re: [PATCH 6/6] Clocklib: use correct name for 3,6MHz clock
Message-ID: <20080408200721.GC18053@flint.arm.linux.org.uk>
References: <20080403132142.GA26882@doriath.ww600.siemens.net> <20080403132411.GA27017@doriath.ww600.siemens.net> <20080407160155.5e6d77f0.akpm@linux-foundation.org> <bc64b4640804080252q6e295eeege7004013406ad3d8@mail.gmail.com> <20080408193502.GB18053@flint.arm.linux.org.uk> <bc64b4640804081258g318b69f7l6d5ea2b38edb53a2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc64b4640804081258g318b69f7l6d5ea2b38edb53a2@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 08, 2008 at 11:58:11PM +0400, Dmitry wrote:
> 2008/4/8, Russell King <rmk+lkml@arm.linux.org.uk>:
> > So... what is the correct name.  Bear in mind what I said in the previous
> >  reply this evening - which says that it should be the name used by the
> >  SA1111.  Look in the data sheet - the pin itself to which the 3.6MHz
> >  clock is supplised will have a name.  That's the name which should be
> >  used.
> 
> I use the same pin/clock for the tc6393xb driver. And I'm pretty sure
> the datasheets won't agree on the name of the pin. Which name should I
> use?

You missed the fundamental issue about the clock API - the _name_ is
not the clock name defined by the host.  It's the _device_ clock name.

So, you shouldn't be using the SA1111 clock name for the tc6393xb driver.
You should be using its own name.  The platform specific bit of the clock
API is then supposed to return you the struct clk corresponding with
that input, by using the platform knowledge that it's connected to GPIO27
or whatever.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
