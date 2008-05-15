Return-Path: <linux-kernel-owner+w=401wt.eu-S932285AbYEOSv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932285AbYEOSv6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 14:51:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763495AbYEOSuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 14:50:37 -0400
Received: from mga02.intel.com ([134.134.136.20]:11635 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763447AbYEOSue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 14:50:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,493,1204531200"; 
   d="scan'208";a="281892341"
Message-ID: <482C8550.5000909@intel.com>
Date: Thu, 15 May 2008 11:47:44 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080417)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Rick Jones <rick.jones2@hp.com>,
       "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Chris Peterson <cpeterso@cpeterso.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/net: remove network drivers' last few uses of
 IRQF_SAMPLE_RANDOM
References: <Pine.LNX.4.62.0805150009060.18303@ikari.dreamhost.com>	<20080515142154.0595e475@core>	<36D9DB17C6DE9E40B059440DB8D95F52052D71BB@orsmsx418.amr.corp.intel.com> <482C7B18.6060003@garzik.org> <482C7E53.3050300@hp.com> <482C8184.2030906@garzik.org>
In-Reply-To: <482C8184.2030906@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Rick Jones wrote:
>> Is there nothing associated with the networking stack - NIC, driver,
>> protocols, system calls which can be used as a source of entropy?
> 
> The issue is with being externally observable and controllable, or, with
> some irq mitigation schemes, be made /too regular/.
> 
> Interrupts (or timed mitigation events) may be triggered by the outside
> world, which makes it a very short path from remote attacker to local
> kernel entropy pool.
> 
> Finally, with severe load, there are little or no interrupts thanks to
> heavy mitigation, which means your entropy pool may be externally DoS'd.
> 
> Or at the very least, when your entropy needs to be INCREASED (due to
> heavy workload due to heavy traffic), your incoming entropy DECREASES
> due to decreased interrupts.
> 
> [I just realized that last one.  Heck, I'm even convincing myself even
> more its a bad idea]

so you have established that with any type of interrupt moderation (either NAPI or
some form of irq throttling in the NIC hardware) that IRQF_SA_RANDOM will become
more predictable.

How about the non-NAPI and non-throttled case? I would argue that without any irq
mitigation we can still use SA_RANDOM. Many (e.g. embedded) devices will want some
extra form of entropy, and providing them it in this form will be very beneficial
as these devices more commonly have no other form of entropy anymore.

Auke

