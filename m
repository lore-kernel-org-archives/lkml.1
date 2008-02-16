Return-Path: <linux-kernel-owner+w=401wt.eu-S1763645AbYBPAzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763645AbYBPAzY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 19:55:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756109AbYBPAzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 19:55:13 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:58088 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755823AbYBPAzL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 19:55:11 -0500
Message-ID: <47B6346B.3050300@garzik.org>
Date: Fri, 15 Feb 2008 19:55:07 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Jonas Bonn <jonas@southpole.se>, linux-kernel@vger.kernel.org
Subject: Re: pci_device_id definition cleanups
References: <1203117700.16761.9.camel@satguru> <20080216000512.GA18925@kroah.com>
In-Reply-To: <20080216000512.GA18925@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Sat, Feb 16, 2008 at 12:21:40AM +0100, Jonas Bonn wrote:
>> I've done some work on cleaning up the definitions of pci_device_id to
>> make them "static const" (where possible) and to make sure they go into
>> __devinitconst.  There are about 350 changes of the type shown in the
>> diff at the end of this mail.
>>
>> ???All these changes are in my public GIT tree at:
>>
>> git://www.southpole.se/~jonas/git/linux.git
>>
>> (Based on 2.6.25-rc2)
>>
>> In addition to these pci_device_id changes, there are a few changesets
>> that move "const" data from __devinitdata to __devinitconst.
>>
>> The tree above builds with both allmodconfig and allyesconfig.
> 
> Hm, does this save us any memory on any type of configuration?
> 
> What about drivers that end up writing to these structures (I know some
> USB drivers do, not sure about PCI ones.)

I don't recall ever seeing a PCI driver do that... and if it exists on 
the PCI side, I would be motivated to create patches to "fix" such 
behavior :)

That information is exported to utilities that expect that table to be 
static.  Messing around with it is just hacky, and bound to produce 
unwanted edge cases.


> You're going to need to send out patches for these to the different
> developers, a git tree isn't going to help much.

Agreed.

	Jeff




