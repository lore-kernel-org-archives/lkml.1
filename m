Return-Path: <linux-kernel-owner+w=401wt.eu-S1758416AbYGVXdG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758416AbYGVXdG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 19:33:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756508AbYGVXX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 19:23:28 -0400
Received: from cantor.suse.de ([195.135.220.2]:53710 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758111AbYGVXX1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 19:23:27 -0400
Date: Tue, 22 Jul 2008 16:17:32 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Vitaly Bordug <vitb@kernel.crashing.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [patch 43/47] powerpc: Add missing reference to coherent_dma_mask
Message-ID: <20080722231732.GR8282@suse.de>
References: <20080722230208.148102983@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="powerpc-add-missing-reference-to-coherent_dma_mask.patch"
In-Reply-To: <20080722231342.GA8282@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Vitaly Bordug <vitb@kernel.crashing.org>

commit ba0fc709e197415aadd46b9ec208dc4abaa21edd upstream

There is dma_mask in of_device upon of_platform_device_create()
but we don't actually set coherent_dma_mask. This may cause weird
behavior of USB subsystem using of_device USB host drivers.

Signed-off-by: Vitaly Bordug <vitb@kernel.crashing.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/kernel/of_platform.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/powerpc/kernel/of_platform.c
+++ b/arch/powerpc/kernel/of_platform.c
@@ -76,6 +76,8 @@ struct of_device* of_platform_device_cre
 		return NULL;
 
 	dev->dma_mask = 0xffffffffUL;
+	dev->dev.coherent_dma_mask = DMA_32BIT_MASK;
+
 	dev->dev.bus = &of_platform_bus_type;
 
 	/* We do not fill the DMA ops for platform devices by default.

-- 
