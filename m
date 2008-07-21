Return-Path: <linux-kernel-owner+w=401wt.eu-S1756943AbYGUPQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943AbYGUPQw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 11:16:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754027AbYGUPQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 11:16:31 -0400
Received: from sh.osrg.net ([192.16.179.4]:46421 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752610AbYGUPQa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 11:16:30 -0400
Date: Tue, 22 Jul 2008 00:16:13 +0900
To: prarit@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH]: iommu fix potential overflow in alloc_iommu()
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080721141501.3720.4565.sendpatchset@prarit.bos.redhat.com>
References: <20080721141501.3720.4565.sendpatchset@prarit.bos.redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080722001317N.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jul 2008 10:15:22 -0400
Prarit Bhargava <prarit@redhat.com> wrote:

> (This didn't appear on LKML or any of the mirrors ... trying again)
> 
> It is possible that alloc_iommu()'s boundary_size overflows as
> dma_get_seg_boundary can return 0xffffffff.  In that case, further usage of
> boundary_size triggers a BUG_ON() in the iommu code.

Did you actually hit this? pci-gart_64.c is used only by X86_64.
