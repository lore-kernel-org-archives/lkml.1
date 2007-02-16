Return-Path: <linux-kernel-owner+w=401wt.eu-S1423188AbXBPEr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423188AbXBPEr7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 23:47:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423189AbXBPErp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 23:47:45 -0500
Received: from dsl092-017-127.sfo4.dsl.speakeasy.net ([66.92.17.127]:36056
	"EHLO mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1423188AbXBPEpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 23:45:25 -0500
Message-Id: <20070216022449.739760547@goop.org>
User-Agent: quilt/0.46-1
Date: Thu, 15 Feb 2007 18:24:49 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@muc.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>
Subject: [patch 00/21] Xen-paravirt: Xen guest implementation for paravirt_ops interface
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

This patch series implements the Linux Xen guest in terms of the
paravirt-ops interface.  The features in implemented this patch series
are:
 * domU only
 * UP only (most code is SMP-safe, but there's no way to create a new vcpu)
 * writable pagetables, with late pinning/early unpinning
   (no shadow pagetable support)
 * supports both PAE and non-PAE modes
 * xen console
 * virtual block device (blockfront)
 * virtual network device (netfront)

The patch series is in two parts:

1-12: cleanups to the core kernel, either to fix outright problems,
      or to add appropriate hooks for Xen
13-21: the Xen guest implementation itself

I've tried to make each patch as self-explanatory as possible.  The
series is based on git changeset
ec2f9d1331f658433411c58077871e1eef4ee1b4 +
x86_64-2.6.20-git8-070213-1.patch.

Changes since the previous posting:
- rebased
- addressed review comments:
 - deal with missing vga hardware better
 - deal with Andi's comments
 - clean up header file placement
 - update netfront, and move it into drivers/net

I looked at linking in xen-head.S rather than including it into
xen-head.S, but it seems to provoke linker bugs, so I've left it as-is
for now.

Thanks,
	J

-- 

