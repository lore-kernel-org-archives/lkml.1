Return-Path: <linux-kernel-owner+w=401wt.eu-S1763464AbYEOScB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763464AbYEOScB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 14:32:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760740AbYEOSbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 14:31:43 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:59761 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758984AbYEOSbl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 14:31:41 -0400
Message-ID: <482C8184.2030906@garzik.org>
Date: Thu, 15 May 2008 14:31:32 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Rick Jones <rick.jones2@hp.com>
CC: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Chris Peterson <cpeterso@cpeterso.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/net: remove network drivers' last few uses of
 IRQF_SAMPLE_RANDOM
References: <Pine.LNX.4.62.0805150009060.18303@ikari.dreamhost.com>	<20080515142154.0595e475@core>	<36D9DB17C6DE9E40B059440DB8D95F52052D71BB@orsmsx418.amr.corp.intel.com> <482C7B18.6060003@garzik.org> <482C7E53.3050300@hp.com>
In-Reply-To: <482C7E53.3050300@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rick Jones wrote:
> Is there nothing associated with the networking stack - NIC, driver, 
> protocols, system calls which can be used as a source of entropy?

The issue is with being externally observable and controllable, or, with 
some irq mitigation schemes, be made /too regular/.

Interrupts (or timed mitigation events) may be triggered by the outside 
world, which makes it a very short path from remote attacker to local 
kernel entropy pool.

Finally, with severe load, there are little or no interrupts thanks to 
heavy mitigation, which means your entropy pool may be externally DoS'd.

Or at the very least, when your entropy needs to be INCREASED (due to 
heavy workload due to heavy traffic), your incoming entropy DECREASES 
due to decreased interrupts.

[I just realized that last one.  Heck, I'm even convincing myself even 
more its a bad idea]

	Jeff



