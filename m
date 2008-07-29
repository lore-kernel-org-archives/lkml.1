Return-Path: <linux-kernel-owner+w=401wt.eu-S1754959AbYG2POw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959AbYG2POw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 11:14:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751502AbYG2POn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 11:14:43 -0400
Received: from outbound-mail-116.bluehost.com ([69.89.22.16]:53918 "HELO
	outbound-mail-116.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751808AbYG2POn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 11:14:43 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=ib6YLKFC2R2kck/TOoSRu1GJ5YzrpyfOfQ5VBos9pfhwqRYi63t6yHc9BOY4Ok60lwFd2qYw7igm4INWUElVTrF3CXBTeYC78R25F6lOIhAchDFX+z2IOdnMKNZ8aoiK;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Subject: Re: post 2.6.26 requires pciehp_slot_with_bus
Date: Tue, 29 Jul 2008 08:14:32 -0700
User-Agent: KMail/1.9.9
Cc: Pierre Ossman <drzeus-list@drzeus.cx>, Alex Chiang <achiang@hp.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
       Kristen Accardi <kristen.c.accardi@intel.com>
References: <20080724134737.4b91f30d@mjolnir.drzeus.cx> <200807280916.44664.jbarnes@virtuousgeek.org> <488E83E9.6030108@jp.fujitsu.com>
In-Reply-To: <488E83E9.6030108@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807290814.33098.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 28, 2008 7:43 pm Kenji Kaneshige wrote:
> > Your systems don't have _RMV methods for the hotpluggable PCIe slots in
> > the DSDT?  That's a shame; the Windows docs I found on PCIe hotplug
> > seemed to indicate that _RMV and _OSC (under Vista) were used to detect
> > whether a given slot was hot pluggable (I just googled for "windows pcie
> > hotplug" or something) so I was hoping that would be a reliable method...
> >  Any other ideas?  I'll go see if I can dig up some ExpressCard info.
>
> My systems don't have _RMV methods for the hot pluggable PCIe slots in the
> DSDT, but I don't think that's a shame. I suppose that the document you are
> referring describes how Windows handles ExpressCard slots. In my
> understanding, Hot Plug Surprise bit in the Slot Capabilities register is
> set to 1b on ExpressCard slots, and I believe that ACPI _RVM method is for
> the device that only supports surprise-style removal. I think this is why
> your system implements _RMV method for slots.

Yeah, that may be.  The document wasn't very clear; I was hoping that 
something simple would be available.

> On the other hand, hot pluggable slots on my servers are *not* ExpressCard
> slots, and all of them have Power Controller instead of surprise-style
> removal (Hot Plug Surprise bit in the Slot Capabilities register is set to
> 0b). So I believe there is no reason to implement _RMV methods for the hot
> pluggable PCIe slots on my systems.
>
> Here is an idea. How about using _RMV method to determine whether a given
> slot is actually hot pluggable when Hot Plug Surprise bit in the Slot
> Capabilities register is set to 1b on the slot? This is based on a little
> rough assumption that all PCIe slots that support surprise-style removal
> have _RMV method, though. Does this work for you?

It's worth a try.  We need *some* sort of better method to detect hot 
pluggable slots...

Thanks,
Jesse
