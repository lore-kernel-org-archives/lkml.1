Return-Path: <linux-kernel-owner+w=401wt.eu-S1754118AbYGSJRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118AbYGSJRW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 05:17:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751814AbYGSJRO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 05:17:14 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:7078 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592AbYGSJRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 05:17:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=XwtrU9sOZGbXqLvsauFRIwczwCSMFuA0tfLL7l+WHNbbI5/4iV/gW+0qXLfnKyCpnq
         jw3dZcXbn3NtF9qtBT6xj5k8U1sfto3KCYmOERVrOqZL0PPwrZ4t5d5bzFRKEtRB2axq
         zLKDSB1XAEAgEqn54XPM4fo9VTeP6GTvFtrg0=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, jbarnes@virtuousgeek.org,
       Jack Howarth <howarth@bromo.msbb.uc.edu>
Subject: [PATCH] x86,pci: detect end_bus_number according to acpi/e820 reserved - fix
Date: Sat, 19 Jul 2008 02:16:32 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <200807180941.09779.yhlu.kernel@gmail.com> <200807181322.37500.yhlu.kernel@gmail.com>
In-Reply-To: <200807181322.37500.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807190216.32479.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

diff --git a/arch/x86/pci/mmconfig-shared.c b/arch/x86/pci/mmconfig-shared.c
index 9297882..429c701 100644
--- a/arch/x86/pci/mmconfig-shared.c
+++ b/arch/x86/pci/mmconfig-shared.c
@@ -364,6 +364,7 @@ static void __init pci_mmcfg_reject_broken(int early)
 		cfg = &pci_mmcfg_config[i];
 		addr = cfg->start_bus_number;
 		addr <<= 20;
+		addr += cfg->address;
 		size = cfg->end_bus_number + 1 - cfg->start_bus_number;
 		size <<= 20;
 		printk(KERN_NOTICE "PCI: MCFG configuration %d: base %lx "
