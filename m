Return-Path: <linux-kernel-owner+w=401wt.eu-S1754873AbYADCQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873AbYADCQb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 21:16:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752786AbYADCQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 21:16:22 -0500
Received: from mga02.intel.com ([134.134.136.20]:32180 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752255AbYADCQU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 21:16:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,241,1196668800"; 
   d="scan'208";a="248633383"
Date: Thu, 3 Jan 2008 18:16:19 -0800
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Mark Lord <lkml@rtr.ca>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, abelay@novell.com,
       lenb@kernel.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, rjw@sisk.pl
Subject: Re: + restore-missing-sysfs-max_cstate-attr.patch added to -mm tree
Message-ID: <20080104021619.GA15409@linux-os.sc.intel.com>
References: <20071130142058.816d1693.akpm@linux-foundation.org> <924EFEDD5F540B4284297C4DC59F3DEE2FAEAF@orsmsx423.amr.corp.intel.com> <4750CC78.9070105@rtr.ca> <20071130190227.1976e682@laptopd505.fenrus.org> <4750D180.6080001@rtr.ca> <20071130191816.3e744205@laptopd505.fenrus.org> <4750D585.1030200@rtr.ca> <477C2143.8090406@rtr.ca> <924EFEDD5F540B4284297C4DC59F3DEE4FC485@orsmsx423.amr.corp.intel.com> <477C622F.6010304@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <477C622F.6010304@rtr.ca>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Reintroduce run time configurable max_cstate for !CPU_IDLE case.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

Index: linux-2.6.24-rc/drivers/acpi/processor_idle.c
===================================================================
--- linux-2.6.24-rc.orig/drivers/acpi/processor_idle.c
+++ linux-2.6.24-rc/drivers/acpi/processor_idle.c
@@ -76,7 +76,11 @@ static void (*pm_idle_save) (void) __rea
 #define PM_TIMER_TICKS_TO_US(p)		(((p) * 1000)/(PM_TIMER_FREQUENCY/1000))
 
 static unsigned int max_cstate __read_mostly = ACPI_PROCESSOR_MAX_POWER;
+#ifdef CONFIG_CPU_IDLE
 module_param(max_cstate, uint, 0000);
+#else
+module_param(max_cstate, uint, 0644);
+#endif
 static unsigned int nocst __read_mostly;
 module_param(nocst, uint, 0000);
 
