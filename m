Return-Path: <linux-kernel-owner+w=401wt.eu-S932774AbXB0IiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932774AbXB0IiV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 03:38:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932819AbXB0IiU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 03:38:20 -0500
Received: from gw.goop.org ([64.81.55.164]:46785 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932774AbXB0IiT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 03:38:19 -0500
Message-Id: <20070227081337.434798469@goop.org>
User-Agent: quilt/0.46-1
Date: Tue, 27 Feb 2007 00:13:37 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@muc.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: [patch 00/26] Xen-paravirt_ops: Xen guest implementation for paravirt_ops interface
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

This patch series implements the Linux Xen guest as a paravirt_ops
backend.  The features in implemented this patch series are:
 * domU only
 * UP only (most code is SMP-safe, but there's no way to create a new vcpu)
 * writable pagetables, with late pinning/early unpinning
   (no shadow pagetable support)
 * supports both PAE and non-PAE modes
 * xen hvc console (console=hvc0)
 * virtual block device (blockfront)
 * virtual network device (netfront)

The patch series is in three parts:
  1- 2	Cleanup patches to various parts of the kernel
  3-14	Extensions to the core code and/or paravirt ops, needed to support
	Xen. Includes hooks into get/setting pte values and the new
	patching machinery.
 15-26	The Xen paravirt_ops implementation itself.

(Some of the earlier patches in the series have already been posted,
 but are included to make the series self-contained.)

I've tried to make each patch as self-explanatory as possible.  The
series is based on 2.6.21-rc1.

Changes since the previous posting:
- implemented new patching scheme, which should make the overhead of
  running on native approach zero, and Xen overhead a fair bit lower
- rebased
- some small review comment updates
- trailing whitespace stripped
- accurate diffstats

Thanks,
	J
-- 

