Return-Path: <linux-kernel-owner+w=401wt.eu-S1764336AbYEOSZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764336AbYEOSZj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 14:25:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761901AbYEOSZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 14:25:06 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:43548 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760910AbYEOSZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 14:25:04 -0400
Subject: Re: [PATCH 0/2] x86: per-device dma_mapping_ops
From: Alexis Bruemmer <alexisb@us.ibm.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: muli@il.ibm.com, linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <20080515113048P.tomof@acm.org>
References: <20080514054924.GD6682@il.ibm.com>
	 <20080515101212Z.tomof@acm.org> <1210816813.5596.13.camel@alexis>
	 <20080515113048P.tomof@acm.org>
Content-Type: text/plain
Date: Thu, 15 May 2008 11:21:07 -0700
Message-Id: <1210875668.5596.18.camel@alexis>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-15 at 11:30 +0900, FUJITA Tomonori wrote:
> On Wed, 14 May 2008 19:00:13 -0700
> Alexis Bruemmer <alexisb@us.ibm.com> wrote:
> 
> > On Thu, 2008-05-15 at 10:12 +0900, FUJITA Tomonori wrote:
> > > On Wed, 14 May 2008 08:49:24 +0300
> > > Muli Ben-Yehuda <muli@il.ibm.com> wrote:
> > > 
> > > > On Tue, May 13, 2008 at 03:04:50PM +0900, FUJITA Tomonori wrote:
> > <snip>
> > > > Awesome! Much needed, thank you for doing this.
> > > 
> > > No problem. Well, as you know, it's just a base. We need more work to
> > > solve the problems on the top of this.
> > Yes thank you!  
> > > 
> > > I'd like to have a mechanism to register a hook called when a new pci
> > > (or dma capable) device is created. It enables IOMMUs to set up an
> > > appropriate dma_mapping_ops per device. It could also enables us to
> > > simplify the IOMMUs code to initilize devices at startup (for exmple,
> > > intel-iommu checks all the pci devices and creates a domain per device
> > > if necessary).
> > I wanted to try and create a test version of this, at least for the
> > calgary side, but ran into an error with this patch set:
> > 
> > Fusion MPT SAS Host driver 3.04.06
> > ACPI: PCI Interrupt 0000:34:00.0[A] -> GSI 142 (level, low) -> IRQ 142
> > mptbase: ioc0: Initiating bringup
> > ioc0: LSISAS1078 C1: Capabilities={Initiator}
> > mptbase: ioc0: PCI-MSI enabled
> > Calgary: DMA error on CalIOC2 PHB 0x33
> > Calgary: 0x02000000@CSR 0x00000000@PLSSR 0xb0008000@CSMR 0x00000000@MCK
> > Calgary: 0x00000000@0x810 0xfee0c000@0x820 0x00000000@0x830
> > 0x00000000@0x840 0x03804a00@0x850 0x00000000@0x860 0x00000000@0x870
> > Calgary: 0x00000000@0xcb0
> > mptbase: ioc0: Initiating recovery
> > mptbase: ioc0: WARNING - Unexpected doorbell active!
> > mptbase: ioc0: WARNING - NOT READY!
> > mptbase: ioc0: WARNING - Cannot recover rc = -1!
> > mptbase: ioc0: WARNING - Firmware Reload FAILED!
> > Clocksource tsc unstable (delta = 48333779773 ns)
> > 
> > Not sure what is causing this error, but will keep digging.  Any ideas?
> 
> Hmm, you don't hit this without my patches, right?
oops, you are right, this failure was due to a .config change not your
patch set (MSI not behaving on MegaRAID).  Sorry for the false alarm.
Your patches work as expected.  

