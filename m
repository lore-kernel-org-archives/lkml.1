Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004Ab0CIQBQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 11:01:16 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:11895 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973Ab0CIQBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 11:01:12 -0500
X-IronPort-AV: E=Sophos;i="4.49,608,1262563200"; 
   d="scan'208";a="9859503"
Date: Tue, 9 Mar 2010 16:05:16 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: [PATCH SERIES v2] enhanced PV on Xen HVM
Message-ID: <alpine.DEB.2.00.1003091528070.8337@kaball-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
this patch series is derived from an earlier version of Shen's "PV
extension of HVM" patch series.
It tries to achieve two goals:

- enable PV devices in Linux running in a Xen HVM domain;

- receive evtchns in place of interrupts to avoid expensive EOIs.

The main difference between the two patch series is the way the second
goals is achieved: in this patch series I am trying to reuse the same
code that is used in the Linux kernel to setup GSI to pirq mappings when
running as dom0.
In this case the GSIs that are being remapped correspond to emulated
interrupts, but Xen knows the difference and handles the two cases
separately.

The new version includes:

- a cleanup of the xen pci platform driver (thanks to Bastian Blank for
  the review);
- smp now working;
- pci passthrough now working, the guest is receiving evtchns in place
of interrupts (MSI are not supported yet);
- other minor bug fixes.

The patch series consists of 6 patches, 1 for Xen and 5 for Linux (they
are generated again the pvops tree, xen/dom0/apic-xiantao branch);
each patch comes with a detailed description.

Any comment, critic or suggestion is very welcome.

Cheers,

Stefano
