Return-Path: <linux-kernel-owner+w=401wt.eu-S1754090AbYJJCnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090AbYJJCnX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 22:43:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751539AbYJJCmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 22:42:51 -0400
Received: from sh.osrg.net ([192.16.179.4]:49402 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750796AbYJJCmt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 22:42:49 -0400
Date: Fri, 10 Oct 2008 11:40:56 +0900
To: yinghai@kernel.org
Cc: grundler@parisc-linux.org, matthew@wil.cx, jbarnes@virtuousgeek.org,
       mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH] pci: print out DMA mask info
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <48EE8E55.4000009@kernel.org>
References: <86802c440810091451y4a3caceg1abaa75464c40a72@mail.gmail.com>
	<20081009225533.GB1914@colo.lackof.org>
	<48EE8E55.4000009@kernel.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081010114003X.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 09 Oct 2008 16:05:57 -0700
Yinghai Lu <yinghai@kernel.org> wrote:

> Grant Grundler wrote:
> > On Thu, Oct 09, 2008 at 02:51:32PM -0700, Yinghai Lu wrote:
> >> On Thu, Oct 9, 2008 at 2:35 PM, Matthew Wilcox <matthew@wil.cx> wrote:
> >>> Why's that interesting to the sysadmin of the machine?  To the driver
> >>> writer, certainly.  But what's the use of it to the people using the
> >>> machine?
> > ...
> >> make linux kernel act like black box as other os?
> > 
> > I don't understand your reply.
> > If someone thinks linux is a black box, printing this message won't help them.
> > 
> could find out easily why some driver doesn't set dma mask correctly.
> like why 
> 	qlogic qla2xxx only set consistent to 64bit,
> 	emulex lpfc not set consistent to 64bit

IIRC, except for one SGI architecture, coherent_dma_mask is
meaningless, dma_mask is always equal to coherent_dma_mask. Lots of
IOMMU implementations ignore coherent_dma_mask and use dma_mask for
alloc_coherent(). Some drivers doesn't set up coherent_dma_mask.

Theoretically, we need to fix this but it doesn't cause any
problem. That's why nobody cares about it, I guess.
