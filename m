Return-Path: <linux-kernel-owner+w=401wt.eu-S1761155AbZAHSEM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761155AbZAHSEM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 13:04:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753022AbZAHSDz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 13:03:55 -0500
Received: from mail.gmx.net ([213.165.64.20]:43872 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752961AbZAHSDy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 13:03:54 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX19GWS9ys1pG5QdHSglX/uE8LvjB/ryCOtDvCu/wDa
	2ldfP+Z/ilHyrC
Date: Thu, 8 Jan 2009 19:04:04 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-arm-kernel@lists.arm.linux.org.uk
cc: Sascha Hauer <s.hauer@pengutronix.de>,
       Dan Williams <dan.j.williams@intel.com>,
       linux-fbdev-devel@lists.sourceforge.net, adaplas@gmail.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/4 v8] i.MX31: dmaengine and framebuffer drivers
Message-ID: <Pine.LNX.4.64.0901081850280.6387@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.49
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is version 8 of dmaengine and framebuffer drivers for i.MX31.

Changes since version 7: updated to today's Linus git with pulled patches 
from async_tx tree (dmaengine)

Changes since version 6: fixed compiler warnings, compilation breakage for 
CONFIG_MX3_IPU not defined

Changes since version 5: as requested by Sascha Hauer switched to dynamic 
IPU IRQ mapping. Instead of statically allocating 137 irq_desc[] elements, 
I provide a configuration variable to specify how many interrupt slots 
should be allocated. The default value is 4, minimum 2, maximum 137. Then 
these slots are used to dynamically map interrupts upon user requests to 
available IRQ numbers. Also removed all traces of overlay framebuffer, and 
removed bogus use of nonstd field from the framebuffer driver, as 
requested by Geert Uytterhoeven. Thanks to all who commented.

Changes since version 4: addressed comments from Sascha Hauer, apart from: 
the idmac driver still uses two locks - a mutex and a spinlock, the "ugly" 
construction like "to_ipu(to_idmac(ichan->dma_chan.device));" is still 
there, still all 144 IRQs are registered. So now the driver is under 
drivers/dma, also fixed all docbook comments.

Changes since version 3: fixed idmac_issue_pending() to not reset the 
current buffer, fixed return value from idmac_tx_submit(), fixed 
framebuffer panning.

Changes since version 2: now uses a tasklet to clean up completed 
transaction descriptors, as suggested by Dan Williams.

Changes since version 1: rebased on the updated dmaengine framework.

Aimed at 2.6.29.

Based on Linus' git commit 9e42d0cf5020aaf217433cad1a224745241d212a
plus git://git.kernel.org/pub/scm/linux/kernel/git/djbw/async_tx.git next

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
