Return-Path: <linux-kernel-owner+w=401wt.eu-S1755370AbXJAOy7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370AbXJAOy7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 10:54:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753487AbXJAOyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 10:54:51 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:46731 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753999AbXJAOyu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 10:54:50 -0400
Message-ID: <47010A34.9000709@pobox.com>
Date: Mon, 01 Oct 2007 10:54:44 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Greg KH <greg@kroah.com>, Ayaz Abdulla <aabdulla@nvidia.com>,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI: nVidia's MCP61 ethernet card needs quirk for wrong
 class
References: <Pine.LNX.4.64.0710011615390.7567@jikos.suse.cz> <47010832.8010401@pobox.com> <Pine.LNX.4.64.0710011647000.7567@jikos.suse.cz>
In-Reply-To: <Pine.LNX.4.64.0710011647000.7567@jikos.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> On Mon, 1 Oct 2007, Jeff Garzik wrote:
> 
>>> PCI: nVidia's MCP61 ethernet card needs quirk for wrong class
>>> The MCP61 ethernet controller from nVidia (NVENET_19) contains wrong
>>> PCI class:
>>>  00:07.0 Bridge [0680]: nVidia Corporation MCP61 Ethernet [10de:03ef] (rev
>>>  a2)
>>> i.e. it identifies itself as a bridge. Fix this.
>>> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
>> What is the problem that is present without this patch?
> 
> Userspace tools that are used to configure network are probable not to 
> detect this device as a network card and therefore not provide means to 
> configure the device (this is a case at least with yast, I don't know what 
> is the situation with other configurators).
> 
> There might be also other situations, I don't know. Userspace really 
> should know the proper class of the device, shouldn't it?

There are other network devices that do not claim 
PCI_CLASS_NETWORK_ETHERNET either.  Since this is a purely cosmetic 
issue -- said userland tools would need to support weird cases _anyway_ 
  -- I am not inclined to apply the patch.

The kernel could do a lot to make things "prettier," but that would lead 
to lots of additional code bloat.  It's easier to export the world as it 
is, and let the chips fall where they may.

	Jeff



