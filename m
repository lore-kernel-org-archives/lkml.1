Return-Path: <linux-kernel-owner+w=401wt.eu-S1756989AbYAYF6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756989AbYAYF6S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 00:58:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753555AbYAYF6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 00:58:05 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:44085 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752878AbYAYF6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 00:58:04 -0500
Message-Id: <20080125055606.102986685@sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 24 Jan 2008 21:56:06 -0800
From: Christoph Lameter <clameter@sgi.com>
To: Andrea Arcangeli <andrea@qumranet.com>
Cc: Robin Holt <holt@sgi.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>
Cc: Nick Piggin <npiggin@suse.de>, kvm-devel@lists.sourceforge.net
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: daniel.blueman@quadrics.com, Hugh Dickins <hugh@veritas.com>
Subject: [patch 0/4] [RFC] MMU Notifiers V1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patchset implementing MMU notifier callbacks based on Andrea's
earlier work. These are needed if Linux pages are referenced from something
else than tracked by the rmaps of the kernel.

To do:

- Make locking requirements for the callbacks consistent and
  document them accurately.
- Insure that the callbacks are complete
- Feedback from uses of the callbacks for KVM, RDMA, XPmem and GRU

Andrea's mmu_notifier #4 -> RFC V1

- Merge subsystem rmap based with Linux rmap based approach
- Move Linux rmap based notifiers out of macro
- Try to account for what locks are held while the notifiers are
  called.
- Develop a patch sequence that separates out the different types of
  hooks so that it is easier to review their use.
- Avoid adding #include to linux/mm_types.h
- Integrate RCU logic suggested by Peter.

-- 
