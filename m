Return-Path: <linux-kernel-owner+w=401wt.eu-S1763027AbYD3Nd6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763027AbYD3Nd6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 09:33:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756945AbYD3Ndq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 09:33:46 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57584 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756597AbYD3Ndp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 09:33:45 -0400
Date: Tue, 29 Apr 2008 08:33:34 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "stephane eranian" <eranian@googlemail.com>
Cc: linux-kernel@vger.kernel.org, ia64 <linux-ia64@vger.kernel.org>
Subject: Re: 2.6.25 new perfmon kernel patch + libpfm + pfmon available
Message-ID: <20080429083334.1a019318@infradead.org>
In-Reply-To: <7c86c4470804300611s7442fe11lba2b66f5a3a8ed88@mail.gmail.com>
References: <7c86c4470804291446l4693b317ha7ee2382d00e99e6@mail.gmail.com>
	<7c86c4470804291447w713934a7o2b8a5a690fc9a535@mail.gmail.com>
	<20080429080853.48c66b29@infradead.org>
	<7c86c4470804300611s7442fe11lba2b66f5a3a8ed88@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Apr 2008 15:11:11 +0200
"stephane eranian" <eranian@googlemail.com> wrote:

> Sorry,
> 
> It's http://perfmon2.sf.net
> 
> 

hummmmm, I wonder why perfmon wants to reimplement half of the PCI layer...

+extern spinlock_t pci_config_lock;
+
+#define PCI_CONF1_ADDRESS(bus, devfn, reg) \
+       (0x80000000 | ((reg & 0xF00) << 16) | ((bus & 0xFF) << 16) \
+       | (devfn << 8) | (reg & 0xFC))
+
+#define is_ibs_pmc(x) (x == 4 || x == 5)
+
+static int pci_read(unsigned int seg, unsigned int bus,
+                   unsigned int devfn, int reg, int len, u32 *value)
+{
+       unsigned long flags;

especially since this doesn't seem to use the proper config space abstractions :(
