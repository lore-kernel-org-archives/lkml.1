Return-Path: <linux-kernel-owner+w=401wt.eu-S1759879AbYCZREw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759879AbYCZREw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 13:04:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755284AbYCZREo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 13:04:44 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:63298 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753722AbYCZREn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 13:04:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Xj/hv8R0hvI5tS7vMoaXgJdzpWNXR9Z5DtKQ0pr1HfInENM+FFtbxfIp9dHbN/vnL7GCZ5U2ooCfBBHNWv7qJiYoUB4jsWKG8Pusw7oMIRDdpxOfQfKl9rJyR4sT5hyFe1OYOWKreXnWpUxsFDeaD+m5FyohQ1x7UWiZM7xP0Io=
Message-ID: <bc64b4640803261004t3ac4910bq43a889a6fab350b@mail.gmail.com>
Date: Wed, 26 Mar 2008 20:04:41 +0300
From: Dmitry <dbaryshkov@gmail.com>
To: "Paul Mundt" <lethal@linux-sh.org>,
       "Haavard Skinnemoen" <haavard.skinnemoen@atmel.com>,
       "Dmitry Baryshkov" <dbaryshkov@gmail.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, hskinnemoen@atmel.com, tony@atomide.com,
       rmk+kernel@arm.linux.org.uk, paul@pwsan.com
Subject: Re: [PATCH 1/3] Clocklib: add generic framework for managing clocks.
In-Reply-To: <20080326161456.GA12490@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080326154913.GA15326@doriath.ww600.siemens.net>
	 <20080326155203.GA15405@doriath.ww600.siemens.net>
	 <20080326170441.795fb928@hskinnemo-gx620.norway.atmel.com>
	 <20080326161456.GA12490@linux-sh.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2008/3/26, Paul Mundt <lethal@linux-sh.org>:
> On Wed, Mar 26, 2008 at 05:04:41PM +0100, Haavard Skinnemoen wrote:
>  > On Wed, 26 Mar 2008 18:52:03 +0300
>  > Dmitry Baryshkov <dbaryshkov@gmail.com> wrote:
>  >
>  > > +struct clk {
>  > > +   struct list_head node;
>  > > +   struct clk      *parent;
>  > > +
>  > > +   const char      *name;
>  > > +   struct module   *owner;
>  > > +
>  > > +   int             users;
>  > > +   unsigned long   rate;
>  > > +   int             delay;
>  > > +
>  > > +   int (*can_get)  (struct clk *, struct device *);
>  > > +   int (*set_parent) (struct clk *, struct clk *);
>  > > +   int (*enable)   (struct clk *);
>  > > +   void (*disable) (struct clk *);
>  > > +   unsigned long (*getrate) (struct clk*);
>  > > +   int (*setrate)  (struct clk *, unsigned long);
>  > > +   long (*roundrate) (struct clk *, unsigned long);
>  > > +
>  > > +   void            *priv;
>  > > +};
>  >
>  > Hmm...this is exactly twice as big as the struct I'm currently using,
>  > it doesn't contain all the fields I need, and it's undocumented.
>  >
>
> Conversely it also has fields that I don't need. If struct clk could have
>  been done generically without growing to insane sizes, it would have been
>  done so in linux/clk.h a long time ago. The main thing there is API
>  consistency for drivers, leaving the details up to the architecture.

In reality, as noted David Brownell on LAKML, there is no API consistency.
The driver has no way to know whether clk API is implemented at all or whether
the "optional" functions do exist.

Moreover clocks aren't limited only to platform-specific code. As an
example of the in-tree driver that will benefit from clocklib you can
check drivers/mfd/sm501.c which  contains  it's own set of functions
to manage clocks.

>  It's true that there is significant overlap between the different users
>  of the clock framework, but it's also not clear that there's any clean
>  way to share a common implementation (especially since struct clk means
>  totally different things on different architectures). I suspect everyone
>  in the CC list has been through this before, also.

That's one of the initial reasons of this patchserie: I have a device
that can be installed on several platforms. And I want for this device
to provide clocks to some other devices.

Simply saying "Oh, things are different" is behaving like a ostrich:
hiding a head in the sand.

As most generification patches do, this one has it's drawbacks, but
they are not so big, as you describe.

-- 
With best wishes
Dmitry
