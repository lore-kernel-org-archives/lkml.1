Return-Path: <linux-kernel-owner+w=401wt.eu-S1763612AbXHCPMp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763612AbXHCPMp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 11:12:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762804AbXHCPMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 11:12:36 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:51457 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762282AbXHCPMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 11:12:35 -0400
Message-ID: <46B345E1.1010404@s5r6.in-berlin.de>
Date: Fri, 03 Aug 2007 17:12:33 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.5) Gecko/20070716 SeaMonkey/1.1.3
MIME-Version: 1.0
To: david@lang.hm
CC: Ondrej Zajicek <santiago@crfreenet.org>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Michael Tokarev <mjt@tls.msk.ru>,
       Herbert Rosmanith <kernel@wildsau.enemy.org>,
       linux-kernel@vger.kernel.org
Subject: Re: renaming kernel devices [was: VIA EPIA EK: strange eth dev numbering]
References: <200708021056.l72Au722008603@wildsau.enemy.org> <46B1BEB8.70104@msgid.tls.msk.ru> <Pine.LNX.4.64.0708021346300.24572@fbirervta.pbzchgretzou.qr> <20070802145152.GB19346@localhost.localdomain> <Pine.LNX.4.64.0708022144020.6905@asgard.lang.hm>
In-Reply-To: <Pine.LNX.4.64.0708022144020.6905@asgard.lang.hm>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

david@lang.hm wrote:
> On Thu, 2 Aug 2007, Ondrej Zajicek wrote:
>> On Thu, Aug 02, 2007 at 01:47:23PM +0200, Jan Engelhardt wrote:
>>> It does not rename ethX to the "next free" one, but to a _persistent_ one.
>>> If it were a "next free" thing, then removing a card would shuffle all
>>> your eth around again (and invalidate your iptables rules at the same
>>> time, to note).
>>
>> It is questionable what is _persistent_ . MAC-based names are persistent
>> with regard to adding and removing of other cards, 'Plain' names are persistent
>> with regard to replacing that card with different item (of a same kind).
>>
>> I am very happy that (using 'plain' names) i can send technician to
>> replace broken NIC in our routers without need for configuration
>> change.
> 
> this is a very important point, and with the distros (and many kernel 
> people) treating udev as a requirement this is going to bite a lot of 
> people.

Two notes:

  1. Udev doesn't restrict you to any one naming scheme.  If you want
something else than a MAC based scheme, e.g. a PCI topology based
scheme, udev most certainly can do that for you.  But the kernel can't.

  2. Consider udev a kernel extension in userspace, with the benefit of
configurability and scriptability, features that kernel extensions in
kernelspace can't offer.  Of course this gain of features doesn't come
at zero cost:  You need a minimal userspace environment at boot time.

Quoting myself from http://marc.info/?l=linux-scsi&m=118613786003162:

There is a variety of possible naming schemes:

  - Naming by order of discovery.
  - Naming by vendor/model name strings.
  - Naming by universally unique identifier.
  - Naming by topology.
  - ...

Only the simplest of these schemes (naming by order of discovery) is
hardwired into the kernel portion of the Linux OS.  The other naming
schemes are (or can be) implemented in the userland portion of the Linux OS.

There is only the most primitive naming scheme implemented in the kernel
because naming policy, like most other kinds of policy, is better left
to userland.  The kernel is a too restricted framework to implement such
things.  The kernel lacks runtime-configuration files, scripting
interfaces, et cetera.
-- 
Stefan Richter
-=====-=-=== =--- ---==
http://arcgraph.de/sr/
