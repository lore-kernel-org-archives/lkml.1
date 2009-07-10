Return-Path: <linux-kernel-owner+w=401wt.eu-S1756777AbZGJThs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777AbZGJThs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 15:37:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753725AbZGJThk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 15:37:40 -0400
Received: from senator.holtmann.net ([87.106.208.187]:38992 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483AbZGJThj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 15:37:39 -0400
Subject: Re: [2.6.31-rc2] Writing to /sys/class/rfkill/*/state fails
From: Marcel Holtmann <marcel@holtmann.org>
To: Corentin Chary <corentin.chary@gmail.com>
Cc: Thiemo Nagel <thiemo.nagel@ph.tum.de>,
       Johannes Berg <johannes@sipsolutions.net>,
       debian-eeepc-devel@lists.alioth.debian.org,
       acpi4asus-user@lists.sourceforge.net, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <71cd59b00907101234w772dc141kff52c7393e698e17@mail.gmail.com>
References: <4A5716AA.5000903@ph.tum.de>
	 <71cd59b00907100545v6f440a19xfc3668826eb1e509@mail.gmail.com>
	 <4A5743AB.6090303@ph.tum.de>
	 <71cd59b00907100646h5e0283fcyce5874cc4a19106b@mail.gmail.com>
	 <4A575119.9070505@ph.tum.de> <507E3B9268%linux@youmustbejoking.demon.co.uk>
	 <71cd59b00907101234w772dc141kff52c7393e698e17@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 10 Jul 2009 12:37:42 -0700
Message-Id: <1247254662.9709.91.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 (2.26.2-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Corentin,

> > I demand that Thiemo Nagel may or may not have written...
> >
> >> Corentin Chary wrote:
> >>> On Fri, Jul 10, 2009 at 3:35 PM, Thiemo Nagel<thiemo.nagel@ph.tum.de>
> >>> wrote:
> >>>> Corentin Chary wrote:
> >>>>> On Fri, Jul 10, 2009 at 12:23 PM, Thiemo
> >>>>> Nagel<thiemo.nagel@ph.tum.de> wrote:
> >>>>>> I just tested the new GSM rfkill in 2.6.31-rc2 and I get the following
> >>>>>> on my EeePC 1000HGO:
> >>>>>>   eee:/# cat /sys/class/rfkill/rfkill2/name
> >>>>>>   eeepc-wwan3g
> >>>>>>   eee:/# echo 0 > /sys/class/rfkill/rfkill2/state
> >>>>>>   bash: echo: write error: Operation not permitted
> >>>>>> What could be the reason for that?
> >>>>> Reading the kernel source I can find:
> >>>>>         /*
> >>>>>          * The intention was that userspace can only take control over
> >>>>>          * a given device when/if rfkill-input doesn't control it due
> >>>>>          * to user_claim. Since user_claim is currently unsupported,
> >>>>>          * we never support changing the state from userspace -- this
> >>>>>          * can be implemented again later.
> >>>>>          */
> >>>>> It seems that rfkill should be controlled by /dev/rfkill (cf
> >>>>> Documentation/rfkill.txt).
> >>>>> Maybe network-manager can control that .. But I'm not sure.
> >>>>> Maybe you should CC the wireless mailing list.
> >>>> Thanks for the quick reply.  The interesting thing is, that the direct
> >>>> access works well for eeepc-wlan and eeepc-bluetooth rfkills.  I've CC'd
> >>>> debian-eeepc-devel, maybe they know something.
> >>> Are you sure that it works with newer kernels ?
> >>> This commit should have broken it for all rfkill.
> >>>   commit 19d337dff95cbf76edd3ad95c0cee2732c3e1ec5
> >>>   Author: Johannes Berg <johannes@sipsolutions.net>
> >>>   Date:   Tue Jun 2 13:01:37 2009 +0200
> >
> >> You're right, all rfkills work with 2.6.30, but none works with 2.6.31-rc2.
> >
> > This is the first that I've heard of this. I'd not noticed since I've not
> > needed Bluetooth on my 901 recently.
> >
> >> For the debian-eeepc folks:  2.6.31-rc2 breaks bluetooth toggling using
> >> eeepc-acpi-scripts, but WLAN toggling still works.
> >
> > FSVO "works" (http://bugzilla.kernel.org/show_bug.cgi?id=13390), but that's a
> > different problem.
> >
> > I consider this a regression. It breaks an interface which, though flawed, is
> > ideally suited for scripting use and which eeepc-acpi-scripts uses in shell
> > scripts.
> >
> > /dev/rfkill is not useful in shell scripts.
> 
> Maybe it would be possible with an rfkill command line tool (in C) ?
> Is there such a tool somewhere ?

yes there is:

http://git.sipsolutions.net/?p=rfkill.git

Regards

Marcel


