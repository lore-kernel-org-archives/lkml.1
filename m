Return-Path: <linux-kernel-owner+w=401wt.eu-S1752984AbXCZQkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984AbXCZQkq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 12:40:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752960AbXCZQkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 12:40:23 -0400
Received: from smtp112.sbc.mail.mud.yahoo.com ([68.142.198.211]:34035 "HELO
	smtp112.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752964AbXCZQkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 12:40:19 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=hc7myjtujd3RP75BTmwlanpmRuP3xIrK44jq9fgzwsBJWL181WpTwXVVHrhtVMxPxGmvCyyJ7tncmVe8+jlSOnoL8+glek1v7nGrGa1Te4AZrmYmvuJ3082VgpMEhiL7NMOuMNkee9UgODd3VDnYHfPyUPov2UkRI5r3mYz5bTk=  ;
X-YMail-OSG: 5zt1ovkVM1nFxYQgxukYAmo3ERY4dzHgq3ksHJV59y8KtKiqxSHwT.bLXP4fvR5ZSfBfbrGI.o6Go2aP.IF3TXaZvJWZttSBKmuXzIMTrnl.edtP_lYWPZvpcm0G55iv.Pwl2_JQ2ESZlfYpDFonKNe9zA--
From: David Brownell <david-b@pacbell.net>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [patch 2.6.21-rc5] arch/x86_64/kernel/early-quirks.c compiler warning
Date: Mon, 26 Mar 2007 09:17:44 -0700
User-Agent: KMail/1.7.1
Cc: akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703260917.44906.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix "unused variable" compiler warning on non-SMP x86_64 configs.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>

--- a/arch/x86_64/kernel/early-quirks.c
+++ b/arch/x86_64/kernel/early-quirks.c
@@ -73,9 +73,9 @@ static void __init ati_bugs(void)
 
 static void intel_bugs(void)
 {
+#ifdef CONFIG_SMP
 	u16 device = read_pci_config_16(0, 0, 0, PCI_DEVICE_ID);
 
-#ifdef CONFIG_SMP
 	if (device == PCI_DEVICE_ID_INTEL_E7320_MCH ||
 	    device == PCI_DEVICE_ID_INTEL_E7520_MCH ||
 	    device == PCI_DEVICE_ID_INTEL_E7525_MCH)
