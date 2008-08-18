Return-Path: <linux-kernel-owner+w=401wt.eu-S932568AbYHRTEG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932568AbYHRTEG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 15:04:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756876AbYHRTBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 15:01:49 -0400
Received: from ns1.suse.de ([195.135.220.2]:43825 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762275AbYHRTBs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 15:01:48 -0400
Date: Mon, 18 Aug 2008 11:45:05 -0700
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
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       Dimitri Gorokhovik <dimitri.gorokhovik@free.fr>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [patch 42/60] ide: it821x in pass-through mode segfaults in
	2.6.26-stable
Message-ID: <20080818184505.GQ29394@suse.de>
References: <20080818183230.966310219@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ide-it821x-in-pass-through-mode-segfaults-in-2.6.26-stable.patch"
In-Reply-To: <20080818184035.GA29394@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us know.

------------------
commit 84e0f3f6c1e26588fdcb9f1b0f99d0275229bc99 upstream

The driver of ITE8212 in pass-through mode (it8212.noraid=1 on cmndline)
attempts to use the field `.dma_host_set' of the struct ide_dma_ops in
`ide_config_drive_speed' which is set to NULL by default.

So give a value to all fields of the struct ide_dma_ops.

Signed-off-by: Dimitri Gorokhovik <dimitri.gorokhovik@free.fr>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ide/pci/it821x.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/ide/pci/it821x.c
+++ b/drivers/ide/pci/it821x.c
@@ -512,8 +512,14 @@ static void __devinit it821x_quirkproc(i
 }
 
 static struct ide_dma_ops it821x_pass_through_dma_ops = {
+	.dma_host_set		= ide_dma_host_set,
+	.dma_setup		= ide_dma_setup,
+	.dma_exec_cmd		= ide_dma_exec_cmd,
 	.dma_start		= it821x_dma_start,
 	.dma_end		= it821x_dma_end,
+	.dma_test_irq		= ide_dma_test_irq,
+	.dma_timeout		= ide_dma_timeout,
+	.dma_lost_irq		= ide_dma_lost_irq,
 };
 
 /**

-- 
