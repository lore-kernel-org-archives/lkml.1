Return-Path: <linux-kernel-owner+w=401wt.eu-S1751307AbXEXO70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751307AbXEXO70 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 10:59:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750799AbXEXO7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 10:59:17 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:43864 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750758AbXEXO7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 10:59:15 -0400
Subject: RE: [PATCH] [scsi] Remove __GFP_DMA
From: James Bottomley <James.Bottomley@SteelEye.com>
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: Aubrey Li <aubreylee@gmail.com>, Christoph Lameter <clameter@sgi.com>,
       Bernhard Walle <bwalle@suse.de>, linux-scsi@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <AE4F746F2AECFC4DA4AADD66A1DFEF019E1CAA@otce2k301.adaptec.com>
References: <AE4F746F2AECFC4DA4AADD66A1DFEF019E1CAA@otce2k301.adaptec.com>
Content-Type: text/plain
Date: Thu, 24 May 2007 09:59:12 -0500
Message-Id: <1180018752.3692.16.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-24 at 09:24 -0400, Salyzyn, Mark wrote:
> So, is the sequence:
> 
> 	p = kmalloc(upsg->sg[i].count,GFP_KERNEL);
> 	. . .
> 	addr = pci_map_single(dev->pdev, p, upsg->sg[i].count,
> data_dir);
> 
> Going to ensure that we have a 31 bit (not 32 bit) physical address?

No, unfortunately.  Implementing kmalloc_mask() and kmalloc_dev() was
something I said I'd do ... about two years ago.

> If not, then I reject this patch. We can not consider replacement with
> pci_alloc_consistent until it works on AMD respecting the DMA masks.

It should, I believe ... x86_64 has a complex allocation scheme where
for masks < 32 bit it first tries in GFP_DMA32 and sees if it gets lucky
before falling back to GFP_DMA. i386 just goes straight to GFP_DMA.

James


