Return-Path: <linux-kernel-owner+w=401wt.eu-S1753739AbYFBSjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739AbYFBSjS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 14:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752033AbYFBSjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 14:39:06 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:38756 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752111AbYFBSjF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 14:39:05 -0400
Message-ID: <48443E3F.8050306@garzik.org>
Date: Mon, 02 Jun 2008 14:38:55 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: kristen.c.accardi@intel.com
CC: Mark Lord <liml@rtr.ca>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Pavel Machek <pavel@ucw.cz>, Theodore Tso <tytso@mit.edu>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ata: ahci: power off unused ports
References: <20080508161008.59361de5@appleyard>	<20080527030854.GC7515@mit.edu>	<20080527143202.4bab5bf0@appleyard>	<20080527225926.GE6843@mit.edu>	<20080527163251.04054a74@appleyard>	<20080531080015.GG5405@ucw.cz>	<4842F5A8.9020708@garzik.org>	<20080602080440.25fc663c@core>	<4843A4A7.3020809@garzik.org>	<4843EF88.2040606@rtr.ca>	<48441AA6.8080704@garzik.org>	<20080602100019.3d2d2522@appleyard>	<484431AB.7010005@garzik.org>	<20080602104753.3f24087d@appleyard>	<484438BF.7070303@garzik.org> <20080602111644.54738d57@appleyard>
In-Reply-To: <20080602111644.54738d57@appleyard>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kristen Carlson Accardi wrote:
> On Mon, 02 Jun 2008 14:15:27 -0400
> Jeff Garzik <jeff@garzik.org> wrote:
> 
>> Kristen Carlson Accardi wrote:
>>> Here you can see that it would be very easy for another driver
>>> to just add code to set the NO_HOTPLUG flag and then this code
>>> will work for them as well, since we power off the phy using
>>> DET which is specified by SATA.
>>> here's that code:
>> Agreed.  The main discussion in this sub-thread is more about user 
>> interface.  The user interface in this case, a module option, is 
>> specific to AHCI.
>>
>> Surely you can see how it is a bit silly to force each driver writer to 
>> create the same user interface in each driver, to support a generic concept.
>>
>> 	Jeff
>>
>>
> Not all drivers will need a user interface to turn off hotplug
> I would think.  At any rate - I would think it'd be better to let
> driver writers decide how they want their drivers to behave wrt
> hotplug and power instead of forcing a generic policy on everyone.
> 
> This patch would provide users of AHCI controllers a way to save
> power now, while you work on the grand scheme for polling/turning on off
> hotplug via sysfs.  It's an interim solution that impacts nobody but
> ahci users and is can be easily integrated into whatever solution you
> eventually work out.

It's a one-off driver-specific interface that will have to be supported 
even after the same feature is available via libata core...  that's not 
the path to scalable, sustainable engineering.

I know user interfaces are annoying because you have to think about 
chips other than your own, but that's life.  Other hardware vendors have 
to do it too.

Letting each driver have a different user interface is /unfriendly/ to 
both developers users.  It's easiest for Intel kernel developers, but 
that is not our target audience :)

The biggest power savings for the largest amount of users can be had if 
you take a moment and figure out what's best for Linux, rather than what 
is best for Intel.

Because you can be damned sure SATA users with non-AHCI chips want this 
power savings too...  let's not put roadblocks to that in place in the 
beginning (by adding one-off interfaces).

	Jeff



