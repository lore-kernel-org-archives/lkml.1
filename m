Return-Path: <linux-kernel-owner+w=401wt.eu-S1755392AbZJ1Rxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392AbZJ1Rxx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 13:53:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755340AbZJ1Rxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 13:53:52 -0400
Received: from nfitmail.nfit.au.dk ([130.225.31.129]:11421 "EHLO
	smtp.nfit.au.dk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755338AbZJ1Rxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 13:53:52 -0400
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl
Subject: [PATCH 0/2] Some fixes to debug_kmap_atomic()
From: Soeren Sandmann <sandmann@daimi.au.dk>
Date: 28 Oct 2009 18:53:55 +0100
Message-ID: <ye84opj9zgs.fsf@camel23.daimi.au.dk>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-NFIT-RelayAddr: 130.225.16.142
X-NFIT-Solido-Score: 3.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

Here are two patches that fix an issue with debug_kmap_atomic(). 

The first one is a pretty straightforward fix for a race that can
cause an underflow, which in turn causes the stream of warnings to
never end.

The second patch extends debug_kmap_atomic() to deal with KM_IRQ_PTE,
KM_NMI, and KM_NMI_PTE.

I was seeing this because the __get_user_pages_fast() in
arch/x86/kernel/cpu/perf_events.c ends up eventually calling
kmap_atomic() with KM_PTE, which, with CONFIG_HIGHPTE enabled, ends up
expanding to:

#define __KM_PTE                        \
        (in_nmi() ? KM_NMI_PTE :        \
         in_irq() ? KM_IRQ_PTE :        \
         KM_PTE0)

and those KM_* types are not handled 

For the second patch, I am basically pattern matching, so I might be
completely wrong.


Thanks,
Soren

