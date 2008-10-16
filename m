Return-Path: <linux-kernel-owner+w=401wt.eu-S1755350AbYJPM1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350AbYJPM1t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 08:27:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753565AbYJPM1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 08:27:38 -0400
Received: from thoth.sbs.de ([192.35.17.2]:16027 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753293AbYJPM1h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 08:27:37 -0400
Message-ID: <48F7346D.2090800@siemens.com>
Date: Thu, 16 Oct 2008 14:32:45 +0200
From: "Hillier, Gernot" <gernot.hillier@siemens.com>
Organization: Siemens AG, CT SE 2
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de; rv:1.8.1.9) Gecko/20070801 SUSE/2.0.0.9-0.1 Thunderbird/2.0.0.9 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: "Graham, David" <david.graham@intel.com>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       "Allan, Bruce W" <bruce.w.allan@intel.com>,
       "Hockert, Jeff W" <jeff.w.hockert@intel.com>,
       "Fodor, Zoltan" <zoltan.fodor@intel.com>
Subject: Re: e1000e: sporadic "hardware error"s with Intel 82563EB on Supermicro
 X7DB3
References: <EA929A9653AAE14F841771FB1DE5A1365F498F4EDC@rrsmsx501.amr.corp.intel.com> <E3627BC91D010645BD262A1E8720005106A64162@orsmsx420.amr.corp.intel.com> <48EE04C0.6070504@siemens.com> <48F463D1.70605@siemens.com> <E3627BC91D010645BD262A1E8720005106B67989@orsmsx420.amr.corp.intel.com>
In-Reply-To: <E3627BC91D010645BD262A1E8720005106B67989@orsmsx420.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave!

I added Zoltan Fodor from your PAE department to the distribution list as
he also supports us regarding this problem.

Am 15.10.2008 18:37 schrieb Graham, David:
> I think that the system with the SuperMicro IPMI card is configured as 
> having an "external BMC" from the perspective of the INTEL-based system.

Exactly. That's what our hardware experts told me in the meantime, too.

> My experience of such configurations is that the IPMI traffic is handled
>  by the BMC in the card, but routed in/out of the system over the "eth0"
>  on-motherboard esb2 interface. I looked at the AOC-SIMPL-B card 
> described in the SuperMicro link you provided and see that it too has an
>  ethernet interface. I'm not sure if the interface on the card provides
> a second IPMI interface to the system, or that IPMI to the mainboard
> eth0 is disabled. I have IPMI management contacts here in INTEL, and am 
> trying to find out.
> 
> If this system does route IPMI traffic between the SuperMicro card & the
>  mainboard LAN eth0, the onboard LAN now has two clients, one on the 
> SuperMicro card, and one in the host OS.

The latter is true for us. This IPMI card has an own eth interface as you
mentioned, but due to product requirements, we can't use it but need the
"shared NIC" feature. Therefore, this card is configured (jumpered) to
route its IPMI traffic through the eth0 on the motherboard.

> INTEL provides APIs to external BMCs so that they can use the LAN, and
> hidden behind those APIs is code to allow each client to operate without
> having to be aware of the state of the other. There is a bug in this
> code that can be exposed when the host resets the LAN. The bug is
> resolved by a patch to the API code, which is applied as an EEPROM
> update to the system. I am working with Jeff Hockert & others in-house
> to find out details of how we are deploying that EEPROM update.

Thanks for the explanation. I would be more than happy to try anything in
that area!

> I continue to review - with help- the information that you have already 
> provided, to determine whether this system does match the IPMI 
> configuration that I think it does. I'll keep you up to date.

As explained above, your assumptions should exactly apply to our scenario, yes.

> OK, now for the system without the IPMI card. Probably that one does 
> have an active INTEL BMC. And, if it does, the core bug that I (sort-of)
>  explained above is also relevant there, though it's not fixable in the 
> same way because the buggy code in this case is integrated directly as 
> part of the INTEL BMC. In this case, you'll need a BMC upgrade. But 
> first, just like for the other case, I need to confirm that the 
> configuration is what I think it is.
> 
> It would help if you could provide a little more information. Could you 
> provide (for one of each of the two configurations that you have - one 
> with the IPMI card, one without):
> 
> lspci -t 
> lspci -vvv -xxxx
> ethtool -e eth0

I will provide those as soon as possible. Currently, they would be
meeningless for you probably as our hardware experts tried some kind of
firmware update which broke the "Shared NIC" feature - so I doubt we can
reproduce the bug in the current configuration.

As soon, as I can get the machines back to the state where we can reproduce
the issue, I'll send you the requested details.

> BIOS "IPMI" menus (I know you
> already gave us one, but both would be good)

For this, I can already tell that there is no BIOS IPMI menu available if
there's no IPMI card plugged in. Seems like the Supermicro BIOS developers
deny access to the Intel BMC in standalone mode...

-- 
With kind regards,
Gernot Hillier
Siemens AG, CT SE 2, Corporate Competence Center Embedded Linux
