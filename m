Return-Path: <linux-kernel-owner+w=401wt.eu-S1757842AbXEXJ4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757842AbXEXJ4a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 05:56:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755679AbXEXJ4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 05:56:22 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:48933 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755761AbXEXJ4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 05:56:21 -0400
Date: Thu, 24 May 2007 10:57:19 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Paul Mackerras <paulus@samba.org>
Cc: Christoph Lameter <clameter@sgi.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: Define CONFIG_BOUNCE to avoid useless inclusion of bounce
 buffer logic.
Message-ID: <20070524105719.624e43b9@the-village.bc.nu>
In-Reply-To: <18005.2746.374990.29287@cargo.ozlabs.ibm.com>
References: <Pine.LNX.4.64.0705212100420.24947@schroedinger.engr.sgi.com>
	<20070522133906.ae9c362a.kamezawa.hiroyu@jp.fujitsu.com>
	<Pine.LNX.4.64.0705212225590.25388@schroedinger.engr.sgi.com>
	<20070523140702.GA16972@flint.arm.linux.org.uk>
	<Pine.LNX.4.64.0705231011000.19822@schroedinger.engr.sgi.com>
	<18005.2746.374990.29287@cargo.ozlabs.ibm.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Also there is the problem that some drivers use ZONE_DMA allocations
> because their device can only generate addresses below some limit, but
> on a platform with an IOMMU there is in fact no restriction on what
> memory the device can access.

Bzzzzzt - have to call your bluff on that one

The IOMMU mapping window itself may be out of range of some devices. This
is a big problem on AMD64 where the GART window is above the 2GB boundary
- you can do 64->32 nicely but 32->31/30/28/24, all of which turn up on
PC hardware, are no solved by the IOMMU only by GFP_DMA

Alan
