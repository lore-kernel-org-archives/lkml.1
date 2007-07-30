Return-Path: <linux-kernel-owner+w=401wt.eu-S936286AbXG3Xdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936286AbXG3Xdt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 19:33:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760741AbXG3Xdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 19:33:40 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:59531 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758783AbXG3Xdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 19:33:39 -0400
Subject: Re: forcedeth ?
From: Kay Sievers <kay.sievers@vrfy.org>
To: Sasa Ostrouska <casaxa@gmail.com>
Cc: Gabriel C <nix.or.die@googlemail.com>, Avuton Olrich <avuton@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <dcf706c60707301610o50809672l622ed3da59670708@mail.gmail.com>
References: <dcf706c60707301301j21d3cf60n59a686c9abb5e5b3@mail.gmail.com>
	 <3aa654a40707301337w52bbe246o99db15b9f8e7a2c4@mail.gmail.com>
	 <dcf706c60707301426q4858d039hdfa49fb26835d367@mail.gmail.com>
	 <46AE6029.60308@googlemail.com>
	 <dcf706c60707301510n6c2b649p447396fc042c25e5@mail.gmail.com>
	 <3ae72650707301522r4241353ld1be5dd7a2322233@mail.gmail.com>
	 <46AE63F6.9060108@googlemail.com>
	 <1185835218.1911.64.camel@lov.localdomain>
	 <dcf706c60707301610o50809672l622ed3da59670708@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 31 Jul 2007 01:36:12 +0200
Message-Id: <1185838572.1911.73.camel@lov.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.5 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX18mo2Y0wAnfiZAd9Qo/mNmOgzczhIq2wnLvIvO
 Yz2yT6aD1aIg5pjYPskOji/T/7ZiQTOCLLT6coCBZmkYZwEGwp
 0hO8QCQTfCRowcYe3SAhijSBxyhnvuD
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-31 at 01:10 +0200, Sasa Ostrouska wrote:
> On 7/31/07, Kay Sievers <kay.sievers@vrfy.org> wrote:
> >
> > On Tue, 2007-07-31 at 00:19 +0200, Gabriel C wrote:
> > > Kay Sievers wrote:
> > > > On 7/31/07, Sasa Ostrouska <casaxa@gmail.com> wrote:
> > > >> On 7/31/07, Gabriel C <nix.or.die@googlemail.com> wrote:
> > > >>> Sasa Ostrouska wrote:
> > > >>>> On 7/30/07, Avuton Olrich <avuton@gmail.com> wrote:
> > > >>>>> On 7/30/07, Sasa Ostrouska <casaxa@gmail.com> wrote:
> > > >>>>>> Hi people,
> > > >>>>>>
> > > >>>>>> I'm using this on a x86-64 amd machine. During boot of the last
> > > >>>>>> 2.6.22.1 kernel I get this error:
> > > >>>>> Somewhat unrelated, but I had a similar forcedeth problem, I took the
> > > >>>>> latest git forcedeth.c and put it into 2.6.22.1 and it worked for me.
> > > >>>>>
> > > >>>>> Good luck!
> > > >>>>> --
> > > >>>>> avuton
> > > >>>> Ok, maybe I can try that. In any case I noticed another strange thing.
> > > >>>> I have 2 nics in that machine.
> > > >>>> One is a nvidia MPC61 using the forcedeth.c the other one is a Realtec
> > > >>>> RTL8029 using the
> > > >>>> ne2k_pci.
> > > >>>> Now, whenever I compile them both as modules each reboot the cards get
> > > >>>> inversed eth assignement. Suppose first boot, the forcedeth is eth0 ,
> > > >>>> the next boot it is eth1 , this is very anoying as one cant make only
> > > >>>> one boot, probably this is someway related to the bios.
> > > >>>> Now I configured them one in the kernel and the other as a module so
> > > >>>> they get each time assigned the same name. But when powerloss happens
> > > >>>> (unplug the cable) the next boot they do not work. I see them assigned
> > > >>>> the correct name, ifconfig shows the IP's but ping results in a
> > > >>>> destination unreachable.
> > > >>>>
> > > >>>> Any ideas ?
> > > >>> Udev rules ?
> > > >>>
> > > >> Gabriel, hmm, shouldnt udev be able to autoconfigure that ? But I need
> > > >> to check that, thx for the tip.
> > > >
> > > > Udev does that already, it automatically creates rules and assigns
> > > > persistent names to newly discovered network hardware. The names will
> > > > be stable across reboots, regardless of module loading order or
> > > > anything else. But sure, that's only on distros who take these issues
> > > > serious. :)
> > >
> > > Yes but the rules are based on the MAC address no ?
> >
> > The automatic rule creator, uses MAC addresses by default, yes. There
> > have been extensions for S/390 support recently, to create other sorts
> > of matching rules.
> >
> > The rules that rename the interface, are not limited in any way, and can
> > match on any property of the device, they are just not created
> > automatically today, but can be specified manually.
> >
> > Maybe the network susbsytem should let us know in the event environment,
> > that a random MAC was created, so we can automatically create rules that
> > uses the path to the hardware as a match instead.
> >
> > Thanks,
> > Kay
> >
> And why not just use the PCI ID instead of the MAC address ?

PCI ID's? And when you have multiple identical cards like every other
server has?

You could use the slot number and such, but _usually_ the MAC address is
what you want because it is unique by itself. The MAC is just the best
default in most cases, because it usually identifies the connector where
the cable goes in ...

Udev computes the path to the device, like used in
the /dev/disk/by-path/ links, that could be used as a stable identifier,
but still, to use that automatically, the kernel would need to let us
know, that we shouldn't use the random MAC.

Kay

