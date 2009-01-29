Return-Path: <linux-kernel-owner+w=401wt.eu-S1755204AbZA2ULU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204AbZA2ULU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 15:11:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752864AbZA2ULL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 15:11:11 -0500
Received: from mga09.intel.com ([134.134.136.24]:15294 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752154AbZA2ULK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 15:11:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,346,1231142400"; 
   d="scan'208";a="485666669"
Date: Thu, 29 Jan 2009 12:11:08 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86: unify genapic code, unify subarchitectures, remove old subarchitecture code
Message-ID: <20090129201108.GA9994@linux-os.sc.intel.com>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu> <1233193977.15801.72.camel@vayu> <20090129112700.GA9624@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090129112700.GA9624@elte.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 29, 2009 at 03:27:00AM -0800, Ingo Molnar wrote:
> Did it work fine on xapic otherwise?

xapic fix for 32bit platform with less than 8 cpu's appended. Thanks.
---

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
diff --git a/arch/x86/kernel/probe_32.c b/arch/x86/kernel/probe_32.c
index 61339a0..b5db26f 100644
--- a/arch/x86/kernel/probe_32.c
+++ b/arch/x86/kernel/probe_32.c
@@ -113,7 +113,7 @@ struct genapic apic_default = {
 	.cpu_mask_to_apicid_and		= default_cpu_mask_to_apicid_and,
 
 	.send_IPI_mask			= default_send_IPI_mask,
-	.send_IPI_mask_allbutself	= NULL,
+	.send_IPI_mask_allbutself	= default_send_IPI_mask_allbutself,
 	.send_IPI_allbutself		= default_send_IPI_allbutself,
 	.send_IPI_all			= default_send_IPI_all,
 	.send_IPI_self			= NULL,
