Return-Path: <linux-kernel-owner+w=401wt.eu-S1751139AbZL0ULh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751139AbZL0ULh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 15:11:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751031AbZL0ULf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 15:11:35 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60422 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750938AbZL0ULe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 15:11:34 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Matthew Garrett <mjg@redhat.com>,
       Len Brown <lenb@kernel.org>
Subject: [PATCH 0/12] PCI run-time PM support (rev. 2)
Date: Sun, 27 Dec 2009 20:57:10 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc2-tst; KDE/4.3.3; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Oliver Neukum <oliver@neukum.org>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Shaohua Li <shaohua.li@intel.com>,
       Francois Romieu <romieu@fr.zoreil.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200912272057.10443.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following (updated) series of patches provides preliminary run-time power
management support for PCI devices through ACPI and/or the native PCIe PME.

Some patches have been modified since the previous iteration, one patch has
been merged and there's one more.

I've tested this patchset with the native PCIe PME mechanism using the r8169
driver on the MSI Wind U-100 (see the last patch for details) and with the ACPI
mechanism using the e1000e driver on the Toshiba Portege R500 (the patch still
requires some work to be shown in public ;-)).

[1/12] - Add function for checking PME status of devices
 
[2/12] - Modify wake-up enable propagation so that it's done for PCIe devices
         too (this one is in the Jesse's tree already, but it's reproduced here
         for completness)
 
[3/12] - PCIe PME root port service driver

[4/12] - "Don't use MSIs for PME signaling" switch for PCIe
 
[5/12] - ACPI GPE refcounting, from Matthew
 
[6/12] - ACPI drivers support for GPE refcounting, from Matthew
 
[7/12] - ACPI removal of the old GPE API, from Matthew
 
[8/12] - ACPI add fields for handling run-wake devices
 
[9/12][New] - ACPI add helper function for enabling/disabling wake-up power

[10/12] - PCI / ACPI platform support for run-time power management

[11/12] - Runtime PM callbacks for the PCI bus type

[12/12] - Runtime PM support for r8169 (experimental)

If there are no objections, I think the patches [1-11/12] are ready for the
upstream.

Thanks,
Rafael

