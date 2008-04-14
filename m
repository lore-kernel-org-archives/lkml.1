Return-Path: <linux-kernel-owner+w=401wt.eu-S1760530AbYDNINr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760530AbYDNINr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 04:13:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758263AbYDNIN3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 04:13:29 -0400
Received: from mx2.suse.de ([195.135.220.15]:49902 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755901AbYDNIN1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 04:13:27 -0400
Subject: Re: sata_via
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: Tejun Heo <htejun@gmail.com>
Cc: Rich West <Rich.West@wesmo.com>, Jeff Garzik <jeff@garzik.org>,
       Wander Winkelhorst <w.winkelhorst@gmail.com>,
       linux-kernel@vger.kernel.org,
       Linux IDE mailing list <linux-ide@vger.kernel.org>,
       Peter Gervai <grinapo@gmail.com>, Marin Mitov <mitov@issp.bas.bg>
In-Reply-To: <1208133587.2755.8.camel@htj.dyndns.org>
References: <47F694C8.8020507@wesmo.com> <47F6A5E8.1030602@garzik.org>
	 <47F6BD55.3090708@wesmo.com>
	 <5699f8f00804050015kb1ebb1cpf3ab8b587580fffd@mail.gmail.com>
	 <47F7982E.5080701@wesmo.com> <47F7F463.2060402@garzik.org>
	 <480173CB.5070805@gmail.com> <480189DB.9050900@wesmo.com>
	 <48018DC0.6080407@wesmo.com>  <1208133587.2755.8.camel@htj.dyndns.org>
Content-Type: text/plain
Organization: Novell/SUSE
Date: Mon, 14 Apr 2008 10:13:22 +0200
Message-Id: <1208160803.1784.14.camel@queen.suse.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-04-14 at 09:39 +0900, Tejun Heo wrote:
> Hi,
> 
> On Sun, 2008-04-13 at 00:36 -0400, Rich West wrote:
> > Rich West wrote:
> > > Tejun Heo wrote:
> > >> Jeff Garzik wrote:
> > >>> Rich West wrote:
> > >>>> I was only curious as to what turning off power management support 
> > >>>> would buy with regard to the sata timeout issue.
> > >>>
> > >>>
> > >>> ACPI is not only power management.  It is all the information your 
> > >>> hardware conveys to your OS, about the setup and workings of your 
> > >>> hardware.
> > >>>
> > >>> Without ACPI, non-PM things like SMP, laptop dock/undock, and many 
> > >>> other gadgets fail to function (or are configured sub-optimally).
> > >>>
> > >>> ACPI sets up interrupt routing, and Linux history is _loaded_ with 
> > >>> _years_ of problem reports that appear as timeouts, only to be 
> > >>> resolved as ACPI interrupt bugs (aka BIOS bugs, since ACPI tables 
> > >>> come from BIOS).
> > >>
> > >> Also, please give a shot at the sacred "irqpoll".
> > >
> > > I've had bad luck in the past (with other machiens) when adding 
> > > "irqpoll" in that it had locked up the entire machine (not this one, 
> > > but others) after a very short period of time.  My only attempt at 
> > > using it, though, was to try to address an X server related issue, but 
> > > this is a non-user machine, so X isn't necessary, and, hence, it's at 
> > > runlevel 3 all of the time.
> > >
> > > So far, noapic and acpi=off seem to be working.. The system has been 
> > > up 8 days without any problems.. previously, a problem with the SATA 
> > > drive (details of which were part of the first few messages in this 
> > > thread) would surface anywhere between 15 minutes and 5-7 days after a 
> > > reboot.
> > >
> > > However, since I started this email, I tried firing up X (with noapci 
> > > and acpi=off both set), the machine locks up entirely.
> > 
> > Although a reboot with irqpoll set managed to fix that X problem. :)
> > 
> 
> IRQ routing seems hosed on your machine.  Thomas any ideas?

Not really.
First, I'd try to be able to reproduce this more quickly, an IO
benchmark or similar (bonnie?).


----------------------------------------------
Peter Gervai posted a similar report recently, Elias Oltmanns had an
idea (on linux-ide or linux-acpi list):
Subject: Re: Hard freeze / interrupt-related death / instability
Wed, 09 Apr 2008

(but Tejun was already involved into that, at least in the link posted
there, but reading it up might be worth it).
Is this the same problem?

----------------------------------------------
Marin Mitov answered in this thread (only answering to lkml, truncating
the CC list..., got overseen?):
Hi Rich,

What is the output of command:

grep CONFIG_IRQBALANCE .config

If:

CONFIG_IRQBALANCE=y

try disabling it.
----------------------------------------------


   Thomas

