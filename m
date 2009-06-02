Return-Path: <linux-kernel-owner+w=401wt.eu-S1757566AbZFBPYo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757566AbZFBPYo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 11:24:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755210AbZFBPYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 11:24:35 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:42565 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632AbZFBPYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 11:24:34 -0400
Subject: [PATCH 00/10] Dynamic ACPI-PCI binding
To: lenb@kernel.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Date: Tue, 02 Jun 2009 09:24:36 -0600
Message-ID: <20090602152351.7346.48697.stgit@bob.kio>
User-Agent: StGit/0.14.3.347.g594a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series eliminates static boot-time binding of ACPI
and PCI devices, and introduces an API to perform this lookup
during runtime.

This change has the following advantages:

	- eliminates struct acpi_device vs struct pci_dev lifetime issues
	- lays groundwork for eliminating .bind/.unbind from acpi_device_ops
	- lays more groundwork for eliminating .start from acpi_device_ops
	  and thus simplifying ACPI drivers
	- whacks out a lot of code

This patchset is based on lenb/test (66c74fa1d4).
---

Alex Chiang (10):
      ACPI: acpi_pci_unbind should clean up properly after acpi_pci_bind
      ACPI: simplify acpi_pci_irq_del_prt() API
      ACPI: simplify acpi_pci_irq_add_prt() API
      ACPI: eviscerate pci_bind.c
      ACPI: kill acpi_get_pci_id
      PCI Hotplug: acpiphp: convert to acpi_get_pci_dev
      ACPI: Introduce acpi_get_pci_dev()
      ACPI: export acpi_pci_find_root()
      ACPI: Introduce acpi_is_root_bridge()
      ACPI: make acpi_pci_bind() static


 drivers/acpi/pci_bind.c            |  374 +++++++++++-------------------------
 drivers/acpi/pci_irq.c             |   17 +-
 drivers/acpi/pci_root.c            |   83 +++++---
 drivers/pci/hotplug/acpi_pcihp.c   |   40 ----
 drivers/pci/hotplug/acpiphp_glue.c |   26 +--
 include/acpi/acpi_bus.h            |   14 +
 include/acpi/acpi_drivers.h        |   10 -
 include/linux/pci_hotplug.h        |    1 
 8 files changed, 202 insertions(+), 363 deletions(-)

