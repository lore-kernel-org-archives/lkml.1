Return-Path: <linux-kernel-owner+w=401wt.eu-S1763321AbYGaARg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763321AbYGaARg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 20:17:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762957AbYGaAQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 20:16:35 -0400
Received: from cantor.suse.de ([195.135.220.2]:38998 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758717AbYGaAQe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 20:16:34 -0400
Date: Wed, 30 Jul 2008 16:59:04 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Kay Sievers <kay.sievers@vrfy.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Dan Williams <dan.j.williams@intel.com>
Subject: [patch 34/62] iop-adma: fix platform driver hotplug/coldplug
Message-ID: <20080730235904.GH12896@suse.de>
References: <20080730233050.332789722@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="iop-adma-fix-platform-driver-hotplug-coldplug.patch"
In-Reply-To: <20080730234915.GA12426@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26 -stable review patch.  If anyone has any objections, please let
us know.

------------------
From: Kay Sievers <kay.sievers@vrfy.org>

commit ebabe2762607147d28aa395ea6df2a0ee7f795a1

Since 43cc71eed1250755986da4c0f9898f9a635cb3bf, the platform
modalias is prefixed with "platform:". Add MODULE_ALIAS() to most
of the hotpluggable platform drivers, to re-enable auto loading.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/dma/iop-adma.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/dma/iop-adma.c
+++ b/drivers/dma/iop-adma.c
@@ -1387,6 +1387,8 @@ static void iop_chan_start_null_xor(stru
 	spin_unlock_bh(&iop_chan->lock);
 }
 
+MODULE_ALIAS("platform:iop-adma");
+
 static struct platform_driver iop_adma_driver = {
 	.probe		= iop_adma_probe,
 	.remove		= iop_adma_remove,

-- 
