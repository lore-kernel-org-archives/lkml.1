Return-Path: <linux-kernel-owner+w=401wt.eu-S1754708AbYINOre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708AbYINOre (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 10:47:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752042AbYINOrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 10:47:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57092 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751941AbYINOrZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 10:47:25 -0400
Date: Sun, 14 Sep 2008 16:47:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: roberto@unbit.it, jeremy@xensource.com, linux-kernel@vger.kernel.org,
       Mirko Iannella <mirko@unbit.it>, Alex Nixon <alex.nixon@citrix.com>
Subject: Re: [PATCH] xen: Fix for xen guest with mem > 3.7G
Message-ID: <20080914144708.GH12522@elte.hu>
References: <1221333418.6036.9.camel@sirius> <48CC2C12.4080302@goop.org> <20080914132104.GB32106@elte.hu> <48CD22CF.9030900@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48CD22CF.9030900@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> PFN_PHYS() can truncate large addresses unless its passed a suitable
> large type.  This is fixed more generally in the patch series
> introducing phys_addr_t, but we need a short-term fix to solve a
> regression.
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> Cc: roberto@unbit.it

applied to tip/x86/urgent (see below), thanks guys!

	Ingo

-------------->
>From 5670a43d710a12fcbbfaefd3991002768b488d82 Mon Sep 17 00:00:00 2001
From: Jeremy Fitzhardinge <jeremy@goop.org>
Date: Sun, 14 Sep 2008 07:42:23 -0700
Subject: [PATCH] xen: fix for xen guest with mem > 3.7G

PFN_PHYS() can truncate large addresses unless its passed a suitable
large type.  This is fixed more generally in the patch series
introducing phys_addr_t, but we need a short-term fix to solve a
Xen regression reported by Roberto De Ioris.

Reported-by: Roberto De Ioris <roberto@unbit.it>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/xen/setup.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index b6acc3a..d679010 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -42,7 +42,7 @@ char * __init xen_memory_setup(void)
 
 	e820.nr_map = 0;
 
-	e820_add_region(0, PFN_PHYS(max_pfn), E820_RAM);
+	e820_add_region(0, PFN_PHYS((u64)max_pfn), E820_RAM);
 
 	/*
 	 * Even though this is normal, usable memory under Xen, reserve
