Return-Path: <linux-kernel-owner+w=401wt.eu-S1761831AbYBPBFE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761831AbYBPBFE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 20:05:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754768AbYBPBEz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 20:04:55 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:48827 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbYBPBEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 20:04:54 -0500
Date: Fri, 15 Feb 2008 16:57:35 -0800
From: Greg KH <greg@kroah.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Jonas Bonn <jonas@southpole.se>, linux-kernel@vger.kernel.org
Subject: Re: pci_device_id definition cleanups
Message-ID: <20080216005735.GA21034@kroah.com>
References: <1203117700.16761.9.camel@satguru> <20080216000512.GA18925@kroah.com> <47B6346B.3050300@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B6346B.3050300@garzik.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2008 at 07:55:07PM -0500, Jeff Garzik wrote:
> Greg KH wrote:
>> On Sat, Feb 16, 2008 at 12:21:40AM +0100, Jonas Bonn wrote:
>>> I've done some work on cleaning up the definitions of pci_device_id to
>>> make them "static const" (where possible) and to make sure they go into
>>> __devinitconst.  There are about 350 changes of the type shown in the
>>> diff at the end of this mail.
>>>
>>> ???All these changes are in my public GIT tree at:
>>>
>>> git://www.southpole.se/~jonas/git/linux.git
>>>
>>> (Based on 2.6.25-rc2)
>>>
>>> In addition to these pci_device_id changes, there are a few changesets
>>> that move "const" data from __devinitdata to __devinitconst.
>>>
>>> The tree above builds with both allmodconfig and allyesconfig.
>> Hm, does this save us any memory on any type of configuration?
>> What about drivers that end up writing to these structures (I know some
>> USB drivers do, not sure about PCI ones.)
>
> I don't recall ever seeing a PCI driver do that... and if it exists on the 
> PCI side, I would be motivated to create patches to "fix" such behavior :)
>
> That information is exported to utilities that expect that table to be 
> static.  Messing around with it is just hacky, and bound to produce 
> unwanted edge cases.

Well, the USB drivers used to add an additional NULL entry at the end of
the list, and then populate it based on module parameters.  That way the
userspace tools would always work just fine, and you could add
additional device ids at run-time.

Now we have a way to do this for all USB and PCI drivers through sysfs,
so it's not needed, but we have to keep the backwards compatiblity for a
while in a number of USB drivers.

Hopefully PCI drivers didn't do the same thing, but I haven't looked at
all of them to verify this or not :)

thanks,

greg k-h
