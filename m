Return-Path: <linux-kernel-owner+w=401wt.eu-S1764241AbYEOU0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764241AbYEOU0s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 16:26:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752780AbYEOUZg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 16:25:36 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:61736 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760225AbYEOUZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 16:25:33 -0400
Date: Thu, 15 May 2008 18:15:10 +0300
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       alexisb@us.ibm.com
Subject: Re: [PATCH 0/2] x86: per-device dma_mapping_ops
Message-ID: <20080515151510.GE6778@il.ibm.com>
References: <1210658692-960-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <20080514054924.GD6682@il.ibm.com> <20080515101212Z.tomof@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080515101212Z.tomof@acm.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2008 at 10:12:25AM +0900, FUJITA Tomonori wrote:
> On Wed, 14 May 2008 08:49:24 +0300
> Muli Ben-Yehuda <muli@il.ibm.com> wrote:
> 
> > On Tue, May 13, 2008 at 03:04:50PM +0900, FUJITA Tomonori wrote:
> > 
> > > This patchset adds per-device dma_mapping_ops support for
> > > CONFIG_X86_64 like POWER architecture does. This change enables us
> > > to cleanly fix the Calgary IOMMU issue that some devices are not
> > > behind the IOMMU [1]. It also would be helpful to handle KVM PCI
> > > passthrough.
> > 
> > Awesome! Much needed, thank you for doing this.
> 
> No problem. Well, as you know, it's just a base. We need more work
> to solve the problems on the top of this.
> 
> I'd like to have a mechanism to register a hook called when a new
> pci (or dma capable) device is created. It enables IOMMUs to set up
> an appropriate dma_mapping_ops per device.

That's great---it will be needed to support hot-plugging of devices on
systems with isolation-capable IOMMUs.

> It could also enables us to simplify the IOMMUs code to initilize
> devices at startup (for exmple, intel-iommu checks all the pci
> devices and creates a domain per device if necessary).

I'm not sure if it will be easier than the current "loop over all
devices" method, but since we will need it for hotplug anyway, we
might as well just switch to it.

> I'll post an updated version against -mm. If people seems to be fine
> with per-device dma_mapping_ops, then I'll work on further issues.

Excellent.

Cheers,
Muli

