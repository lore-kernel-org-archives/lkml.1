Return-Path: <linux-kernel-owner+w=401wt.eu-S1754645AbZGWXE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645AbZGWXE0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 19:04:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753940AbZGWXE0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 19:04:26 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:13735 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753862AbZGWXEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 19:04:24 -0400
Subject: [PATCH v3 0/2] export acpi_pci_root to find pci_bus correctly
To: jbarnes@virtuousgeek.org, lenb@kernel.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Date: Thu, 23 Jul 2009 17:02:55 -0600
Message-ID: <20090723230026.4247.12759.stgit@bob.kio>
User-Agent: StGit/0.14.3.386.gb02d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is v3 of a patch series that:

	a) exports struct acpi_pci_root
	b) fixes an assumption in acpiphp about finding struct pci_bus

It's a minimal fix that's aimed at -rc5, as (b) fixes an assumption
introduced in -rc1.

I'll send the rest of the cleanups for linux-next later, after doing
some more testing.

Original thread here:
	http://thread.gmane.org/gmane.linux.kernel.pci/5080

v2 -> v3:
	- don't depend on acpi_is_root_bridge (Bjorn Helgaas)

v1 -> v2:
	- fixed build error in acpi_pci_root
	- reduced patch series in scope to be much smaller


---

Alex Chiang (2):
      ACPI: export acpi_pci_root and friends
      PCI Hotplug: acpiphp: get pci_bus from acpi handle correctly


 drivers/acpi/pci_root.c            |   17 ++---------------
 drivers/pci/hotplug/acpiphp_glue.c |   28 +++++++++++++++++-----------
 include/acpi/acpi_bus.h            |   16 ++++++++++++++++
 3 files changed, 35 insertions(+), 26 deletions(-)

