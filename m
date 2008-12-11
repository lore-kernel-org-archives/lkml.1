Return-Path: <linux-kernel-owner+w=401wt.eu-S1761564AbYLKToF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761564AbYLKToF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 14:44:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757669AbYLKTT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 14:19:28 -0500
Received: from kroah.org ([198.145.64.141]:56732 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757908AbYLKTTY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 14:19:24 -0500
Date: Thu, 11 Dec 2008 11:16:28 -0800
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
       alan@lxorguk.ukuu.org.uk, Alex Chiang <achiang@hp.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [patch 72/83] PCI: stop leaking slot_name in pci_create_slot
Message-ID: <20081211191628.GT5894@kroah.com>
References: <20081211190201.612240183@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="pci-stop-leaking-slot_name-in-pci_create_slot.patch"
In-Reply-To: <20081211191014.GA5759@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Chiang <achiang@hp.com>

commit 3b5dd45e947ecd21491e1658fba7bb4bc4a54995 upstream.

In pci_create_slot(), the local variable 'slot_name' is allocated by
make_slot_name(), but never freed. We never use it after passing it to
the kobject core, so we should free it upon function exit.

Signed-off-by: Alex Chiang <achiang@hp.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/slot.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/pci/slot.c
+++ b/drivers/pci/slot.c
@@ -243,6 +243,7 @@ placeholder:
 		 __func__, pci_domain_nr(parent), parent->number, slot_nr);
 
 out:
+	kfree(slot_name);
 	up_write(&pci_bus_sem);
 	return slot;
 err:

