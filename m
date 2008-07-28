Return-Path: <linux-kernel-owner+w=401wt.eu-S1758199AbYG1QRJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758199AbYG1QRJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 12:17:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755570AbYG1QQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 12:16:56 -0400
Received: from outbound-mail-134.bluehost.com ([67.222.39.24]:39976 "HELO
	outbound-mail-134.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754340AbYG1QQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 12:16:55 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=pOfg9blHSiaWXhf0lRK/Pd3XM8HkBdzW4PoqfGYHpeV/Ch7m+vVZekHl3w59E+TSmyfIwW04/EN9hbDkOExpmzImg5TD1uqbwVnVgkh49A6voF1IKdGZ9n/B+AhuR0KZ;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Subject: Re: post 2.6.26 requires pciehp_slot_with_bus
Date: Mon, 28 Jul 2008 09:16:44 -0700
User-Agent: KMail/1.9.9
Cc: Pierre Ossman <drzeus-list@drzeus.cx>, Alex Chiang <achiang@hp.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
       Kristen Accardi <kristen.c.accardi@intel.com>
References: <20080724134737.4b91f30d@mjolnir.drzeus.cx> <200807251518.53462.jbarnes@virtuousgeek.org> <488D86EC.1010903@jp.fujitsu.com>
In-Reply-To: <488D86EC.1010903@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807280916.44664.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 28, 2008 1:44 am Kenji Kaneshige wrote:
> Jesse Barnes wrote:
> > I think that's fine (automatically creating duplicate devices with names
> > to differentiate them), but I think we should also try harder to avoid
> > adding duplicates.
> >
> > In Pierre's case, and on my T61, there's only one actual hotplug slot
> > available, but the firmware creates duplicate physical slot numbers and
> > sets the HP_CAP bit on everything, both of which are obviously wrong
> > (well I suppose you could pop these chips off the board, but it's not
> > very practical).  However, afaict that "other" OS uses the _RMV method to
> > determine whether a given slot is actually hot pluggable.  On my T61 at
> > least, this seems to be accurate: only one of my EXP* objects has a _RMV
> > method.
> >
> > So maybe the PCIe hotplug driver should be checking for that method when
> > ACPI is available?  We already try to use _OSC etc., so checking for _RMV
> > first would make sense...
>
> As you pointed out, the root cause might not a problem of slot naming,
> but a problem of slots detection, because pciehp driver detects multiple
> PCIe hotplug slots even thought your and Pierre's system seems to have
> only one hotplug slot. So I think we should also consider the problem
> from this view point (slot detection).
>
> But, I think simply checking for _RMV method first is dangerous because
> I think there are many systems that doesn't implement _RMV for PCIe
> hotplug slots (at least, my system doesn't implement that. Anyway,
> I would like to look at the documents/specifications that mention _RMV
> method for determining whether a given slot is hot pluggable. Do you
> have any information about that? I think PCI Local Bus, PCI Express and
> PCI Firmware specification don't mention that. I think hot pluggable slots
> on your, Pierre's and Matthew's system are ExpressCard slots. So I guess
> ExpressCard specification might define something about this. But
> unfortunately, I don't have ExpressCard specification. Can anyone access
> ExpressCard spec?

Your systems don't have _RMV methods for the hotpluggable PCIe slots in the 
DSDT?  That's a shame; the Windows docs I found on PCIe hotplug seemed to 
indicate that _RMV and _OSC (under Vista) were used to detect whether a given 
slot was hot pluggable (I just googled for "windows pcie hotplug" or 
something) so I was hoping that would be a reliable method...  Any other 
ideas?  I'll go see if I can dig up some ExpressCard info.

Thanks,
Jesse
