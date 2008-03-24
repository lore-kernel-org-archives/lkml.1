Return-Path: <linux-kernel-owner+w=401wt.eu-S1754001AbYCXUcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001AbYCXUcV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 16:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752563AbYCXUcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 16:32:13 -0400
Received: from mga03.intel.com ([143.182.124.21]:1256 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752529AbYCXUcN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 16:32:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,548,1199692800"; 
   d="scan'208";a="222562855"
X-MIMEOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH 0/5] Generic smp_call_function(), improvements, and smp_call_function_single()
Date: Mon, 24 Mar 2008 13:28:05 -0700
Message-ID: <1FE6DD409037234FAB833C420AA843ECE5B76D@orsmsx424.amr.corp.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 0/5] Generic smp_call_function(), improvements, and smp_call_function_single()
Thread-Index: AciMGGjJ/TyU8I2AQ2K/fpdGEJs02ABs9ZPAAAgsY3A=
References: <1205927772-31401-1-git-send-email-jens.axboe@oracle.com> <1FE6DD409037234FAB833C420AA843ECE137D9@orsmsx424.amr.corp.intel.com> <20080321183149.GB15355@kernel.dk> <1FE6DD409037234FAB833C420AA843ECE1387F@orsmsx424.amr.corp.intel.com> <20080322122903.GD15355@kernel.dk> 
From: "Luck, Tony" <tony.luck@intel.com>
To: "Jens Axboe" <jens.axboe@oracle.com>
Cc: <linux-kernel@vger.kernel.org>, <npiggin@suse.de>, <paulus@samba.org>,
       <tglx@linutronix.de>, <mingo@redhat.com>
X-OriginalArrivalTime: 24 Mar 2008 20:28:06.0250 (UTC) FILETIME=[912D74A0:01C88DED]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Funky, how does accessing other CPU's per-cpu variables work on ia64
> then? Perhaps I made some false assumptions.

Having scared you to death with some of the strange weirdness of
ia64 ... it turns out that you made a trivial typo in the ia64
specific part of the patch ... see below.

With this patch and a hack to call init_call_single_data() early
enough the patch boots fine on ia64.

-Tony

commit 8ffe2551f04e55176f7f7935c5a3395cc641d514
Author: Tony Luck <tony.luck@intel.com>
Date:   Mon Mar 24 13:04:11 2008 -0700

    [IA64] Fix typo'd call to generic_smp_call_function_single_interrupt
    
    Should really be calling generic_smp_call_function_interrupt() for
    the IPI_CALL_FUNC case.
    
    Signed-off-by: Tony Luck <tony.luck@intel.com>

diff --git a/arch/ia64/kernel/smp.c b/arch/ia64/kernel/smp.c
index fa26528..55cbc2c 100644
--- a/arch/ia64/kernel/smp.c
+++ b/arch/ia64/kernel/smp.c
@@ -124,7 +124,7 @@ handle_IPI (int irq, void *dev_id)
 
 			switch (which) {
 			      case IPI_CALL_FUNC:
-				generic_smp_call_function_single_interrupt();
+				generic_smp_call_function_interrupt();
 				break;
 			      case IPI_CALL_FUNC_SINGLE:
 				generic_smp_call_function_single_interrupt();
