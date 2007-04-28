Return-Path: <linux-kernel-owner+w=401wt.eu-S1751580AbXD1Klw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751580AbXD1Klw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 06:41:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754773AbXD1Klw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 06:41:52 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:50439 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbXD1Klu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 06:41:50 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <463324CD.1010604@s5r6.in-berlin.de>
Date: Sat, 28 Apr 2007 12:41:17 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070408 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
CC: linux1394-devel@lists.sourceforge.net, Ben Collins <bcollins@debian.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 13/30] Use menuconfig objects - IEEE1394
References: <Pine.LNX.4.61.0704102046520.32056@yvahk01.tjqt.qr> <Pine.LNX.4.61.0704102316160.32056@yvahk01.tjqt.qr> <4632638D.2050004@s5r6.in-berlin.de> <Pine.LNX.4.61.0704280944100.506@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0704280944100.506@yvahk01.tjqt.qr>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Apr 27 2007 22:56, Stefan Richter wrote:
> 
>>> -config IEEE1394
>>> +menuconfig IEEE1394
>>>  	tristate "IEEE 1394 (FireWire) support"
>>>  	depends on PCI || BROKEN
>>>  	select NET
>> [...]
>>
>> Unless there are objections, I will merge it into my queue of IEEE 1394
>> updates for Linus.
> 
> Yes, I do have objections now that the ieee1394 is different in
> 2.6.21-rc7-mm1.
> Now you have two options in the firewire menu, namely the new
> stack and the old stack. Then menuconfig is not really suitable
> anymore.
> So please skip it until the old stack finds its way out (which may
> take some more time, yes).

My idea, which I planned to cast into a patch during this weekend, was
to keep a patch in linux1394-2.6.git's feed to -mm which basically
restores what can now be seen in -mm  (one 1394 menu, two big
subsections in it), while Linus' tree gets the menuconfig form.

On the other hand, there may come a period were Linus' tree gets
something like we have in -mm, i.e. the choice to enable one or the
other or both or none of the two stacks.

So, shall I put Jan's patch aside until there is only one stack left?

Or what about:

	menuconfig FIREWIRE_SUPPORT
		tristate "IEEE 1394 (FireWire) support"

	config FIREWIRE
		tristate "new FireWire stack, alias Juju"
		depends on FIREWIRE_SUPPORT && !(IEEE1394=y)
		default m
	[...]

	config IEEE1394
		tristate "legacy FireWire stack"
		depends on FIREWIRE_SUPPORT && !(FIREWIRE=y)
		default m
	[...]

	comment "You can have both stacks installed but should blacklist
	         the modules of one of them.  Else modules from both
	         stacks will be autoloaded on hotplug events."
		depends on FIREWIRE && IEEE1394

(Untested pseudo code.)  This would add an extra level of yes/no/m
choice for those who want FireWire drivers.  But it lets people who
don't want FireWire skip everything at the superordinate menu.
-- 
Stefan Richter
-=====-=-=== -=-- ===--
http://arcgraph.de/sr/
