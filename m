Return-Path: <linux-kernel-owner+w=401wt.eu-S1759331AbYCCU2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759331AbYCCU2j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 15:28:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752288AbYCCU2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 15:28:30 -0500
Received: from mx1.redhat.com ([66.187.233.31]:36942 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751907AbYCCU2a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 15:28:30 -0500
From: Jarod Wilson <jwilson@redhat.com>
Organization: Red Hat, Inc.
To: linux1394-devel@lists.sourceforge.net
Subject: Re: [PATCH] firewire: reread config ROM when device reset the bus
Date: Mon, 3 Mar 2008 15:28:05 -0500
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-kernel@vger.kernel.org
References: <tkrat.c6610a8633fe0e41@s5r6.in-berlin.de> <tkrat.da30e6f15a74e036@s5r6.in-berlin.de>
In-Reply-To: <tkrat.da30e6f15a74e036@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803031528.05135.jwilson@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 02 March 2008 07:48:30 pm Stefan Richter wrote:
> When a device changes its configuration ROM, it announces this with a
> bus reset.  firewire-core has to check which node initiated a bus reset
> and whether any unit directories went away or were added on this node.
>
> Tested with an IOI FWB-IDE01AB which has its link-on bit set if bus
> power is available but does not respond to ROM read requests if self
> power is off.  This implements
>   - recognition of the units if self power is switched on after fw-core
>     gave up the initial attempt to read the config ROM,
>   - shutdown of the units when self power is switched off.
>
> Also tested with a second PC running Linux/ieee1394.  When the eth1394
> driver is inserted and removed on that node, fw-core now notices the
> addition and removal of the IPv4 unit on the ieee1394 node.
>
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> ---
>
> Applies after "firewire: replace static ROM cache by allocated cache".

I've also tested and verified proper disk suspend (and resume) functionality 
with a FW800 Western Digital My Book Pro and a FW400 Western Digital My Book, 
both of which were previously unable to power down their disks.

Signed-off-by: Jarod Wilson <jwilson@redhat.com>


-- 
Jarod Wilson
jwilson@redhat.com
