Return-Path: <linux-kernel-owner+w=401wt.eu-S933004AbZAOURU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933004AbZAOURU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 15:17:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762230AbZAOUAz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 15:00:55 -0500
Received: from kroah.org ([198.145.64.141]:48984 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1765945AbZAOUAl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 15:00:41 -0500
Date: Thu, 15 Jan 2009 11:58:11 -0800
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
       alan@lxorguk.ukuu.org.uk, Larry Finger <Larry.Finger@lwfinger.net>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [patch 26/94] SCSI: aha152x_cs: Fix regression that keeps driver
	from using shared interrupts
Message-ID: <20090115195811.GZ14419@kroah.com>
References: <20090115194806.804618825@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="scsi-aha152x_cs-fix-regression-that-keeps-driver-from-using-shared-interrupts.patch"
In-Reply-To: <20090115195520.GA14403@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit 58607b30fc0f2230a189500112c7a7cca02804cf upstream.

At some point since 2.6.22, the aha152x_cs driver stopped working and
started erring on load with the following messages:

kernel: pcmcia: request for exclusive IRQ could not be fulfilled.
kernel: pcmcia: the driver needs updating to supported shared IRQ lines.

With the following change, the driver works with shared IRQs.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/pcmcia/aha152x_stub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/pcmcia/aha152x_stub.c
+++ b/drivers/scsi/pcmcia/aha152x_stub.c
@@ -114,7 +114,7 @@ static int aha152x_probe(struct pcmcia_d
     link->io.NumPorts1 = 0x20;
     link->io.Attributes1 = IO_DATA_PATH_WIDTH_AUTO;
     link->io.IOAddrLines = 10;
-    link->irq.Attributes = IRQ_TYPE_EXCLUSIVE;
+    link->irq.Attributes = IRQ_TYPE_DYNAMIC_SHARING;
     link->irq.IRQInfo1 = IRQ_LEVEL_ID;
     link->conf.Attributes = CONF_ENABLE_IRQ;
     link->conf.IntType = INT_MEMORY_AND_IO;

