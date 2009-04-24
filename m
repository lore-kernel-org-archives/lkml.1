Return-Path: <linux-kernel-owner+w=401wt.eu-S1756780AbZDXMTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756780AbZDXMTR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 08:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753607AbZDXMTC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 08:19:02 -0400
Received: from wa4ehsobe002.messaging.microsoft.com ([216.32.181.12]:4894 "EHLO
	WA4EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753310AbZDXMTA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 08:19:00 -0400
X-BigFish: VPS-43(zz1432R98dR936eQ1447R1805M936fK8c8aizz1202hzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KILU74-04-TSN-01
Date: Fri, 24 Apr 2009 14:18:40 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: David Vrabel <david.vrabel@csr.com>
CC: Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: dma_debug_device_change() gives bogus errors
Message-ID: <20090424121840.GO17438@amd.com>
References: <49F1A064.6040100@csr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <49F1A064.6040100@csr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 24 Apr 2009 12:18:41.0177 (UTC) FILETIME=[CDCFE890:01C9C4D6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 24, 2009 at 12:20:04PM +0100, David Vrabel wrote:
> dma_debug_device_change() gives bogus errors if a driver unmaps dma
> buffers within its driver->remove() method.  This is because the
> BUS_NOTIFY_UNBIND_DRIVER notification is raised before calling
> driver->remove() (see __device_release_driver() in drivers/base/dd.c).
> 
> By the time my driver->remove() completes, there are no DMA mappings
> (debug_dma_dump_mappings() produces no output).
> 
> Also, somewhat surprisingly, it only prints the error the first time the
> driver is unbound.

Thanks for the report. This is being worked on already. I will disable
this check for 2.6.30 and try to get a solution upstream for 2.6.31.

Joerg

-- 
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
 System    | 
 Research  | Geschäftsführer: Jochen Polster, Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
           | Registergericht München, HRB Nr. 43632

