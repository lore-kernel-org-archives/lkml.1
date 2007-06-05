Return-Path: <linux-kernel-owner+w=401wt.eu-S1765061AbXFEPPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765061AbXFEPPY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 11:15:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763612AbXFEPOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 11:14:41 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53427 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755599AbXFEPOg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 11:14:36 -0400
Message-Id: <20070605150523.786600000@chello.nl>
User-Agent: quilt/0.46-1
Date: Tue, 05 Jun 2007 17:05:23 +0200
Cc: Ollie Wild <aaw@google.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>
To: linux-kernel@vger.kernel.org, parisc-linux@lists.parisc-linux.org,
       linux-mm@kvack.org, linux-arch@vger.kernel.org
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 0/4] no MAX_ARG_PAGES
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This patch-set aims at removing the current limit on argv+env space aka.
MAX_ARG_PAGES.

The new mm is created before the binfmt code runs, the stack is placed at the
highest address supported by that architecture.

The argv+env data is then copied from the old mm into the new mm (which is
inactive at that time - this introduces some cache coherency issues).

Then we run the binfmt code, which will compute the final stack address. The
existing stack will be moved downwards (or upwards on PA-RISC) to the desired
place.

This 'trick' heavily relies on the MMU, so for no-MMU archs we stay with the
old approach.

Tested-on: i386, ia64, frv, parisc, ppc64, um, x86_64

Patches against: .22-rc4

-- 
Changes since last time:

 - fixed ia64
     ( va-space constraints )

 - fixed ia64 CONFIG_IA32_SUPPORT
     ( brown paper bags and more va-space constraints)

 - fixed powerpc
     ( address limit on stack extention )

 - removed audit_kill() in favour of audit_panic()

 - nicely spit out the patches

