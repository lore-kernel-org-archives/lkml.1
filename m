Return-Path: <linux-kernel-owner+w=401wt.eu-S1755505AbZFCHXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505AbZFCHXT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 03:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753263AbZFCHXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 03:23:10 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34767 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753020AbZFCHXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 03:23:09 -0400
Date: Wed, 3 Jun 2009 17:23:07 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Woodhouse <dwmw2@infradead.org>,
       Samuel Ortiz <sameo@linux.intel.com>
Subject: linux-next: manual merge of the driver-core tree with the firmware
 tree
Message-Id: <20090603172307.ea2f6f41.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Today's linux-next merge of the driver-core tree got a conflict in
drivers/base/firmware_class.c between commit
6e03a201bbe8137487f340d26aa662110e324b20 ("firmware: speed up
request_firmware(), v3") from the firmware tree and commit
ffceb90f9b59a5186b3ce9177bfebf8819b7735a ("firmware: allocate firmware id
dynamically") from the driver-core tree.

Just overlapping additions.  I fixed it up (see below) and can carry the
fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/base/firmware_class.c
index 8a267c4,112af80..0000000
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@@ -350,13 -277,10 +350,14 @@@ static struct bin_attribute firmware_at
  static void fw_dev_release(struct device *dev)
  {
  	struct firmware_priv *fw_priv = dev_get_drvdata(dev);
 +	int i;
  
 +	for (i = 0; i < fw_priv->nr_pages; i++)
 +		__free_page(fw_priv->pages[i]);
 +	kfree(fw_priv->pages);
+ 	kfree(fw_priv->fw_id);
  	kfree(fw_priv);
- 	kfree(dev);
+ 	put_device(dev);
  
  	module_put(THIS_MODULE);
  }
