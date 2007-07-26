Return-Path: <linux-kernel-owner+w=401wt.eu-S1752242AbXGZAPs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242AbXGZAPs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 20:15:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755526AbXGZAPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 20:15:38 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:57206 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755511AbXGZAPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 20:15:37 -0400
Subject: Re: sysfs/udev broken in 2.6.23-rc1 [input, i2c, ...] (Was:
	sysfs/udev broken in latest git?)
From: Kay Sievers <kay.sievers@vrfy.org>
To: Greg KH <gregkh@suse.de>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>, Simon Arlott <simon@fire.lp0.eu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20070726001145.GC21056@suse.de>
References: <20070724072540.GA835@suse.de>
	 <20070724100314.3c606131@gondolin.boeblingen.de.ibm.com>
	 <20070724084654.GB13152@suse.de>
	 <3ae72650707240220l737fb031hb4e326b0f1fe0e45@mail.gmail.com>
	 <20070724145433.4848ada1@gondolin.boeblingen.de.ibm.com>
	 <46A628AC.3060900@simon.arlott.org.uk>
	 <3ae72650707240934o68047677n97e6081ff3f42ce7@mail.gmail.com>
	 <46A62F6A.8010403@simon.arlott.org.uk>
	 <3ae72650707241719w6c7f2dc7s1bc29d7f1dfd4288@mail.gmail.com>
	 <20070725095808.09b2cc2a@gondolin.boeblingen.de.ibm.com>
	 <20070726001145.GC21056@suse.de>
Content-Type: text/plain
Date: Thu, 26 Jul 2007 02:17:50 +0200
Message-Id: <1185409070.3960.4.camel@lov.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.5 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/c+x0sC1qs0Vm2WcDNTxW2VS/e4TCdBdSdTFo
 F7s+5T0sqTz6S4P4VAm3WDkp4XaclIIVJDM1/8k3oGrLuzGr5g
 URasLEnq3sDmCK19/t95bwdvdjXJ7uL
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2007-07-25 at 17:11 -0700, Greg KH wrote:
> On Wed, Jul 25, 2007 at 09:58:08AM +0200, Cornelia Huck wrote:
> > On Wed, 25 Jul 2007 02:19:18 +0200,
> > "Kay Sievers" <kay.sievers@vrfy.org> wrote:
> > 
> > > > >> Removing the dev->parent->bus check fixes it:
> > > 
> > > Yes, let's remove the check, I will check now if we possibly need to
> > > fix more than this or only the block-device patch.
> > 
> > It seems this is the only place we check for dev->parent->bus in the
> > current git tree.
> > 
> > Patch below.
> 
> Thanks for figuring this out, I'll add this to my tree.
> 
> So what is the input layer doing so differently from everyone else here?
> Is it correct?  (sorry, am at a conference this week, so can't dig into
> it as much as I would like to until Friday...)

It was the only place where we stacked (had a hierarchy of) class
devices. We got a class device being a child of another class device.

We never did anything like that and it was the reason to go for a
unified tree at /sys/devices/ instead of putting small hierarchy trees
all over the place, which can never be changed later, as they are the
defined entry points into the device tree.

Kay

