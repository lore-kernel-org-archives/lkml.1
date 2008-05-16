Return-Path: <linux-kernel-owner+w=401wt.eu-S1757372AbYEPDq2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757372AbYEPDq2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 23:46:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753575AbYEPDqU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 23:46:20 -0400
Received: from mo11.iij4u.or.jp ([210.138.174.79]:60415 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751553AbYEPDqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 23:46:20 -0400
Date: Fri, 16 May 2008 12:44:52 +0900
To: yhlu.kernel@gmail.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, muli@il.ibm.com, alexisb@us.ibm.com
Subject: Re: [PATCH 2/2] x86: per-device dma_mapping_ops support
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <86802c440805151345g6f272ab1xb1644ac9d655e6e2@mail.gmail.com>
References: <1210658692-960-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1210658692-960-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<86802c440805151345g6f272ab1xb1644ac9d655e6e2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080516120017L.tomof@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2008 13:45:58 -0700
"Yinghai Lu" <yhlu.kernel@gmail.com> wrote:

> On Mon, May 12, 2008 at 11:04 PM, FUJITA Tomonori
> <fujita.tomonori@lab.ntt.co.jp> wrote:
> > This adds per-device dma_mapping_ops support for CONFIG_X86_64.
> >
> > A pointer to dma_mapping_ops to struct dev_archdata is added. If the
> > pointer is non NULL, DMA operations in asm/dma-mapping.h use it. If
> > it's NULL, the system-wide dma_ops pointer is used as before.
> >
> > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > ---
> >  arch/x86/kernel/pci-calgary_64.c |    2 +-
> >  arch/x86/kernel/pci-dma.c        |    2 +-
> >  arch/x86/kernel/pci-gart_64.c    |    2 +-
> >  arch/x86/kernel/pci-nommu.c      |   14 +-----
> >  arch/x86/kernel/pci-swiotlb_64.c |    2 +-
> >  include/asm-x86/device.h         |    3 +
> >  include/asm-x86/dma-mapping.h    |   95 ++++++++++++++++++++++++++------------
> >  7 files changed, 74 insertions(+), 46 deletions(-)

(snip)

> do you have other patch to assign value to dma_ops for every device?
> it is always NULL at this time.

Not yet.

As I said, I plan to implement a mechanism to register a hook called
when a new pci (or dma capable) device is created. It enables IOMMUs
to set up an appropriate dma_mapping_ops per device:

http://lkml.org/lkml/2008/5/14/519

But I wanted to make sure whether per-device dma_ops is useful for
everyone.
