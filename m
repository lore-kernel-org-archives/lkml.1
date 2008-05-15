Return-Path: <linux-kernel-owner+w=401wt.eu-S1753097AbYEOU0H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753097AbYEOU0H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 16:26:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752444AbYEOUZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 16:25:08 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:31436 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126AbYEOUZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 16:25:06 -0400
Date: Thu, 15 May 2008 18:17:41 +0300
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Alexis Bruemmer <alexisb@us.ibm.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 0/2] x86: per-device dma_mapping_ops
Message-ID: <20080515151741.GF6778@il.ibm.com>
References: <1210658692-960-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <20080514054924.GD6682@il.ibm.com> <20080515101212Z.tomof@acm.org> <1210816813.5596.13.camel@alexis>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1210816813.5596.13.camel@alexis>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2008 at 07:00:13PM -0700, Alexis Bruemmer wrote:

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

Calgary caught an errant DMA. If it was working before, we are
probably mis-programming the TCE tables. The first thing to check is
whether all dma_map_xxx calls by mptbase end up calling the Calgary
dma_ops.

Cheers,
Muli
