Return-Path: <linux-kernel-owner+w=401wt.eu-S1752069AbXEXRPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069AbXEXRPe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 13:15:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750702AbXEXRPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 13:15:22 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:35997 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750769AbXEXRPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 13:15:20 -0400
Subject: RE: [PATCH] [scsi] Remove __GFP_DMA
From: James Bottomley <James.Bottomley@SteelEye.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>,
       Aubrey Li <aubreylee@gmail.com>, Bernhard Walle <bwalle@suse.de>,
       linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.64.0705240959310.28086@schroedinger.engr.sgi.com>
References: <AE4F746F2AECFC4DA4AADD66A1DFEF019E1CAA@otce2k301.adaptec.com>
	 <1180018752.3692.16.camel@mulgrave.il.steeleye.com>
	 <Pine.LNX.4.64.0705240959310.28086@schroedinger.engr.sgi.com>
Content-Type: text/plain
Date: Thu, 24 May 2007 12:15:17 -0500
Message-Id: <1180026917.3692.47.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-24 at 10:00 -0700, Christoph Lameter wrote:
> On Thu, 24 May 2007, James Bottomley wrote:
> 
> > > Going to ensure that we have a 31 bit (not 32 bit) physical address?
> > 
> > No, unfortunately.  Implementing kmalloc_mask() and kmalloc_dev() was
> > something I said I'd do ... about two years ago.
> 
> Tell me more about these ideas. 

Oh, it was this Kernel Summit presentation which discussed it

http://licensing.steeleye.com/support/papers/kernel_summit_iommu.pdf

The writeup of the session is here:

http://lwn.net/Articles/144100/

The idea was basically to match an allocation to a device mask.  I was
going to do a generic implementation (which would probably kmalloc,
check the physaddr and fall back to GFP_DMA if we were unlucky) but
allow the architectures to override.

However, the majority of need (except for the aacraid like devices) was
solved by GFP_DMA32

James


