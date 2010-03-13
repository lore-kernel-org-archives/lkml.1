Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935389Ab0CMSOX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 13:14:23 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:43763 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934366Ab0CMSNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 13:13:48 -0500
Subject: [PATCH v2 2/3] ipmi: Convert tracking of the ACPI device pointer to a
	PNP device
To: minyard@acm.org
From: Myron Stowe <myron.stowe@hp.com>
Cc: Zhao Yakui <yakui.zhao@intel.com>, linux-acpi@vger.kernel.org,
       openipmi-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       lenb@kernel.org
Date: Sat, 13 Mar 2010 11:13:47 -0700
Message-ID: <20100313181347.20614.7897.stgit@bob.kio>
In-Reply-To: <20100313180121.20614.92547.stgit@bob.kio>
References: <20100313180121.20614.92547.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert PNP patch (git 9e368fa011d4e0aa050db348d69514900520e40b) to
maintain a pointer to a PNP device, 'pnp_dev', instead of the ACPI
device, 'acpi_dev', that is currently being tracked with PNP based
IPMI device discovery.

Signed-off-by: Myron Stowe <myron.stowe@hp.com>
Cc: Zhao Yakui <yakui.zhao@intel.com>
---

 drivers/char/ipmi/ipmi_si_intf.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index 86a7dd7..0e31aa9 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -2093,7 +2093,7 @@ static int __devinit ipmi_pnp_probe(struct pnp_dev *dev,
 		info->irq_setup = std_irq_setup;
 	}
 
-	info->dev = &acpi_dev->dev;
+	info->dev = &dev->dev;
 	pnp_set_drvdata(dev, info);
 
 	return try_smi_init(info);

