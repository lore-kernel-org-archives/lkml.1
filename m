Return-Path: <linux-kernel-owner+w=401wt.eu-S1757620AbXKFTBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757620AbXKFTBy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 14:01:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756861AbXKFTBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 14:01:37 -0500
Received: from ns2.lanforge.com ([66.165.47.211]:46102 "EHLO ns2.lanforge.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756639AbXKFTBg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 14:01:36 -0500
Message-ID: <4730B8ED.7020301@candelatech.com>
Date: Tue, 06 Nov 2007 10:56:45 -0800
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Thunderbird 1.5.0.10 (X11/20070301)
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: Patrick McHardy <kaber@trash.net>, David Miller <davem@davemloft.net>,
       djohnson+linux-kernel@sw.starentnetworks.com, jes@trained-monkey.org,
       mchan@broadcom.com, ram.vepa@neterion.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, bguo@sw.starentnetworks.com
Subject: Re: [PATCH 1/2] NET: Re-add VLAN tag for devices incapable of keeping
 it
References: <472A6089.7020104@hp.com>	<18223.22291.622615.129374@zeus.sw.starentnetworks.com>	<472F5A33.20906@trash.net>	<20071105.151544.175839612.davem@davemloft.net>	<472FB375.1020802@trash.net> <m3y7db45ga.fsf@maximus.localdomain>
In-Reply-To: <m3y7db45ga.fsf@maximus.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa wrote:
> Patrick McHardy <kaber@trash.net> writes:
> 
>> I think there is one more case that matters, which is briding
>> from a device with VLAN stripping for a VLAN not configured
>> locally. The tag will be stripped and will be lost for forwarded
>> packets.
> 
> I think we should drop such packets on RX. Anyway we shouldn't
> forward them.

Bridging eth0 to eth1 should not pay attention to VLAN tags
at all (if the pkt comes in on VLAN 7, it should go out on VLAN 7),
in my opinion.  If the NIC is stripping the VLAN header, then this
cannot work unless something re-builds the VLAN header.  If the stripped
VLAN header is placed into the skb, then any code that does need to
rebuild it can do so.  It may be less efficient, but users can just
not use that NIC hardware for high-end solutions, and at any rate,
less efficient is better than broken.

Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

