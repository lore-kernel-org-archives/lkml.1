Return-Path: <linux-kernel-owner+w=401wt.eu-S1755682AbYJWXzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755682AbYJWXzr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 19:55:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751246AbYJWXzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 19:55:39 -0400
Received: from outbound-mail-112.bluehost.com ([69.89.24.2]:43261 "HELO
	outbound-mail-112.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751090AbYJWXzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 19:55:38 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Oct 2008 19:55:38 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=iqg/LDQYPzDeBabTWaG0WK9nGPbW9JMsADk+K5CgeeEWIfYfssptsdMfAoFtEce557WJqIKma+3q5BCukTxUsYlqFBL/mXDlnh4cyLp1QK1NiTSKHofBSqasySQrsCYW;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] final PCI bits for 2.6.28 merge window
Date: Thu, 23 Oct 2008 16:48:55 -0700
User-Agent: KMail/1.10.1 (Linux/2.6.26.5-45.fc9.x86_64; KDE/4.1.2; x86_64; ; )
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810231648.55530.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull my for-linus branch:
git pull git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6.git for-linus

Include a few more additions (including James's new IRQ debugging API) and a
couple of fixes for problems caused by the last merge.  I'm still waiting on
test results for the _OSC problem, so that fix will be part of my next pull
request, not this one.

The IRQ debugging stuff is interesting.  It's not uncommon for platforms to
have IRQ routing problems, either due to a buggy MSI implementation in the
bridge or because the ACPI routing info is wrong.  James's new API provides
a way for drivers to get some information when they don't receive an interrupt
they expected, which should allow drivers to fall back and continue working,
as well as improving our MSI blacklist.

Thanks,
Jesse

James Bottomley (1):
      PCI: add routines for debugging and handling lost interrupts

Kenji Kaneshige (1):
      PCI hotplug: cpqphp: fix kernel NULL pointer dereference

Taku Izumi (3):
      PCI hotplug: pciehp: message refinement
      PCI hotplug: shpchp: replace printk with dev_printk
      PCI hotplug: shpchp: message refinement

Zhao, Yu (2):
      PCI: fix ARI code to be compatible with mixed ARI/non-ARI systems
      PCI: remove unused resource assignment in pci_read_bridge_bases()

 drivers/pci/Makefile              |    3 +-
 drivers/pci/hotplug/cpqphp_core.c |    2 +-
 drivers/pci/hotplug/pciehp.h      |    2 +-
 drivers/pci/hotplug/pciehp_core.c |   38 +++++----
 drivers/pci/hotplug/pciehp_ctrl.c |   64 ++++++++--------
 drivers/pci/hotplug/pciehp_hpc.c  |   43 ++++------
 drivers/pci/hotplug/pciehp_pci.c  |   19 ++---
 drivers/pci/hotplug/shpchp.h      |   22 +++++-
 drivers/pci/hotplug/shpchp_core.c |   48 +++++++----
 drivers/pci/hotplug/shpchp_ctrl.c |  158 +++++++++++++++++++++----------------
 drivers/pci/hotplug/shpchp_hpc.c  |  113 +++++++++++++-------------
 drivers/pci/hotplug/shpchp_pci.c  |   36 +++++----
 drivers/pci/irq.c                 |   60 ++++++++++++++
 drivers/pci/pci.c                 |   21 +++--
 drivers/pci/probe.c               |    3 -
 include/linux/pci.h               |    7 ++
 16 files changed, 376 insertions(+), 263 deletions(-)
 create mode 100644 drivers/pci/irq.c

