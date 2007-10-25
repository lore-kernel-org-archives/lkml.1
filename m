Return-Path: <linux-kernel-owner+w=401wt.eu-S1756984AbXJYIPC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756984AbXJYIPC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 04:15:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752700AbXJYIOq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 04:14:46 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33886
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751505AbXJYIOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 04:14:44 -0400
Date: Thu, 25 Oct 2007 01:14:45 -0700 (PDT)
Message-Id: <20071025.011445.80152909.davem@davemloft.net>
To: linux-kernel@vger.kernel.org
Cc: jeff@garzik.org, barkalow@iabervon.org, linas@austin.ibm.com,
       chunhao.huang@hotmail.com, gregkh@suse.de, htejun@gmail.com,
       brice.goglin@gmail.com, david.gaarenstroom@gmail.com,
       linux-pci@atrey.karlin.mff.cuni.cz, shane.huang@amd.com,
       linux-ide@vger.kernel.org, brice@myri.com, mchan@broadcom.com
Subject: [PATCH 0/4]: Resolve MSI vs. INTX_DISABLE quirks, V2.
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Ok, I've respun the patches including all of the feedback I've
obtained.  Again, it's at:

	kernel.org:/pub/scm/linux/kernel/git/davem/msiquirk-2.6.git

Greg, I think this stuff is ready to go so if you would pull
them in I would really appreciate it.

These changes clean up the handling of the common quirk wherein
setting INTX_DISABLE will mistakedly disable MSI generation for some
devices.

For devices without that problem, we want to keep the pci_intx() calls
in drivers/pci/msi.c because those help protect against devices with
the opposite problem.  Such devices always generate INTX interrupts
even when MSI is enabled, unless INTX_DISABLE is set.

In addition to the Tigon3 cases, I added quirk entries for the
SB700/800 SATA chips and the IXP SB400 USB controllers.  And as
a result of the latter we can remove several AMD full-chipset
MSI disable quirks which are no longer necessary.

Signed-off-by: David S. Miller <davem@davemloft.net>
