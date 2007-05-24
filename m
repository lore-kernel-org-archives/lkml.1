Return-Path: <linux-kernel-owner+w=401wt.eu-S1758026AbXEXKES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758026AbXEXKES (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 06:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755666AbXEXKEB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 06:04:01 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:55358 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754768AbXEXKEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 06:04:00 -0400
Date: Thu, 24 May 2007 11:08:27 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Robert Hancock <hancockr@shaw.ca>
Cc: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>,
       James Bottomley <James.Bottomley@SteelEye.com>,
       Aubrey Li <aubreylee@gmail.com>, Christoph Lameter <clameter@sgi.com>,
       Bernhard Walle <bwalle@suse.de>, linux-scsi@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [scsi] Remove __GFP_DMA
Message-ID: <20070524110827.65e49b78@the-village.bc.nu>
In-Reply-To: <46552292.3090207@shaw.ca>
References: <fa.6bUV4KR+za7HW4tT2WBlccqvoq0@ifi.uio.no>
	<fa.NYl60pD1cwd1ESdKNCPaOwSz1WA@ifi.uio.no>
	<fa.hW9tQQfgwmXj0gAKQoWXOxVzpvk@ifi.uio.no>
	<fa.xLFpJ54sTvGq6YIol2Ew31Rrq2s@ifi.uio.no>
	<fa.JZsPKKyEKOAfxp6reMY5ZwSNjQU@ifi.uio.no>
	<fa.txrEcCPLxIukzeVBv7UG39WubcI@ifi.uio.no>
	<46552292.3090207@shaw.ca>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > That didn't used to work right on the AMD boards when I tried it last as
> > we ended up with a buffer that was mapped by the IOMMU for some reason
> > and that was not below 2GB.
> 
> The physical address you mean? If that is still happening then it needs 
> to get fixed. The allocation should not succeed if it can't provide 
> memory that's inside the DMA mask for the device..

But the allocation can succeed - using GFP_DMA at least you can do it as
you get memory below 2^24 you don't need to map via the IOMMU
