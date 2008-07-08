Return-Path: <linux-kernel-owner+w=401wt.eu-S1756188AbYGHQcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756188AbYGHQcU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 12:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753848AbYGHQcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 12:32:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:49936 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753971AbYGHQcL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 12:32:11 -0400
From: Olaf Dabrunz <od@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Jon Masters <jonathan@jonmasters.org>, Olaf Dabrunz <od@suse.de>,
       Stefan Assmann <sassmann@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Ihno Krumreich <ihno@suse.de>, Sven Dietrich <sdietrich@suse.de>,
       Daniel Gollub <dgollub@suse.de>, Felix Foerster <ffoerster@suse.de>
Subject: [PATCH 0/3] Boot IRQ quirks for Broadcom and AMD/ATI
Date: Tue,  8 Jul 2008 15:59:46 +0200
Message-Id: <12155255883170-git-send-email-od@suse.de>
X-Mailer: git-send-email 1.5.2.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is against linux-2.6-tip, branch pci-ioapic-boot-irq-quirks.

The corrected versions of the Broadcom and AMD/ATI boot IRQ quirks, and
a patch that uses DECLARE_PCI_FIXUP_FINAL instead of *_EARLY, and adds
*_RESUME.

The AMD/ATI SB700S does not need a quirk. The boot IRQs here are active
even when the IO-APIC lines are not masked. So even for traditional IRQ
handling that does not use masking, the boot IRQs need to be disabled by
the BIOS. If there are actual cases of BIOSes that do not disable these
boot IRQs in APIC mode, we could consider including an SB700S patch. But
I doubt this will be needed, as this problem would quickly surface
during testing with any general-purpose OS.

The quirk for the AMD 8131 and AMD 8132 takes identical action as an
existing quirk for the AMD 8131 rev. A0 and B0. The existing quirk is
due to an AMD erratum to fix IO-APIC mode. Our patch now deletes the
older quirk and adds a comment to the new one that describes the two
purposes of the quirk.

