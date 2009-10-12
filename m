Return-Path: <linux-kernel-owner+w=401wt.eu-S1755903AbZJLMHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903AbZJLMHW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 08:07:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755797AbZJLMHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 08:07:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:42948 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755794AbZJLMHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 08:07:17 -0400
Subject: [PATCH 2/4] Mark pci_apply_final_quirks() __init rather than
 __devinit
From: David Woodhouse <dwmw2@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J.Wysocki" <rjw@sisk.pl>, Greg Kroah-Hartman <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
In-Reply-To: <1255342738.24732.265.camel@macbook.infradead.org>
References: <1255342738.24732.265.camel@macbook.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 12 Oct 2009 13:06:14 +0100
Message-Id: <1255349174.10605.9.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It doesn't get invoked on hotplug; it can be thrown away after init.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
---
 drivers/pci/quirks.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 0142275..77bf620 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -2573,7 +2573,7 @@ void pci_fixup_device(enum pci_fixup_pass pass, struct pci_dev *dev)
 	pci_do_fixups(dev, start, end);
 }
 
-static int __devinit pci_apply_final_quirks(void)
+static int __init pci_apply_final_quirks(void)
 {
 	struct pci_dev *dev = NULL;
 
-- 
1.6.5.rc2



