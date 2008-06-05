Return-Path: <linux-kernel-owner+w=401wt.eu-S1757192AbYFEOte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757192AbYFEOte (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 10:49:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754018AbYFEOtY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 10:49:24 -0400
Received: from sh.osrg.net ([192.16.179.4]:32908 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753928AbYFEOtY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 10:49:24 -0400
Date: Thu, 5 Jun 2008 23:49:11 +0900
To: andi@firstfloor.org
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       mgross@linux.intel.com, linux-scsi@vger.kernel.org
Subject: Re: Intel IOMMU (and IOMMU for Virtualization) performances
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <873antuojg.fsf@basil.nowhere.org>
References: <20080604235053K.fujita.tomonori@lab.ntt.co.jp>
	<873antuojg.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080605231914Z.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 Jun 2008 18:56:35 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> writes:
> >
> > I'm just interested in other people's opinions on IOMMU
> > implementations, performances, possible future changes for performance
> > improvement, etc.
> 
> I think using the bitmap is an excellent idea and your numbers look good. 
> Do you have numbers on the memory consumption too?
> Trading some memory for performance is ok for something as performance critical 
> as the IOMMU. 

If we use 4GB virtual DMA address space (as the patch does), we need
128 KB for the bitmap for one domain.

With the RB tree, the memory consumption depends on how many addresses
are mapped (it needs one entry for one address though we could merge
multiple addresses).
