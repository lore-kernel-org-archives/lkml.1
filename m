Return-Path: <linux-kernel-owner+w=401wt.eu-S1756698AbXKABb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698AbXKABb1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 21:31:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752988AbXKABbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 21:31:17 -0400
Received: from ns2.lanforge.com ([66.165.47.211]:48638 "EHLO ns2.lanforge.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752454AbXKABbQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 21:31:16 -0400
X-Greylist: delayed 1470 seconds by postgrey-1.27 at vger.kernel.org; Wed, 31 Oct 2007 21:31:16 EDT
Message-ID: <47292C5E.4050709@candelatech.com>
Date: Wed, 31 Oct 2007 18:31:10 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Thunderbird 1.5.0.10 (X11/20070301)
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@linux-foundation.org>
CC: Dave Johnson <djohnson+linux-kernel@sw.starentnetworks.com>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Bin Guo <bguo@sw.starentnetworks.com>
Subject: Re: expected behavior of PF_PACKET on NETIF_F_HW_VLAN_RX device?
References: <18216.52455.698606.497464@zeus.sw.starentnetworks.com> <20071031123359.3954befc@freepuppy.rosehill> <4729269A.6090606@candelatech.com> <47292A99.5070805@linux-foundation.org>
In-Reply-To: <47292A99.5070805@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Hemminger wrote:
>
> The code in AF_PACKET should fix the skb before passing to user space 
> so that there is
> no difference between accel and non-accel hardware.  Internal choices 
> shouldn't
> leak to user space.  Ditto, the receive checksum offload should be 
> fixed up as well.
Ok, I guess that will fix the sniffing issues and any user-space 
bridging type applications.

Currently, VLAN devices offer the ability to 'reorder' the header and 
explicitly remove the VLAN
header.  I assume we keep this feature and have the AF_PACKET logic 
check the device
flags to see if it should insert the VLAN header for hw-accel vlans?

Either way, if we sniff the underlying device, we should always get the 
VLAN header.

What about drivers and filtering VLANs?  It seems there is still a 
difference between software
vlans and hw-accel in this case.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com> 
Candela Technologies Inc  http://www.candelatech.com


