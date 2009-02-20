Return-Path: <linux-kernel-owner+w=401wt.eu-S1755330AbZBTVxM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330AbZBTVxM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 16:53:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753749AbZBTVw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 16:52:58 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47321 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750951AbZBTVw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 16:52:57 -0500
Date: Fri, 20 Feb 2009 13:52:53 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andrew Patterson <andrew.patterson@hp.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       andrew.patterson@hp.com
Subject: Re: [PATCH] PCI: Enable PCIe AER only after checking firmware
 support
Message-Id: <20090220135253.ab057442.akpm@linux-foundation.org>
In-Reply-To: <20090219171107.26521.7298.stgit@bob.kio>
References: <20090219171107.26521.7298.stgit@bob.kio>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Feb 2009 10:11:07 -0700
Andrew Patterson <andrew.patterson@hp.com> wrote:

> PCI: Enable PCIe AER only after checking firmware support
> 
> The PCIe port driver currently sets the PCIe AER error reporting bits for
> any root or switch port without first checking to see if firmware will grant
> control. This patch moves setting these bits to the AER service driver
> aer_enable_port routine.  The bits are then set for the root port and any
> downstream switch ports after the check for firmware support (aer_osc_setup)
> is made. The patch also unsets the bits in a similar fashion when the AER
> service driver is unloaded.
> 
> ...
>
> +/**
> + * set_downstream_devices_error_reporting - enable/disable the error reporting
> + * bits on the root port and its downstream ports.

Alas, silly kerneldoc does not permit multi-line titles.  We're forced
to do this:

--- a/drivers/pci/pcie/aer/aerdrv_core.c~pci-enable-pcie-aer-only-after-checking-firmware-support-fix
+++ a/drivers/pci/pcie/aer/aerdrv_core.c
@@ -125,8 +125,7 @@ static void set_device_error_reporting(s
 }
 
 /**
- * set_downstream_devices_error_reporting - enable/disable the error reporting
- * bits on the root port and its downstream ports.
+ * set_downstream_devices_error_reporting - enable/disable the error reporting bits on the root port and its downstream ports.
  * @dev: pointer to root port's pci_dev data structure
  * @enable: true = enable error reporting, false = disable error reporting.
  */
_

