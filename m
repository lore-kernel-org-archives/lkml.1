Return-Path: <linux-kernel-owner+w=401wt.eu-S1758017AbYAOVN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758017AbYAOVN7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 16:13:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755937AbYAOVNs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 16:13:48 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:30035 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839AbYAOVNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 16:13:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=vE520FLm542e6QLkq9VhvYv62iDI3MxUoMyImckFjAcZPPGmE5fUOmrT13/OHJ3mlowHsxbb/G1/SI5IfPfAz+IHehSEfXSdLX+Jh+chrC99WPaJJOl7HYOYDXkeZMUdjCqRDEbPSJ3Uke5E9QA5tt0Z2+3w7baZE28NljPNcYA=
Subject: [PATCH] x86: Use wbinvd() macro rather than inline assembly
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Date: Tue, 15 Jan 2008 13:13:51 -0800
Message-Id: <1200431631.16794.48.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Taken from Andi's CPA 16/31, against x86.git, not sure what
the etiquette is with adding his S-O-B....

 arch/x86/mm/pageattr_64.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/pageattr_64.c b/arch/x86/mm/pageattr_64.c
index bafc0a5..5e0b36e 100644
--- a/arch/x86/mm/pageattr_64.c
+++ b/arch/x86/mm/pageattr_64.c
@@ -86,7 +86,7 @@ static void flush_kernel_map(void *arg)
 	   much cheaper than WBINVD. */
 	/* clflush is still broken. Disable for now. */
 	if (1 || !cpu_has_clflush) {
-		asm volatile("wbinvd" ::: "memory");
+		wbinvd();
 	} else {
 		list_for_each_entry(pg, l, lru) {
 			void *addr = page_address(pg);
-- 
1.5.4.rc2.1164.g6451

