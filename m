Return-Path: <linux-kernel-owner+w=401wt.eu-S1755989AbXKATbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989AbXKATbk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 15:31:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753962AbXKATba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 15:31:30 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:58417 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753627AbXKATb3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 15:31:29 -0400
Message-ID: <472A2989.2060603@garzik.org>
Date: Thu, 01 Nov 2007 15:31:21 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@linux-foundation.org>
CC: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       davej@redhat.com, auke-jan.h.kok@intel.com, ajax@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] e1000, e1000e valid-addr fixes
References: <20071023.145339.55504234.davem@davemloft.net>	<471E9801.2000006@garzik.org>	<471E99E8.6030404@garzik.org>	<20071023.180744.115914004.davem@davemloft.net>	<471EABEE.8030900@garzik.org> <20071101111157.7f3e4f58@freepuppy.rosehill>
In-Reply-To: <20071101111157.7f3e4f58@freepuppy.rosehill>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Hemminger wrote:
> How about:
> 
> static int eth_validate_addr(const struct net_device *dev)
> {
> 	return is_valid_ether_addr(dev->dev_addr) ? 0 : -EINVAL;
> }

hmmm -- its a slow path, so I don't see the value of marking the 
argument 'const' -- right now this implementation merely reads the 
dev->dev_addr[], but that need not always be the case.

And I don't see the value of squashing everything onto one line, IMO the 
current version is more readable.

	Jeff



