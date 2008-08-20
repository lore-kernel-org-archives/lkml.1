Return-Path: <linux-kernel-owner+w=401wt.eu-S1756656AbYHTBLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656AbYHTBLb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 21:11:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754121AbYHTBKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 21:10:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:48487 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754067AbYHTBKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 21:10:33 -0400
Date: Tue, 19 Aug 2008 18:07:55 -0700
From: greg@kroah.com
To: Jeff Garzik <jgarzik@pobox.com>,
       Linux USB kernel mailing list <linux-usb@vger.kernel.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Denis Joseph Barrow <D.Barow@option.com>
Subject: [patch 02/02] hso: dev_kfree_skb crash fix
Message-ID: <20080820010755.GC3365@kroah.com>
References: <20080820010353.593820280@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="hso-dev_kfree_skb-crash-fix.patch"
In-Reply-To: <20080820010738.GA3365@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Denis Joseph Barrow <D.Barow@option.com>

Fixes dev_kfree_skb happening too many times when hso_start_net_device
is called from hso_resume.

Signed-off-by: Denis Joseph Barrow <D.Barow@option.com>
Cc: Jeff Garzik <jgarzik@pobox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/usb/hso.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -2613,6 +2613,7 @@ static int hso_resume(struct usb_interfa
 					"Transmitting lingering data\n");
 				hso_net_start_xmit(hso_net->skb_tx_buf,
 						   hso_net->net);
+				hso_net->skb_tx_buf = NULL;
 			}
 			result = hso_start_net_device(network_table[i]);
 			if (result)

-- 
