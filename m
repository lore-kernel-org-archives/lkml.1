Return-Path: <linux-kernel-owner+w=401wt.eu-S1764142AbXGRWtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764142AbXGRWtR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 18:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752709AbXGRWtB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 18:49:01 -0400
Received: from nz-out-0506.google.com ([64.233.162.235]:55500 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbXGRWtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 18:49:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=kl8q0DDhWfDI1N2xplwWo/X/4A0SwAZevlsEqJsmw2HW3Su960u0V9/qbH8dokKZ9jMxBM53+ROwX2cyQwuiSyAQZfUaIPIqAT2x7nD1255Gq7Ie9C9lmRg9Qwj9tEjZGLA+dQDH3wiQb0wlJrWJmdmYeYs+XD8/FecQYY744TQ=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH][ACPI] Fix acpi_ev_pci_config_region_setup() to avoid memory leak
Date: Thu, 19 Jul 2007 00:48:03 +0200
User-Agent: KMail/1.9.7
Cc: robert.moore@intel.com, len.brown@intel.com, akpm@linux-foundation.org,
       jesper.juhl@gmail.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707190048.03992.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

In drivers/acpi/events/evrgnini.c::acpi_ev_pci_config_region_setup() 
there is a memory leak.
We may return at "if (!pci_device_node)" without freeing storage 
previously allocated and assigned to 'pci_id'.
This patch fixes the leak by freeing the allocated storage in this 
case.

Compile tested only...


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 drivers/acpi/events/evrgnini.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/events/evrgnini.c b/drivers/acpi/events/evrgnini.c
index 400d90f..10f378b 100644
--- a/drivers/acpi/events/evrgnini.c
+++ b/drivers/acpi/events/evrgnini.c
@@ -284,6 +284,7 @@ acpi_ev_pci_config_region_setup(acpi_handle handle,
 	}
 
 	if (!pci_device_node) {
+		kfree(pci_id);
 		return_ACPI_STATUS(AE_AML_OPERAND_TYPE);
 	}
 


