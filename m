Return-Path: <linux-kernel-owner+w=401wt.eu-S1759949AbXKLRWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759949AbXKLRWW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 12:22:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759085AbXKLRWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 12:22:11 -0500
Received: from stinky.trash.net ([213.144.137.162]:53665 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758998AbXKLRWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 12:22:09 -0500
Message-ID: <47388B9F.7050308@trash.net>
Date: Mon, 12 Nov 2007 18:21:35 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070828)
MIME-Version: 1.0
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
CC: Joonwoo Park <joonwpark81@gmail.com>,
       "'David Miller'" <davem@davemloft.net>, netdev@vger.kernel.org,
       "'Dave Johnson'" <djohnson+linux-kernel@sw.starentnetworks.com>,
       linux-kernel@vger.kernel.org, e1000-devel@lists.sourceforge.net
Subject: Re: [PATCH 2/2] [e1000 VLAN] Disable vlan hw accel when promiscuous
 mode
References: <47365200.0f10240a.0686.2173@mx.google.com> <47388988.1000506@intel.com>
In-Reply-To: <47388988.1000506@intel.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kok, Auke wrote:
> Joonwoo Park wrote:
>> IMHO even though netdevice is in the promiscuous mode, we should receive all of ingress packets.
>> This disable the vlan filtering feature when a vlan hw accel configured e1000 device goes into promiscuous mode.
>> This make packets visible to sniffers though it's not vlan id of itself.
>> Any check, comments will be appreciated.
> 
> Actually I think this patch removes a choice from the user.
> 
> Before this patch, the user can sniff all traffic by disabling vlans, or a
> specific vlan only by leaving vlans on when going into promisc mode.
> 
> After this patch, the user has no choice but to sniff all vlans at all times.
> 
> I don't think that that is such a good improvement.


Do you really consider that a realistic choice? Who is going to
remove interfaces that are in use just to see traffic for other
VLANs? Sniffing specific VLANs can always be done on the VLAN
device itself.

IMO its more a question of what we want promiscous mode to mean,
and I tend to agree with Joonwoo that it should receive all packets.
