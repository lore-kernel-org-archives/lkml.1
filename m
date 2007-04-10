Return-Path: <linux-kernel-owner+w=401wt.eu-S966123AbXDJJMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966123AbXDJJMj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 05:12:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966137AbXDJJMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 05:12:38 -0400
Received: from mx1.suse.de ([195.135.220.2]:53442 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966123AbXDJJMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 05:12:38 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: David Miller <davem@davemloft.net>
Subject: Re: [patch 5/8] [Intel IOMMU] Graphics driver workarounds to provide unity map
Date: Tue, 10 Apr 2007 11:12:17 +0200
User-Agent: KMail/1.9.6
Cc: hch@infradead.org, ashok.raj@intel.com, linux-kernel@vger.kernel.org,
       akpm@osdl.org, gregkh@suse.de, muli@il.ibm.com,
       asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       anil.s.keshavamurthy@intel.com, arjan@linux.intel.com,
       shaohua.li@intel.com
References: <20070409215552.221374000@intel.com> <20070410083351.GA19691@infradead.org> <20070410.020702.88477115.davem@davemloft.net>
In-Reply-To: <20070410.020702.88477115.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704101112.17869.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 April 2007 11:07:02 David Miller wrote:
> From: Christoph Hellwig <hch@infradead.org>
> Date: Tue, 10 Apr 2007 09:33:51 +0100
> 
> > On Mon, Apr 09, 2007 at 02:55:57PM -0700, Ashok Raj wrote:
> > > Most GFX drivers don't call standard PCI DMA APIs to allocate DMA buffer,
> > > Such drivers will be broken with IOMMU enabled. To workaround this issue, 
> > > we added two options.
> > 
> > All drm drivers do it.  If the usual out of tree crap vendors are too
> > stupid for their own sake it's their fault.
> > 
> > So NACK to this patch.
> 
> That's my feeling as well, everything we care about should be using
> the proper APIs or else what is the point of them...

They can't. There is no proper API to do IOMMU mappings from user space.
And that is how Xorg on x86 works.

I had some hackish patches to enable mapping on /sys/bus/pci/.../coherent_mem, but
you need ioctls to pass out the translated address and it wasn't
exactly pretty. Still also not sure that's the right way.

-Andi
