Return-Path: <linux-kernel-owner+w=401wt.eu-S1758104AbYFICxK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758104AbYFICxK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 22:53:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756197AbYFICw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 22:52:58 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:18835 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756174AbYFICw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 22:52:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=CpkGRl4LRl9MU05hT0i2u7iXJEcbFXPsRYbl5tADSgxrsIngEuvr0/LgfIOiwvMcsW
         6I2g2vlGh3Se2JnNGqGsFxj9+sdv+SQah8X1nDCgGJudac9wy4Bn3MJA8cfZkYPa3EF8
         YMroKfNZHybjXXe20M2EpalnFIo4nrcdHuSsU=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH] x86: update mptable v7 - fix
Date: Sun, 8 Jun 2008 19:53:26 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200805041823.57198.yhlu.kernel@gmail.com> <200805251600.26325.yhlu.kernel@gmail.com> <200806011317.38622.yhlu.kernel@gmail.com>
In-Reply-To: <200806011317.38622.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806081953.26877.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] x86: update mptable v7 - fix

need to call early_reserve_e820 to prelocate mptable for 32bit

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Index: linux-2.6/arch/x86/kernel/setup_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_32.c
+++ linux-2.6/arch/x86/kernel/setup_32.c
@@ -761,6 +761,8 @@ void __init setup_arch(char **cmdline_p)
 	 */
 	max_pfn = e820_end_of_ram();
 
+	/* pre allocte 4k for mptable mpc */
+	early_reserve_e820_mpc_new();
 	/* update e820 for memory not covered by WB MTRRs */
 	mtrr_bp_init();
 	if (mtrr_trim_uncached_memory(max_pfn)) {
