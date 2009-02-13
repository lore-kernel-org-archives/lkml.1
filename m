Return-Path: <linux-kernel-owner+w=401wt.eu-S1758210AbZBMM1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758210AbZBMM1m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 07:27:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750828AbZBMM1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 07:27:35 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33426 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797AbZBMM1e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 07:27:34 -0500
Date: Fri, 13 Feb 2009 13:27:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86 headers: include linux/types.h
Message-ID: <20090213122724.GA2172@elte.hu>
References: <49935DD8.8010705@goop.org> <20090213120239.GL15679@elte.hu> <20090213121858.GB5483@elte.hu> <20090213122325.GA30061@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090213122325.GA30061@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Regarding the fixlet below - wouldnt PTE_FLAGS_MASK be better placed in
pgtable_types.h ? It's specifically related to the pte format. OTOH we
have a lot of PTE details in the page_*types.h files already.

The boundary between page_types.h and pgtable_types.h does not seem to
be clear to me - what is the principle you followed?

	Ingo

----------------------->
>From e43623b4ed1d0a1a86f0e05a2df8b9637b90ddd7 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Fri, 13 Feb 2009 13:24:19 +0100
Subject: [PATCH] x86 headers: include page_types.h in pgtable_types.h

To properly pick up details like PTE_FLAGS_MASK.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/pgtable_types.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index a7452f1..9dafe87 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -2,6 +2,7 @@
 #define _ASM_X86_PGTABLE_DEFS_H
 
 #include <linux/const.h>
+#include <asm/page_types.h>
 
 #define FIRST_USER_ADDRESS	0
 
