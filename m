Return-Path: <linux-kernel-owner+w=401wt.eu-S933265AbXKOHAG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933265AbXKOHAG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 02:00:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764449AbXKOGrb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:47:31 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:58032 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763977AbXKOGra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:47:30 -0500
Date: Wed, 14 Nov 2007 22:44:54 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Roland Dreier <roland@digitalvampire.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [patch 19/40] MSI: Use correct data offset for 32-bit MSI in
	read_msi_msg()
Message-ID: <20071115064454.GT19218@kroah.com>
References: <20071115062710.885284510@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="msi-use-correct-data-offset-for-32-bit-msi-in-read_msi_msg.patch"
In-Reply-To: <20071115064302.GA19218@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Roland Dreier <roland@digitalvampire.org>

patch cbf5d9e6b9bcf03291cbb51db144b3e2773a8a2d in mainline.

While reading the MSI code trying to find a reason why MSI wouldn't
work for devices that have a 32-bit MSI address capability, I noticed
that read_msi_msg() seems to read the message data from the wrong
offset in this case.

Signed-off-by: Roland Dreier <roland@digitalvampire.org>
Acked-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/msi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -132,7 +132,7 @@ void read_msi_msg(unsigned int irq, stru
 			pci_read_config_word(dev, msi_data_reg(pos, 1), &data);
 		} else {
 			msg->address_hi = 0;
-			pci_read_config_word(dev, msi_data_reg(pos, 1), &data);
+			pci_read_config_word(dev, msi_data_reg(pos, 0), &data);
 		}
 		msg->data = data;
 		break;

-- 
