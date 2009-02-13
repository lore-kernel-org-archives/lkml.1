Return-Path: <linux-kernel-owner+w=401wt.eu-S1756528AbZBMWmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756528AbZBMWmW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 17:42:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753352AbZBMWmD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 17:42:03 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40417 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753048AbZBMWmB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 17:42:01 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg KH <gregkh@suse.de>
Subject: [PATCH 0/1] Fix resume breakage of USB PCI controllers behind cardbus bridges
Date: Fri, 13 Feb 2009 23:40:14 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc4-tst; KDE/4.2.0; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Miles Lane <miles.lane@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       USB list <linux-usb@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200902132340.15427.rjw@sisk.pl>
X-Length: 1541
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Sorry for resending, I forgot to send CCs to the mailing lists.]

Hi,

Unfortunately, we broke the resume of USB PCI controllers behind cardbus
bridges by moving the restoration of their standard config registers to
usb_hcd_pci_resume_early().  Namely, if USB PCI controller is behind a cardbus
bridge, we're restoring its config registers too early, before the bridge
becomes operational.

IMO in the future it's better to move the resume of cardbus bridges to the
early resume phase (ie. before device interrupts will be enabled), but for
2.6.29 I think we should just go back to the 2.6.28 behavior, which is to
call pci_restore_state() from usb_hcd_pci_resume().  The following patch
does this.

Thanks,
Rafael

