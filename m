Return-Path: <linux-kernel-owner+w=401wt.eu-S1761627AbXLMOUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761627AbXLMOUP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 09:20:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754997AbXLMOTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 09:19:46 -0500
Received: from mailbox2.myri.com ([64.172.73.26]:1955 "EHLO myri.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754768AbXLMOTp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 09:19:45 -0500
Message-ID: <47613E22.6060705@myri.com>
Date: Thu, 13 Dec 2007 09:13:54 -0500
From: Andrew Gallatin <gallatin@myri.com>
User-Agent: Thunderbird 1.5.0.7 (Macintosh/20060909)
MIME-Version: 1.0
To: Joonwoo Park <joonwpark81@gmail.com>
CC: "Kok, Auke" <auke-jan.h.kok@intel.com>, David Miller <davem@davemloft.net>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org, jgarzik@pobox.com,
       shemminger@linux-foundation.org,
       Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: Re: [RFC] net: napi fix
References: <47601A73.5010804@myri.com>	 <20071212.093819.205755031.davem@davemloft.net>	 <47602B77.2090202@intel.com> <b25c3fa70712122341q3ba282cdqda3fa56901b14484@mail.gmail.com>
In-Reply-To: <b25c3fa70712122341q3ba282cdqda3fa56901b14484@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joonwoo Park wrote:
 > 2007/12/13, Kok, Auke <auke-jan.h.kok@intel.com>:
 >> David Miller wrote:
 >>> From: Andrew Gallatin <gallatin@myri.com>
 >>> Date: Wed, 12 Dec 2007 12:29:23 -0500
 >>>
 >>>> Is the netif_running() check even required?
 >>> No, it is not.
 >>>
 >>> When a device is brought down, one of the first things
 >>> that happens is that we wait for all pending NAPI polls
 >>> to complete, then block any new polls from starting.
 >> I think this was previously (pre-2.6.24) not the case, which is why 
e1000 et al
 >> has this check as well and that's exactly what is causing most of the
 >> net_rx_action oopses in the first place. Without the netif_running() 
check
 >> previously the drivers were just unusable with NAPI and prone to 
many races with
 >> down (i.e. touching some ethtool ioctl which wants to do a reset 
while routing
 >> small packets at high numbers). that's why we added the 
netif_running() check in
 >> the first place :)
 >>
 >> There might be more drivers lurking that need this change...
 >>
 >> Auke
 >>
 >
 > Also in my case, without netif_running() check, I cannot do ifconfig 
down.
 > It stucked if packet generator was sending packets.

If the netif_running() check is indeed required to make a device break
out of napi polling and respond to an ifconfig down, then I think the
netif_running() check should be moved up into net_rx_action() to avoid
potential for driver complexity and bugs like the ones you found.

Drew
