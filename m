Return-Path: <linux-kernel-owner+w=401wt.eu-S1423272AbXBUXZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423272AbXBUXZt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 18:25:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423260AbXBUXZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 18:25:44 -0500
Received: from gate.crashing.org ([63.228.1.57]:59969 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423258AbXBUXZN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 18:25:13 -0500
Subject: Re: [RFC] split NAPI from network device.
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: David Miller <davem@davemloft.net>
Cc: shemminger@osdl.org, netdev@vger.kernel.org, ebs@ebshome.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070220.213125.74747066.davem@davemloft.net>
References: <20061213113537.6baf410f@dxpl.pdx.osdl.net>
	 <1166042552.11914.188.camel@localhost.localdomain>
	 <20061213154635.1f284bf6@dxpl.pdx.osdl.net>
	 <20070220.213125.74747066.davem@davemloft.net>
Content-Type: text/plain
Date: Thu, 22 Feb 2007 10:24:31 +1100
Message-Id: <1172100271.6792.7.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Actually, Ben did you determine if this scheme works for your device
> which has a single interrupt source yet multiple queues?  There is one
> driver that, during the conversion, I noticed has a similar issue.
> One driver, netxen, has multiple channels, so it just passes in
> "bugdet / NUM_CHANNELS" as the quota so that one channel could not
> starve the others.


The device has a single interrupt though that interrupt at least can
tell you which queues need servicing. It can't mask the interrupt per
queue though, which is the main issue.

So while I think this scheme would work (the driver, ibm_emac, currently
uses a fake net_device and that sort-of works, budget is set a CONFIG_*
time though, I'm sure that can/needs to be improved), I've been
wondering all along if I could do something smarter by doing some
interrupt soft-disabling instead, though I have to get my head around
properly kicking softirqs from task context (if I need to re-trigger
from a enable_*() call occuring at task context).

I'm travelling at the moment, so I won't be able to have a serious look
for a little while though.

Cheers,
Ben.
 

