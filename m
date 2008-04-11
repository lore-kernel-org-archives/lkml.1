Return-Path: <linux-kernel-owner+w=401wt.eu-S1761364AbYDKSzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761364AbYDKSzj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 14:55:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760563AbYDKSzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 14:55:32 -0400
Received: from adsl-67-120-171-161.dsl.lsan03.pacbell.net ([67.120.171.161]:51127
	"HELO linuxace.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760223AbYDKSzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 14:55:31 -0400
Date: Fri, 11 Apr 2008 11:55:30 -0700
From: Phil Oester <kernel@linuxace.com>
To: linux-kernel@vger.kernel.org
Subject: PCI probe order changes after 2.6.22
Message-ID: <20080411185530.GA20746@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In commit 08f1c192c3c32797068bfe97738babb3295bbf42 (x86-64: introduce
struct pci_sysdata to facilitate sharing of ->sysdata), a change was
made from using pcibios_scan_root to pci_scan_bus_parented.  pcibios_scan_root
applies some quirks to various systems via pciprobe_dmi_table, including a
number of Dell PowerEdge servers.  The similarly named acpi_pciprobe_dmi_table,
however, does not apply the same set_bf_sort quirk, so between .22 and .23, the
onboard Broadcom nics reversed their probe order.

Any chance this can get fixed?  The brainless fix would be to duplicate all
the pciprobe_dmi_table fixups in acpi_pciprobe_dmi_table, but perhaps there
is a better approach which could reuse the code?

Thanks,
Phil
