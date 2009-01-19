Return-Path: <linux-kernel-owner+w=401wt.eu-S1752831AbZASONY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831AbZASONY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 09:13:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751451AbZASONJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 09:13:09 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:36546 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450AbZASONI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 09:13:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=pclyW4/0O22Zc5zS9xx2F/23HQg6kW1Bkw0aGPuA63PSoZLcXhiy3bnRyB7Unkcg8E
         +9ddgTqIOqscP70HvbgOthD/NiqIiwN5qSbyb/rNYEK8nSBtDgz6BgCZJcun5yy2ywSf
         0D3CAyZF/6FjT8NhQ/qQ/izy2CvXL/BD/HozY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 19 Jan 2009 15:13:30 +0100
Message-Id: <20090119141330.27613.34546.sendpatchset@localhost.localdomain>
Subject: [PATCH 00/12] ide: IRQ setup fixes/sanitizations
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


IRQ setup fixes/sanitizations.

For IDE PCI controllers we now always use pci_get_legacy_ide_irq() if device
is in compatibility mode.  This in turn allows us to remove no longer needed:
- IRQ hackery from both core code and host drivers
- optional IRQ auto-probing from core code

These patches are on top of:
- pata-2.6 tree
- "[PATCH 0/6] ide: more core code housekeeping" patchset
- "[PATCH] mn10300: add pci_get_legacy_ide_irq() to <asm/pci.h>"

diffstat:
 drivers/ide/amd74xx.c         |   12 ----
 drivers/ide/atiixp.c          |    3 -
 drivers/ide/ide-pci-generic.c |    4 -
 drivers/ide/ide-probe.c       |  114 +++++++-----------------------------------
 drivers/ide/ns87415.c         |    4 -
 drivers/ide/piix.c            |   11 ----
 drivers/ide/serverworks.c     |    9 ---
 drivers/ide/setup-pci.c       |   36 ++++++++-----
 drivers/ide/sis5513.c         |    2 
 drivers/ide/slc90e66.c        |    1 
 drivers/ide/trm290.c          |    3 -
 drivers/ide/via82cxxx.c       |   10 ---
 include/linux/ide.h           |   19 -------
 13 files changed, 49 insertions(+), 179 deletions(-)
