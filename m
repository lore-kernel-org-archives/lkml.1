Return-Path: <linux-kernel-owner+w=401wt.eu-S2993261AbXEBOfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993261AbXEBOfb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 10:35:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993262AbXEBOfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 10:35:31 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:11719 "EHLO
	pd4mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993261AbXEBOfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 10:35:30 -0400
Date: Wed, 02 May 2007 08:34:36 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [RFC PATCH] PCI MMCONFIG: add validation against ACPI motherboard
 resources
In-reply-to: <200705012227.31729.jbarnes@virtuousgeek.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Olivier Galibert <galibert@pobox.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Chuck Ebbert <cebbert@redhat.com>, Len Brown <lenb@kernel.org>
Message-id: <4638A17C.40209@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <4635510D.4060103@shaw.ca>
 <200705011941.07438.jbarnes@virtuousgeek.org>
 <200705011956.30629.jbarnes@virtuousgeek.org>
 <200705012227.31729.jbarnes@virtuousgeek.org>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
> On Tuesday, May 01, 2007, Jesse Barnes wrote:
>>> I'm testing it now on my 965...
>> Bah... nevermind Robert, I see you're doing this already in
>> pci_mmcfg_reject_broken.  I'm about to reboot & test now.
> 
> Ok, I've tested a bit on my 965 (after re-adding my old patch to support 
> it) and the new checks are more complete, but my BIOS still appears to be 
> buggy.
> 
> The extended config space (as defined by the register) is at 0xf0000000 
> (full value is 0xf0000003 indicating 128M enabled).  The ACPI MCFG table 
> has this space reserved according to Robert's new code, but the machine 
> hangs due to the address space aliasing Olivier mentioned awhile back.  I 
> don't have a PCIe card to test with (or any devices that require extended 
> config space that I know of) so I can't really tell if Windows supports 
> PCIe on this platform, but if it does I don't see how it would w/o having 
> a full bridge driver and sophisticated address space allocation builtin.

Windows XP doesn't use MMCONFIG or any extended configuration space. I 
believe Vista is supposed to, though. Not sure how they are handling 
this issue.

> 
> I'm going to try updating my BIOS, but if that doesn't solve this problem, 
> I'm not sure what we can do about it.  Should pci_mmcfg_insert_resources 
> check for conflicts?  Should we just blacklist certain boards?  I can try 
> pinging our BIOS folks about this board to see what was intended, but I'm 
> sure this won't be the only board we have problems with, so we'll need to 
> address it generically somehow.

Can you post what your board has for PNPACPI reserved resources (I 
believe they're in /sys/devices/pnp0/*/resources IIRC, don't have a 
Linux box handy right now). Full dmesg would also be useful, I think it 
dumps out those reservations at boot nowadays..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

