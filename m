Return-Path: <linux-kernel-owner+w=401wt.eu-S1945965AbXBPQNj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945965AbXBPQNj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 11:13:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945971AbXBPQNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 11:13:39 -0500
Received: from mta13.adelphia.net ([68.168.78.44]:56924 "EHLO
	mta13.adelphia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945965AbXBPQNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 11:13:38 -0500
Date: Fri, 16 Feb 2007 10:13:36 -0600
From: Corey Minyard <minyard@acm.org>
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch 3/4] ipmi: add pci remove handling
Message-ID: <20070216161335.GA16955@localdomain>
Reply-To: minyard@acm.org
References: <20070214200624.GC5364@localdomain> <20070215022745.648ab8cb.akpm@linux-foundation.org> <20070215155318.GA24870@localdomain> <200702161416.22471.eike-kernel@sf-tec.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702161416.22471.eike-kernel@sf-tec.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 16, 2007 at 02:16:17PM +0100, Rolf Eike Beer wrote:
> 
> Please use pci_{set,get}_drvdata() to access this field.
> 
> Greetings,
> 
> Eike

Yes, much better.  Thanks.  One more time...


Add pci_remove handling to the driver, so it will clean up if
the device is hot-removed.

Signed-off-by: Corey Minyard <minyard@acm.org>

Index: linux-2.6.20/drivers/char/ipmi/ipmi_si_intf.c
===================================================================
--- linux-2.6.20.orig/drivers/char/ipmi/ipmi_si_intf.c
+++ linux-2.6.20/drivers/char/ipmi/ipmi_si_intf.c
@@ -2191,12 +2191,15 @@ static int __devinit ipmi_pci_probe(stru
 		info->irq_setup = std_irq_setup;
 
 	info->dev = &pdev->dev;
+	pci_set_drvdata(pdev, info);
 
 	return try_smi_init(info);
 }
 
 static void __devexit ipmi_pci_remove(struct pci_dev *pdev)
 {
+	struct smi_info *info = pci_get_drvdata(pdev);
+	cleanup_one_si(info);
 }
 
 #ifdef CONFIG_PM
