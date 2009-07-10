Return-Path: <linux-kernel-owner+w=401wt.eu-S1755994AbZGJOCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994AbZGJOCY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 10:02:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755302AbZGJOCE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 10:02:04 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:44456 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754706AbZGJOCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 10:02:03 -0400
X-IronPort-AV: E=Sophos;i="4.42,378,1243828800"; 
   d="scan'208";a="57943485"
Subject: Re: [00/15] swiotlb cleanup
From: Ian Campbell <Ian.Campbell@citrix.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: <mingo@elte.hu>, <jeremy@goop.org>, <linux-kernel@vger.kernel.org>,
       <linux-ia64@vger.kernel.org>, <linuxppc-dev@ozlabs.org>,
       <benh@kernel.crashing.org>, <tony.luck@intel.com>, <x86@kernel.org>,
       <beckyb@kernel.crashing.org>, <joerg.roedel@amd.com>
In-Reply-To: <20090710143408A.fujita.tomonori@lab.ntt.co.jp>
References: <1247187904-31999-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	 <20090710051236.GA22218@elte.hu>
	 <20090710143408A.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain
Organization: Citrix Systems, Inc.
Date: Fri, 10 Jul 2009 15:02:00 +0100
Message-ID: <1247234520.4002.418.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-07-10 at 14:35 +0900, FUJITA Tomonori wrote:
> I don't think that we need to take account of dom0 support; we don't
> have a clear idea about an acceptable dom0 design (it needs to use
> swiotlb code? I don't know yet), we don't even know we will have dom0
> support in mainline. That's why I didn't CC this patchset to Xen
> camp.

The core domain 0 patches which were the subject of the discussions a
few week back are completely orthogonal to the swiotlb side of things
and whatever form they eventually take I do not think it will have any
impact on the shape of the solution which we arrive at for swiotlb. I
don't think that assuming that domain 0 can never be done in a way which
everyone finds acceptable and therefore discounting all consideration of
it is a useful way to make progress with these issues.

The DMA use case is much more tightly tied to the paravirtualized MMU
(which is already in the kernel for domU purposes) than it is to "the
domain 0" patches anyway. Although domain 0 is probably the main use
case, at least today, swiotlb support is also used in a Xen domU as part
of the support for direct assignment of PCI devices to paravirtualised
guests (pci passthrough).

The pci frontend driver depends on some bits of the domain 0 physical
interrupt patches as well as swiotlb which is why I/we haven't tried to
upstream that particular series yet.

Ian.


