Return-Path: <linux-kernel-owner+w=401wt.eu-S1754676AbYFCInr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676AbYFCInr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 04:43:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751753AbYFCInj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 04:43:39 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:56234 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456AbYFCIni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 04:43:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Sg64dkOWP9veaD+m82wtUiA/KoN9Djx6D8ifmySfl9JK3ZNqohPQUUabhw8G04x1fWJGFOHL4jGgB4qxZ7unIoJuoEhj4dsS7DJta1t09VbktWtP2ZypLYR/03KWP96DTAMsFZZrQ5sReQlwLDV/7C6LXzkryC58VFzdmJyqdgw=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] x86: remove all active before register them again after trimming - 64bit
Date: Tue, 3 Jun 2008 01:43:24 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806030143.24805.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


so keep the early_node_map all right.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

--- a/arch/x86/kernel/setup_64.c	2008-06-02 23:58:32.000000000 -0700
+++ b/arch/x86/kernel/setup_64.c	2008-06-02 23:59:52.000000000 -0700
@@ -382,6 +382,7 @@ void __init setup_arch(char **cmdline_p)
 	/* update e820 for memory not covered by WB MTRRs */
 	mtrr_bp_init();
 	if (mtrr_trim_uncached_memory(end_pfn)) {
+		remove_all_active_ranges();
 		e820_register_active_regions(0, 0, -1UL);
 		end_pfn = e820_end_of_ram();
 	}
