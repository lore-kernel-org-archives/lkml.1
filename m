Return-Path: <linux-kernel-owner+w=401wt.eu-S932693AbXHDRKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932693AbXHDRKV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 13:10:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932130AbXHDRKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 13:10:09 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:48062
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932092AbXHDRKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 13:10:07 -0400
Date: Sat, 4 Aug 2007 10:06:56 -0700 (PDT)
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
In-Reply-To: <46B443E5.2020404@s5r6.in-berlin.de>
Message-ID: <Pine.LNX.4.64.0708040952420.6905@asgard.lang.hm>
References: <200708021056.l72Au722008603@wildsau.enemy.org>
 <46B1BEB8.70104@msgid.tls.msk.ru> <Pine.LNX.4.64.0708021346300.24572@fbirervta.pbzchgretzou.qr>
 <20070802145152.GB19346@localhost.localdomain> <Pine.LNX.4.64.0708022144020.6905@asgard.lang.hm>
 <46B345E1.1010404@s5r6.in-berlin.de> <Pine.LNX.4.64.0708032127010.6905@asgard.lang.hm>
 <46B443E5.2020404@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 4 Aug 2007, Stefan Richter wrote:

> david@lang.hm wrote:
>> On Fri, 3 Aug 2007, Stefan Richter wrote:
>>> There is a variety of possible naming schemes:
>>>
>>>  - Naming by order of discovery.
>>>  - Naming by vendor/model name strings.
>>>  - Naming by universally unique identifier.
>>>  - Naming by topology.
>>>  - ...
>>>
>>> Only the simplest of these schemes (naming by order of discovery)
>
> (which is in most cases also the scheme that's the least useful to
> admins and users)
>
>>> is hardwired into the kernel portion of the Linux OS.  The other naming
>>> schemes are (or can be) implemented in the userland portion of the
>>> Linux OS.
> ...
>> I understand the flexibility that this provides, unfortunantly (IMHO)
>> default udev rules (or at least what many distros are shipping by
>> default) changes from this simple naming scheme in a way that hides the
>> fact from the user. This means that many users will not even realize the
>> change in policy until the hardware changes and things don't act the way
>> they were expected to. In my case it was removing 3 quad cards from a
>> machine and finding that there was no eth0 on the box, instead there was
>> a eth12, this is fairly benign. what would have caused me significant
>> problems would have been having a card fail in a production box, have it
>> replaced and then found that the interfaces were now eth4-eth22 instead
>> of eth0-eth18. having the interfaces named differently on different
>> boxes with identical hardware based on the history of what has been
>> plugged into the boxes in the past is not what sysadmins expect.
>
> Yes, these rules by far don't fit everyone's needs.  People who often
> use hotpluggable NICs are probably served best by MAC address based
> naming.  Boxes with field replacable but otherwise fixed NICs apparently
> rather need a naming scheme based on PCI/PCIe topology.  (This requires
> that the topology is exposed to userspace in comparable manner across
> boots and across kernel version updates.)

the detection order works pretty well, we don't do parallel detection yet, 
and when we do having parallel detection, but serial registration (in a 
defined order) will work.

yes, this can change across kernel version, but in practice it seldom 
does. having run linux on production systems since the 2.0 days (and on 
personal systems since before 0.99) there have only been a handful of 
times when the detection order has changed.

> So, an administrator should get to choose between different well
> documented naming schemes.
>
> Also, like Jan mentioned, confusion can already be minimized by renaming
> eth[0-9]+ -> net_[a-z]+ (for example, or nic[0-9]+ like Jan wrote)
> rather than eth[0-9]+ -> eth[0-9]+.  That way it's clearer at all times
> whether the original names or names given by userspace are used.
>
> And there should be a log message when a device was renamed.  Better
> yet, like Michal wrote:  In case of device files for mass storage, there
> is no _renaming_.  Instead, udev creates _aliases_ (symlinks), and it
> does so with a few different naming schemes at once so that admins or
> users immediately have a choice:
> $ ls /dev/disk/
> by-id  by-path  by-uuid
>
> Any chance that there could be aliases to network interfaces?  Aliases
> for device files are easy --- they live only in userspace.

useing different names for the MAC based names, and providing both names 
at once would work very well.

David Lang
