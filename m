Return-Path: <linux-kernel-owner+w=401wt.eu-S1764021AbXHCVcz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764021AbXHCVcz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 17:32:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762037AbXHCVcq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 17:32:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:34374 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761930AbXHCVco convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 17:32:44 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Alexey Starikovskiy <aystarik@gmail.com>
Subject: Re: [2/3] 2.6.23-rc1: known regressions v3
Date: Fri, 3 Aug 2007 17:31:30 -0400
User-Agent: KMail/1.9.5
Cc: Meelis Roos <mroos@linux.ee>,
       Ismail =?iso-8859-1?q?D=F6nmez?= <ismail@pardus.org.tr>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
References: <46AE0F5D.3000500@googlemail.com> <Pine.SOC.4.64.0707302301290.14147@math.ut.ee> <46AEB59B.7030909@gmail.com>
In-Reply-To: <46AEB59B.7030909@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200708031731.30720.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 31 July 2007 00:07, Alexey Starikovskiy wrote:
> Meelis Roos wrote:
> >>> Subject         : New ACPI error/warning with Linus' latest GIT
> >>> References      : http://lkml.org/lkml/2007/7/26/395
> >>> Last known good : ?
> >>> Submitter       : Ismail Dönmez <ismail@pardus.org.tr>
> >>> Caused-By       : ?
> >>> Handled-By      : ?
> >>> Status          : unknown
> >> This started to happen after the second ACPI merge which was for 2.6.23-rc2.
> > 
> > It appeared after new Embedded Controller code was merged into ACPI. It 
> > might as well be just a debug message or a remainder to add support for 
> > new queries (whatever these are), but I do not know. The message itself 
> > seems harmless.
> > 
> This _is_ a debug message. EC asks us to perform query which was never defined in DSDT.
> Previously I thought it would be rare error report, but now it seems that every machine
> has at least one unregistered query... It is not a functional regression, as we just 
> ignored errors from query execution before.
> 
> Len already has a patch to remove this printk.

yes, this verbose message has been removed.

thanks,
-Len

commit f1cd1fe61b96e4312312d42c0a9784dfab12e007
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Fri Aug 3 17:28:17 2007 -0400

    ACPI: EC: Remove noisy debug printk fron EC driver.
    
    ACPI: EC: Handler for query 0x57 is not found!
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 469f3f5..dd384ec 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -471,7 +471,6 @@ static void acpi_ec_gpe_query(void *ec_cxt)
 		}
 	}
 	mutex_unlock(&ec->lock);
-	printk(KERN_ERR PREFIX "Handler for query 0x%x is not found!\n", value);
 }
 
 static u32 acpi_ec_gpe_handler(void *data)
