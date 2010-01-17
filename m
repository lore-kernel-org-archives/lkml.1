Return-Path: <linux-kernel-owner+w=401wt.eu-S1754625Ab0AQWR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625Ab0AQWR6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 17:17:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754231Ab0AQWR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 17:17:57 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:40566 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754Ab0AQWR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 17:17:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=GcpWxLzivcANq3ci5iAfs3FGHAoOv6SpOI0yXPFKvpUcMYfI140eQumdWetEW+JXOz
         J6BefWhW4w9AUW9fqHugdXXo6ohAJYTqOPEJvQbGnkAKBsB5pcSqTSsphB5pj1irZB5A
         BSe290NeLGfWYKVJPgpErtdvR5sKjv4kuhKmM=
Date: Sun, 17 Jan 2010 23:17:46 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Michael Breuer <mbreuer@majjas.com>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       flyboy@gmail.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] af_packet: Don't use skb after dev_queue_xmit()
Message-ID: <20100117221746.GA3161@del.dom.local>
References: <4B475FF9.7000702@majjas.com>
 <20100108212923.GA3078@del.dom.local>
 <4B47A81B.5040601@majjas.com>
 <4B4809EF.1070609@majjas.com>
 <20100109122830.GA4386@del.dom.local>
 <4B48CC2C.2090403@majjas.com>
 <4B4E2F89.2050606@majjas.com>
 <20100113210908.GA3065@del.dom.local>
 <4B4E3834.3000609@majjas.com>
 <4B533A46.9050600@majjas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B533A46.9050600@majjas.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 17, 2010 at 11:26:46AM -0500, Michael Breuer wrote:
> On 01/13/2010 04:16 PM, Michael Breuer wrote:
> >On 1/13/2010 4:09 PM, Jarek Poplawski wrote:
> >>On Wed, Jan 13, 2010 at 03:39:37PM -0500, Michael Breuer wrote:
> >>>Just an FYI - 2.6.32.3 with alt 3 af_packet patch&  sky2
> >>>pskb_may_pull runs OK with DMAR (re)enabled and msi enabled.
> >>Hmm... What a pity! It was such a useful debugging tool for
> >>networking ;-) BTW, I'm not sure if "runs OK" means with or without
> >>those DHCP drops&  large packets you described.
> >>
> >>Thanks,
> >>Jarek P.
> >As of now, no errors even when blasting traffic & forcing dhcp
> >packets as before. I haven't tried putting mtu back to 9k yet. OK
> >means that there are no obvious differences in behavior with or
> >without DMAR all else being equal.
> >
> >There were some updates made to stable that could have fixed this
> >- I'd guess intel_iommu fixes helped.
> >
> >If it helps, I'm still getting one error without DMAR enabled - at
> >startup, there's a DMA sync oops - mismatch of 72 bytes coming
> >from sky2. That oops was posted previously - with DMAR (re)
> >enabled, there's no related oops.
> Update: after leaving the system up for a few days, I hit the DMAR
> error again.

My proposal is to send some summary as a new thread, with dmar in the
subject, and cc-ed dmar maintainers.

> This happened during a scheduled backup from my win7
> box. A reboot was required to re-enable eth0. After the error, eth0
> was receiving, but was unable to transmit. For example, the log
> reported arp bogons; DHCPINFORM/ACK sequences (where the ACK that
> was logged was not transmitted), etc. The log was filled with sky2
> eth0: tx timeout messages; as well as disable/enable of eth0.
> 
> I attempted to get things up again without a reboot, but failed.
> Even rmmod & insmod did not fix whatever was broken on the TX side.
> 
> Note that this is similar to the earlier sky2 errors I had under
> load with the variety of patches, and with or without DMAR enabled.
> Just took way longer this time. Note that eth1 remained functional.
> 
> Unfortunately, with the latest set of patches installed, this is no
> longer reproducible at will. I'd guess therefore that the patches
> narrowed some hole, but didn't close it.

It would be nice to name those patches each time. Anyway, try this
again without DMAR.

Thanks,
Jarek P.

> 
> Relevant log portions:
> 
> Jan 17 05:29:49 mail dhcpd: DHCPREQUEST for 10.0.0.32 from
> 00:26:bb:aa:15:10 (mbitouch) via eth0
> Jan 17 05:29:49 mail dhcpd: DHCPACK on 10.0.0.32 to
> 00:26:bb:aa:15:10 (mbitouch) via eth0
> Jan 17 05:36:49 mail kernel: DRHD: handling fault status reg 2
> Jan 17 05:36:49 mail kernel: DMAR:[DMA Read] Request device
> [06:00.0] fault addr ffe7957fe000
> Jan 17 05:36:49 mail kernel: DMAR:[fault reason 06] PTE Read access
> is not set
> Jan 17 05:36:49 mail kernel: sky2 0000:06:00.0: error interrupt
> status=0xc0000000
> Jan 17 05:36:49 mail kernel: sky2 0000:06:00.0: PCI hardware error (0x2010)
...
