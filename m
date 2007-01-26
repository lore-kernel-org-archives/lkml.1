Return-Path: <linux-kernel-owner+w=401wt.eu-S932838AbXAZLIO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932838AbXAZLIO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 06:08:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932886AbXAZLIO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 06:08:14 -0500
Received: from smtp.osdl.org ([65.172.181.24]:56040 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932838AbXAZLIN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 06:08:13 -0500
Date: Fri, 26 Jan 2007 03:07:53 -0800
From: Andrew Morton <akpm@osdl.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Christoph Lameter <clameter@engr.sgi.com>
Subject: Re: [PATCH 0/8] Create ZONE_MOVABLE to partition memory between
 movable and non-movable pages
Message-Id: <20070126030753.03529e7a.akpm@osdl.org>
In-Reply-To: <20070125234458.28809.5412.sendpatchset@skynet.skynet.ie>
References: <20070125234458.28809.5412.sendpatchset@skynet.skynet.ie>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Jan 2007 23:44:58 +0000 (GMT)
Mel Gorman <mel@csn.ul.ie> wrote:

> The following 8 patches against 2.6.20-rc4-mm1 create a zone called
> ZONE_MOVABLE

Argh.  These surely get all tangled up with the
make-zones-optional-by-adding-zillions-of-ifdef patches:

deal-with-cases-of-zone_dma-meaning-the-first-zone.patch
introduce-config_zone_dma.patch
optional-zone_dma-in-the-vm.patch
optional-zone_dma-in-the-vm-no-gfp_dma-check-in-the-slab-if-no-config_zone_dma-is-set.patch
optional-zone_dma-in-the-vm-no-gfp_dma-check-in-the-slab-if-no-config_zone_dma-is-set-reduce-config_zone_dma-ifdefs.patch
optional-zone_dma-for-ia64.patch
remove-zone_dma-remains-from-parisc.patch
remove-zone_dma-remains-from-sh-sh64.patch
set-config_zone_dma-for-arches-with-generic_isa_dma.patch
zoneid-fix-up-calculations-for-zoneid_pgshift.patch

My objections to those patches:

- They add zillions of ifdefs

- They make the VM's behaviour diverge between different platforms and
  between differen configs on the same platforms, and hence degrade
  maintainability and increase complexity.

- We kicked around some quite different ways of implementing the same
  things, but nothing came of it.  iirc, one was to remove the hard-coded
  zones altogether and rework all the MM to operate in terms of

	for (idx = 0; idx < NUMBER_OF_ZONES; idx++)
		...

- I haven't seen any hard numbers to justify the change.

So I want to drop them all.
