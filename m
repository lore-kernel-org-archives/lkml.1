Return-Path: <linux-kernel-owner+w=401wt.eu-S2992714AbXEBE2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992714AbXEBE2d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 00:28:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992715AbXEBE2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 00:28:32 -0400
Received: from smtp-out.google.com ([216.239.45.13]:24838 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992714AbXEBE2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 00:28:31 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=xBBZcMPJ+VTS8f+vx4FKHfnL4AuKpFZy67n8wDfxTE7z03ihc0X+gXzZaq59v+oH0
	QRfaIiI90QlAl5lnl5Cwg==
Date: Tue, 1 May 2007 21:28:22 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org
Subject: [patch 02/10] i386 pci: type may be unused
In-Reply-To: <Pine.LNX.4.64.0705012118130.19277@chino.kir.corp.google.com>
Message-ID: <Pine.LNX.4.64.0705012119370.19277@chino.kir.corp.google.com>
References: <Pine.LNX.4.64.0705012118130.19277@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In the case of !CONFIG_PCI_DIRECT && !CONFIG_PCI_MMCONFIG, type is
unreferened.

Cc: Andi Kleen <ak@suse.de>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 arch/i386/pci/init.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/i386/pci/init.c b/arch/i386/pci/init.c
--- a/arch/i386/pci/init.c
+++ b/arch/i386/pci/init.c
@@ -6,7 +6,7 @@
    in the right sequence from here. */
 static __init int pci_access_init(void)
 {
-	int type = 0;
+	int type __attribute_unused__ = 0;
 
 #ifdef CONFIG_PCI_DIRECT
 	type = pci_direct_probe();
