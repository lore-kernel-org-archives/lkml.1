Return-Path: <linux-kernel-owner+w=401wt.eu-S1756836AbZE2IoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836AbZE2IoU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 04:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756656AbZE2IoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 04:44:08 -0400
Received: from smtp.citrix.com ([66.165.176.89]:7951 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756433AbZE2IoG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 04:44:06 -0400
X-IronPort-AV: E=Sophos;i="4.41,270,1241409600"; 
   d="scan'208";a="4461765"
From: Ian Campbell <ian.campbell@citrix.com>
To: <linux-kernel@vger.kernel.org>
CC: Ian Campbell <ian.campbell@citrix.com>,
       Becky Bruce <beckyb@kernel.crashing.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Greg KH <gregkh@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Kumar Gala <galak@kernel.crashing.org>, Olaf Kirch <okir@suse.de>,
       Tony Luck <tony.luck@intel.com>, <linux-ia64@vger.kernel.org>,
       <linuxppc-dev@ozlabs.org>, <x86@kernel.org>
Subject: 
Date: Fri, 29 May 2009 09:43:54 +0100
Message-ID: <1243586643-5554-1-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.5.6.5
swiotlb: Introduce architecture-specific APIs to replace __weak functions
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series:
* removes the swiotlb_(arch_)_phys_to_bus and bus_to_phys __weak
  hooks, replacing them with an architecture-specific phys_to_dma and
  dma_to_phys interface. These are used by both PowerPC and Xen to
  provide the correct mapping from physical to DMA addresses.
* removes the swiotlb_address_needs_mapping and
  swiotlb_range_needs_mapping __weak functions as well as
  is_buffer_dma_capable (which should never have been a generic
  function). All three are replaced by a single architecture-specific
  interface which meets the needs of both PowerPC and Xen.
* removes the swiotlb_virt_to_bus __weak function and replaces it with
  a CONFIG_HIGHMEM compatible version when high memory is in use. This
  is needed for 32 bit PowerPC swiotlb support.

I think these new interfaces are cleaner than the existing __weak
functions and isolate the swiotlb code from architecture internals.

This series does not contain any Xen or PowerPC specific changes, those
will follow in separate postings. The complete patchset has been boot
tested under Xen and native-x86 and compiled for IA64 and PowerPC

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Becky Bruce <beckyb@kernel.crashing.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Greg KH <gregkh@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Olaf Kirch <okir@suse.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: linux-ia64@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org
Cc: x86@kernel.org
