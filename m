Return-Path: <linux-kernel-owner+w=401wt.eu-S1756670AbYEOCg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670AbYEOCg5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 22:36:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751699AbYEOCgt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 22:36:49 -0400
Received: from mo11.iij4u.or.jp ([210.138.174.79]:45002 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750740AbYEOCgs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 22:36:48 -0400
Date: Thu, 15 May 2008 11:30:48 +0900
To: alexisb@us.ibm.com
Cc: fujita.tomonori@lab.ntt.co.jp, muli@il.ibm.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 0/2] x86: per-device dma_mapping_ops
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1210816813.5596.13.camel@alexis>
References: <20080514054924.GD6682@il.ibm.com>
	<20080515101212Z.tomof@acm.org>
	<1210816813.5596.13.camel@alexis>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080515113048P.tomof@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2008 19:00:13 -0700
Alexis Bruemmer <alexisb@us.ibm.com> wrote:

> On Thu, 2008-05-15 at 10:12 +0900, FUJITA Tomonori wrote:
> > On Wed, 14 May 2008 08:49:24 +0300
> > Muli Ben-Yehuda <muli@il.ibm.com> wrote:
> > 
> > > On Tue, May 13, 2008 at 03:04:50PM +0900, FUJITA Tomonori wrote:
> <snip>
> > > Awesome! Much needed, thank you for doing this.
> > 
> > No problem. Well, as you know, it's just a base. We need more work to
> > solve the problems on the top of this.
> Yes thank you!  
> > 
> > I'd like to have a mechanism to register a hook called when a new pci
> > (or dma capable) device is created. It enables IOMMUs to set up an
> > appropriate dma_mapping_ops per device. It could also enables us to
> > simplify the IOMMUs code to initilize devices at startup (for exmple,
> > intel-iommu checks all the pci devices and creates a domain per device
> > if necessary).
> I wanted to try and create a test version of this, at least for the
> calgary side, but ran into an error with this patch set:
> 
> Fusion MPT SAS Host driver 3.04.06
> ACPI: PCI Interrupt 0000:34:00.0[A] -> GSI 142 (level, low) -> IRQ 142
> mptbase: ioc0: Initiating bringup
> ioc0: LSISAS1078 C1: Capabilities={Initiator}
> mptbase: ioc0: PCI-MSI enabled
> Calgary: DMA error on CalIOC2 PHB 0x33
> Calgary: 0x02000000@CSR 0x00000000@PLSSR 0xb0008000@CSMR 0x00000000@MCK
> Calgary: 0x00000000@0x810 0xfee0c000@0x820 0x00000000@0x830
> 0x00000000@0x840 0x03804a00@0x850 0x00000000@0x860 0x00000000@0x870
> Calgary: 0x00000000@0xcb0
> mptbase: ioc0: Initiating recovery
> mptbase: ioc0: WARNING - Unexpected doorbell active!
> mptbase: ioc0: WARNING - NOT READY!
> mptbase: ioc0: WARNING - Cannot recover rc = -1!
> mptbase: ioc0: WARNING - Firmware Reload FAILED!
> Clocksource tsc unstable (delta = 48333779773 ns)
> 
> Not sure what is causing this error, but will keep digging.  Any ideas?

Hmm, you don't hit this without my patches, right?
