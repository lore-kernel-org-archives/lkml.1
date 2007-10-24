Return-Path: <linux-kernel-owner+w=401wt.eu-S1754002AbXJXBDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002AbXJXBDt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 21:03:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753833AbXJXBDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 21:03:39 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:39594 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753872AbXJXBDi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 21:03:38 -0400
Message-ID: <471E99E8.6030404@garzik.org>
Date: Tue, 23 Oct 2007 21:03:36 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: netdev@vger.kernel.org
CC: David Miller <davem@davemloft.net>, davej@redhat.com,
       auke-jan.h.kok@intel.com, ajax@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] e1000, e1000e valid-addr fixes
References: <471E2AD0.1000500@intel.com>	<471E5C21.8030908@garzik.org>	<20071023212026.GF7793@redhat.com> <20071023.145339.55504234.davem@davemloft.net> <471E9801.2000006@garzik.org>
In-Reply-To: <471E9801.2000006@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Actually, looking over the code I see obvious bugs in the logic:
> 
> An invalid ethernet address should not cause device loading to fail, 
> because the user is given the opportunity to supply a MAC address via 
> userspace (ifconfig or whatever) before the interface goes up.
> 
> I just created the attached -bug fix- patch as illustration, though I 
> have not committed it, waiting for comment.
> 
> This patch will make no difference for users hitting invalid-eep-csum 
> rather than invalid-MAC-addr condition, but it's a problem I noticed 
> while reviewing Adam's patch in detail.


Adding my own comment :)

Does the ethernet stack check is_valid_ether_addr() before permitting 
interface-up?

I'm wondering if there is a way to avoid adding

	if (!is_valid_ether_addr(dev->dev_addr))
		return -EINVAL;

to every ethernet driver's ->open() hook.

	Jeff


