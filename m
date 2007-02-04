Return-Path: <linux-kernel-owner+w=401wt.eu-S1752547AbXBDUiJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547AbXBDUiJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 15:38:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752548AbXBDUiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 15:38:09 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:43901 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547AbXBDUiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 15:38:08 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <45C643BF.80204@s5r6.in-berlin.de>
Date: Sun, 04 Feb 2007 21:36:15 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.9) Gecko/20070121 SeaMonkey/1.0.7
MIME-Version: 1.0
To: stable@kernel.org
CC: David Moore <dcm@MIT.EDU>, linux-kernel <linux-kernel@vger.kernel.org>,
       discuss@x86-64.org, akpm@linux-foundation.org,
       linux1394-devel <linux1394-devel@lists.sourceforge.net>,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: [PATCH] Missing critical phys_to_virt in lib/swiotlb.c
References: <1170614380.26464.52.camel@PISCES.MIT.EDU>
In-Reply-To: <1170614380.26464.52.camel@PISCES.MIT.EDU>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Moore wrote:
[...]
> considering the severity of this one-liner bug, I would like to
> request that this simplified patch make it into 2.6.20, despite how
> close we are to the final cut.

So we were too close. Maybe the -stable team likes to have it in 2.6.20.1.

> It fixes real crashes:
> http://lists.opensuse.org/opensuse-bugs/2006-12/msg02943.html
> http://qa.mandriva.com/show_bug.cgi?id=28224
> http://www.pchdtv.com/forum/viewtopic.php?t=2063&sid=a959a14a4c2db0eebaab7b0df56103ce

and FireWire crashes too.

> --- linux-2.6.19.x86_64/lib/swiotlb.c.orig	2007-02-04 13:18:41.000000000 -0500
> +++ linux-2.6.19.x86_64/lib/swiotlb.c	2007-02-04 13:19:43.000000000 -0500
> @@ -750,7 +750,7 @@ swiotlb_sync_sg(struct device *hwdev, st
>  
>  	for (i = 0; i < nelems; i++, sg++)
>  		if (sg->dma_address != SG_ENT_PHYS_ADDRESS(sg))
> -			sync_single(hwdev, (void *) sg->dma_address,
> +			sync_single(hwdev, phys_to_virt(sg->dma_address),
>  				    sg->dma_length, dir, target);
>  }
>  
-- 
Stefan Richter
-=====-=-=== --=- --=--
http://arcgraph.de/sr/
