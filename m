Return-Path: <linux-kernel-owner+w=401wt.eu-S1759844AbYDKK0B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759844AbYDKK0B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 06:26:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758240AbYDKKZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 06:25:54 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:13268 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758119AbYDKKZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 06:25:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=AyzsEu4cfdBCF4FGngZQcIfhBANaOERI7Aw/revImIuchXDt0FhQOJ43kO4qcZb7OcQDJndfoKU1TxI6eXzZe5mh+RFFEz0BC7enZKwdV3beGc8WHuOJxV/upsm2TSJ+JW6HPaHcrJoo0uyfKYO3GvxS0GVuw/sIQyzVJLF0Gr8=
Date: Fri, 11 Apr 2008 14:25:40 +0400
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       haavard.skinnemoen@atmel.com, lethal@linux-sh.org,
       philipp.zabel@gmail.com, pavel@ucw.cz, tony@atomide.com, paul@pwsan.com
Subject: Re: [PATCH 6/6] Clocklib: use correct name for 3,6MHz clock
Message-ID: <20080411102540.GA27815@doriath.ww600.siemens.net>
References: <20080403132142.GA26882@doriath.ww600.siemens.net> <20080403132411.GA27017@doriath.ww600.siemens.net> <20080407160155.5e6d77f0.akpm@linux-foundation.org> <bc64b4640804080252q6e295eeege7004013406ad3d8@mail.gmail.com> <20080408193502.GB18053@flint.arm.linux.org.uk> <bc64b4640804081258g318b69f7l6d5ea2b38edb53a2@mail.gmail.com> <20080408200721.GC18053@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080408200721.GC18053@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Apr 08, 2008 at 09:07:21PM +0100, Russell King wrote:
> On Tue, Apr 08, 2008 at 11:58:11PM +0400, Dmitry wrote:
> > 2008/4/8, Russell King <rmk+lkml@arm.linux.org.uk>:
> > > So... what is the correct name.  Bear in mind what I said in the previous
> > >  reply this evening - which says that it should be the name used by the
> > >  SA1111.  Look in the data sheet - the pin itself to which the 3.6MHz
> > >  clock is supplised will have a name.  That's the name which should be
> > >  used.
> > 
> > I use the same pin/clock for the tc6393xb driver. And I'm pretty sure
> > the datasheets won't agree on the name of the pin. Which name should I
> > use?
> 
> You missed the fundamental issue about the clock API - the _name_ is
> not the clock name defined by the host.  It's the _device_ clock name.
> 
> So, you shouldn't be using the SA1111 clock name for the tc6393xb driver.
> You should be using its own name.  The platform specific bit of the clock
> API is then supposed to return you the struct clk corresponding with
> that input, by using the platform knowledge that it's connected to GPIO27
> or whatever.

BTW: Who should know that there should be a clock for a device?
E.g. on pxa, 3.6MHz clock is registered in clock.c, various CKEN-based
clocks are registered from pxa*.c. Which file should contain
host_name -> device_name allocation board config?


And BTW2: The sa1111 spec names the clock simply as "CLK". Should we use
this name?


-- 
With best wishes
Dmitry

