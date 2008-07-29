Return-Path: <linux-kernel-owner+w=401wt.eu-S1757008AbYG2Rke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757008AbYG2Rke (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 13:40:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752658AbYG2RkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 13:40:22 -0400
Received: from mga09.intel.com ([134.134.136.24]:6214 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752503AbYG2RkW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 13:40:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,273,1215414000"; 
   d="scan'208";a="423495860"
Message-Id: <20080729172917.185593000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Tue, 29 Jul 2008 10:29:17 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       arjan@linux.intel.com, roland@redhat.com, drepper@redhat.com,
       mikpe@it.uu.se, chrisw@sous-sol.org, andi@firstfloor.org
Cc: linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com
Subject: [patch 0/9] x86, xsave: xsave/xrstor support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds the support for xsave/xrstor infrastructure for x86.
xsave/xrstor manages the existing and future processor extended states in x86
architecutre.

More info on xsave/xrstor can be found in the Intel SDM's located at
http://www.intel.com/products/processor/manuals/index.htm

The layout of the xsave/xrstor area extends from the 512-byte FXSAVE/FXRSTOR
layout.  xsave/xrstor area layout consists of:

     - fxsave/fxrstor area (512 bytes)
     - xsave header area (64 bytes)
     - set of save areas, each corresponding to a processor extended state

The number of save areas, the offset and the size of each save area is
enumerated by CPUID leaf function 0xd. 

This patch includes the basic xsave/xrstor infrastructure(supporting FP/SSE),
which includes:
      - context switch support,  extending traditional lazy restore mechanism
      - signal handling support, extending(using the software reserved bytes
	464..511 in the current 512byte layout of fxsave frame) the memory
	layout pointed out by the fpstate pointer in the sigcontext

More details in the patches to follow.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

