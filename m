Return-Path: <linux-kernel-owner+w=401wt.eu-S1762184AbXJRAIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762184AbXJRAIR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 20:08:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758874AbXJRAIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 20:08:04 -0400
Received: from ozlabs.org ([203.10.76.45]:52067 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758455AbXJRAID (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 20:08:03 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18198.41946.697397.255427@cargo.ozlabs.ibm.com>
Date: Thu, 18 Oct 2007 10:07:54 +1000
From: Paul Mackerras <paulus@samba.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Matthew Wilcox <willy@debian.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-mm1 - build failure with advansys
In-Reply-To: <20071012235242.9d7daf05.akpm@linux-foundation.org>
References: <20071011213126.cf92efb7.akpm@linux-foundation.org>
	<47104D26.7050206@linux.vnet.ibm.com>
	<20071012235242.9d7daf05.akpm@linux-foundation.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton writes:

> On Sat, 13 Oct 2007 10:14:22 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:

> > The functions virt_to_bus and bus_to_virt are begin defined between ifdef CONFIG_PPC32
> > but when i compile allyesconfig with ppc64 box,i get this error. This patch removes the
> > ifdef.

Which is totally bogus, because virt_to_bus/bus_to_virt only work on
systems without an IOMMU.  Most if not all ppc64 systems have one or
more IOMMUs.  This patch is nacked.

The correct fix is to make advansys depend on CONFIG_VIRT_TO_BUS, or
alternatively fix advansys.c properly by making it use the interfaces
described in Documentation/DMA-mapping.txt (or the equivalent scsi
helpers).

> Please copy the powerpc developers on powerpc patches.

Definitely.

Paul.
