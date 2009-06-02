Return-Path: <linux-kernel-owner+w=401wt.eu-S1758378AbZFBRrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758378AbZFBRrj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 13:47:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754394AbZFBRrb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 13:47:31 -0400
Received: from mga09.intel.com ([134.134.136.24]:12482 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753880AbZFBRrb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 13:47:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,292,1241420400"; 
   d="scan'208";a="418245926"
Subject: Re: [Bug #13116] Can't boot with nosmp
From: Dan Williams <dan.j.williams@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Stephen Hemminger <shemminger@vyatta.com>
In-Reply-To: <LEcEO2518_I.A.aWF.nKbIKB@chimera>
References: <4to6E2myxvG.A.muC.aIbIKB@chimera>
	 <LEcEO2518_I.A.aWF.nKbIKB@chimera>
Content-Type: text/plain
Date: Tue, 02 Jun 2009 10:47:32 -0700
Message-Id: <1243964852.31688.4.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-05-30 at 12:37 -0700, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.29.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13116
> Subject		: Can't boot with nosmp
> Submitter	: Stephen Hemminger <shemminger@vyatta.com>
> Date		: 2009-04-15 4:18 (46 days old)
> References	: http://marc.info/?l=linux-kernel&m=123976917817920&w=4
> Handled-By	: Dan Williams <dan.j.williams@intel.com>

Still open as "can't reproduce" on my end.  Stephen can you reproduce
with the following patch to confirm that the cpumasks are sane?

Thanks,
Dan

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 5a87384..4cdcbc6 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -444,6 +444,7 @@ static void dma_channel_rebalance(void)
 			else
 				chan = nth_chan(cap, -1);
 
+			pr_info("%s: cpu: %d cap: %d\n", __func__, cpu, cap);
 			per_cpu_ptr(channel_table[cap], cpu)->chan = chan;
 		}
 }


