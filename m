Return-Path: <linux-kernel-owner+w=401wt.eu-S1757482AbZBJTLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482AbZBJTLv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 14:11:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755627AbZBJTDv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 14:03:51 -0500
Received: from kroah.org ([198.145.64.141]:53858 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755595AbZBJTDu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 14:03:50 -0500
Date: Tue, 10 Feb 2009 11:00:29 -0800
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
       alan@lxorguk.ukuu.org.uk, Karsten Keil <kkeil@suse.de>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 23/53] e1000: Fix PCI enable to honor the need_ioport flag
Message-ID: <20090210190029.GX14308@kroah.com>
References: <20090210185337.000769713@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="e1000-fix-pci-enable-to-honor-the-need_ioport-flag.patch"
In-Reply-To: <20090210185924.GA14308@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Karsten Keil <kkeil@suse.de>

commit 4d7155b932b8129c72e2f2714890e20b2a05e0b7 upstream.

On machine were no IO ports are assigned the call
to pci_enable_device() will fail, even if need_ioport
is false, we need to use pci_enable_device_mem() here.

Signed-off-by: Karsten Keil <kkeil@suse.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/e1000/e1000_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/e1000/e1000_main.c
+++ b/drivers/net/e1000/e1000_main.c
@@ -921,7 +921,7 @@ static int __devinit e1000_probe(struct 
 		err = pci_enable_device(pdev);
 	} else {
 		bars = pci_select_bars(pdev, IORESOURCE_MEM);
-		err = pci_enable_device(pdev);
+		err = pci_enable_device_mem(pdev);
 	}
 	if (err)
 		return err;

