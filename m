Return-Path: <linux-kernel-owner+w=401wt.eu-S1759748AbXLMLoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759748AbXLMLoZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 06:44:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753990AbXLMLoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 06:44:17 -0500
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:50901 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753839AbXLMLoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 06:44:16 -0500
Date: Thu, 13 Dec 2007 17:13:36 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: "Fortier,Vincent [Montreal]" <Vincent.Fortier1@EC.GC.CA>
Cc: Ingo Molnar <mingo@elte.hu>, Greg KH <gregkh@suse.de>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>, kay.sievers@vrfy.org,
       Balbir Singh <balbir@in.ibm.com>, maneesh@in.ibm.com
Subject: Re: 2.6.22.14 oops msg with commvault galaxy ?
Message-ID: <20071213114336.GA5400@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20071211172338.GA17896@linux.vnet.ibm.com> <F1D642E5A91BC94D9504EC83AE19E6B0015201EF@ecqcmtlmail3.quebec.int.ec.gc.ca> <20071211182015.GA22339@linux.vnet.ibm.com> <20071211182528.GA5597@linux.vnet.ibm.com> <F1D642E5A91BC94D9504EC83AE19E6B0015201F1@ecqcmtlmail3.quebec.int.ec.gc.ca> <20071211210653.GA6902@elte.hu> <20071212070816.GA31455@linux.vnet.ibm.com> <F1D642E5A91BC94D9504EC83AE19E6B0015201F6@ecqcmtlmail3.quebec.int.ec.gc.ca> <20071212134158.GA5547@linux.vnet.ibm.com> <F1D642E5A91BC94D9504EC83AE19E6B00152021F@ecqcmtlmail3.quebec.int.ec.gc.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F1D642E5A91BC94D9504EC83AE19E6B00152021F@ecqcmtlmail3.quebec.int.ec.gc.ca>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vincent,

Could you please see if the following patch removes the oops due to CFS
sysfs files? (There might still be the other oops due to the floppy
sysfs files)

Ingo, could you please add this patch in your CFS backport to 2.6.22 and
older kernels?

Thanks,
--

kdump showed that the owner field had some junk value which caused
the oops reported at http://lkml.org/lkml/2007/12/10/113 . This
patch sets the value of that field to NULL.

Signed-off-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Signed-off-by: Maneesh Soni <maneesh@in.ibm.com>

---
 kernel/user.c |    1 +
 1 files changed, 1 insertion(+)

Index: linux-2.6.22.13/kernel/user.c
===================================================================
--- linux-2.6.22.13.orig/kernel/user.c
+++ linux-2.6.22.13/kernel/user.c
@@ -145,6 +145,7 @@ ssize_t cpu_shares_store(struct kset *ks
 
 static void user_attr_init(struct subsys_attribute *sa, char *name, int mode)
 {
+	sa->attr.owner = NULL;
 	sa->attr.name = name;
 	sa->attr.mode = mode;
 	sa->show = cpu_shares_show;

-- 
regards,
Dhaval
