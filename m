Return-Path: <linux-kernel-owner+w=401wt.eu-S1753815AbXHDEgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815AbXHDEgf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 00:36:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751600AbXHDEg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 00:36:27 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:52124
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbXHDEg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 00:36:26 -0400
Date: Fri, 3 Aug 2007 21:33:25 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: Ondrej Zajicek <santiago@crfreenet.org>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Michael Tokarev <mjt@tls.msk.ru>,
       Herbert Rosmanith <kernel@wildsau.enemy.org>,
       linux-kernel@vger.kernel.org
Subject: Re: renaming kernel devices [was: VIA EPIA EK: strange eth dev
 numbering]
In-Reply-To: <46B345E1.1010404@s5r6.in-berlin.de>
Message-ID: <Pine.LNX.4.64.0708032127010.6905@asgard.lang.hm>
References: <200708021056.l72Au722008603@wildsau.enemy.org>
 <46B1BEB8.70104@msgid.tls.msk.ru> <Pine.LNX.4.64.0708021346300.24572@fbirervta.pbzchgretzou.qr>
 <20070802145152.GB19346@localhost.localdomain> <Pine.LNX.4.64.0708022144020.6905@asgard.lang.hm>
 <46B345E1.1010404@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Aug 2007, Stefan Richter wrote:

> david@lang.hm wrote:
>> On Thu, 2 Aug 2007, Ondrej Zajicek wrote:
>>> On Thu, Aug 02, 2007 at 01:47:23PM +0200, Jan Engelhardt wrote:
>>>> It does not rename ethX to the "next free" one, but to a _persistent_ one.
>>>> If it were a "next free" thing, then removing a card would shuffle all
>>>> your eth around again (and invalidate your iptables rules at the same
>>>> time, to note).
>>>
>>> It is questionable what is _persistent_ . MAC-based names are persistent
>>> with regard to adding and removing of other cards, 'Plain' names are persistent
>>> with regard to replacing that card with different item (of a same kind).
>>>
>>> I am very happy that (using 'plain' names) i can send technician to
>>> replace broken NIC in our routers without need for configuration
>>> change.
>>
>> this is a very important point, and with the distros (and many kernel
>> people) treating udev as a requirement this is going to bite a lot of
>> people.
>
> Two notes:
>
>  1. Udev doesn't restrict you to any one naming scheme.  If you want
> something else than a MAC based scheme, e.g. a PCI topology based
> scheme, udev most certainly can do that for you.  But the kernel can't.
>
>  2. Consider udev a kernel extension in userspace, with the benefit of
> configurability and scriptability, features that kernel extensions in
> kernelspace can't offer.  Of course this gain of features doesn't come
> at zero cost:  You need a minimal userspace environment at boot time.
>
> Quoting myself from http://marc.info/?l=linux-scsi&m=118613786003162:
>
> There is a variety of possible naming schemes:
>
>  - Naming by order of discovery.
>  - Naming by vendor/model name strings.
>  - Naming by universally unique identifier.
>  - Naming by topology.
>  - ...
>
> Only the simplest of these schemes (naming by order of discovery) is
> hardwired into the kernel portion of the Linux OS.  The other naming
> schemes are (or can be) implemented in the userland portion of the Linux OS.
>
> There is only the most primitive naming scheme implemented in the kernel
> because naming policy, like most other kinds of policy, is better left
> to userland.  The kernel is a too restricted framework to implement such
> things.  The kernel lacks runtime-configuration files, scripting
> interfaces, et cetera.

I understand the flexibility that this provides, unfortunantly (IMHO) 
default udev rules (or at least what many distros are shipping by default) 
changes from this simple naming scheme in a way that hides the fact from 
the user. This means that many users will not even realize the change in 
policy until the hardware changes and things don't act the way they were 
expected to. In my case it was removing 3 quad cards from a machine and 
finding that there was no eth0 on the box, instead there was a eth12, this 
is fairly benign. what would have caused me significant problems would 
have been having a card fail in a production box, have it replaced and 
then found that the interfaces were now eth4-eth22 instead of eth0-eth18. 
having the interfaces named differently on different boxes with identical 
hardware based on the history of what has been plugged into the boxes in 
the past is not what sysadmins expect.

David Lang
