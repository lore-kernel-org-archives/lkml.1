Return-Path: <linux-kernel-owner+w=401wt.eu-S1946214AbXBIIWB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946214AbXBIIWB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 03:22:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946212AbXBIIWB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 03:22:01 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:53095 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946210AbXBIIWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 03:22:00 -0500
Subject: Re: Network: convert network devices to use struct device instead
	of class_device
From: Kay Sievers <kay.sievers@vrfy.org>
To: Dmitry Torokhov <dtor@insightbb.com>
Cc: Greg KH <greg@kroah.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>
In-Reply-To: <200702082259.47685.dtor@insightbb.com>
References: <200702080400.l1840lFd002314@hera.kernel.org>
	 <d120d5000702080929r7016de12k292add26a0a72291@mail.gmail.com>
	 <20070209005601.GE30794@kroah.com>  <200702082259.47685.dtor@insightbb.com>
Content-Type: text/plain
Date: Fri, 09 Feb 2007 09:22:02 +0100
Message-Id: <1171009322.10605.39.camel@pim.off.vrfy.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:4ddcc9dd12ba6cf3155e4d81b383efda
X-Provags-ID2: V01U2FsdGVkX1/+zxI5N35AamHkd0EkwEuNm1g8Ko2QtJ7Y124lYJbAOgFQU4PybjjtC1SIf2+cnFV3vr9AEC1mf6K/3C12F8wLL6fwRlILfOwOsXE4J4bIcw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-02-08 at 22:59 -0500, Dmitry Torokhov wrote:
> On Thursday 08 February 2007 19:56, Greg KH wrote:
> > On Thu, Feb 08, 2007 at 12:29:12PM -0500, Dmitry Torokhov wrote:
> > > On 2/8/07, Stephen Hemminger <shemminger@linux-foundation.org> wrote:
> > > >On Thu, 08 Feb 2007 07:43:18 -0500

> > > >> >     Network: convert network devices to use struct device instead of 
> > > >class_device
> > > >> >
> > > >> >     This lets the network core have the ability to handle 
> > > >suspend/resume
> > > >> >     issues, if it wants to.
> > > >
> > > >It fixes a non-problem. I would like to see the network core suspend/resume
> > > >proposal as well. Last time I examined doing network core suspend help,
> > > >the problem was that the physical device suspend was called before the
> > > >class device. It is not clear how this change would help.
> > > 
> > > If physical devices are registered before class devices then when
> > > suspending class devices are naturally suspended first. It is still
> > > not clear to me why we need to convert everythign to struct device, I
> > > believe I've shown (with patches) that it is possible to integrate
> > > struct class_device into PM framework and avoid reshuffling half of
> > > the kernel code.
> > 
> > I don't want to have two separate device trees in the kernel (well, one
> > big device tree and a bunch of little class_device trees.)  The code
> > duplication in the class_device code is just too much, and I get
> > questions all the time as to what the differences are.
> >
> 
> While duplication of code is a real concern my worry is constant fattening
> of struct device. For example most physical devices do not interface
> directly with userspace but every single one of them now has dev_t.
> Former class_devices do not need suspend/resume early framework either.
> And so on, and so forth.

The dev_t is a good example for the mess we try to fix here. Not having
a dev_t for "devices" lead to the creation of a lot of otherwise
completely useless "class devices" which are just a total pain to
interpret, and follow the events they create, from userspace.

Things like the scsi_device devices, usb_device devices, ... just exist,
because only this type of devices was allowed to pass information for
device nodes to userspace.

Thanks,
Kay

