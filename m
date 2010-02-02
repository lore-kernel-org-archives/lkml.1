Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721Ab0BBGCJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 01:02:09 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:60297 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754512Ab0BBGCE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 01:02:04 -0500
Date: Tue, 2 Feb 2010 17:01:59 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: linux-next: manual merge of the driver-core tree with the pcmcia
 tree
Message-Id: <20100202170159.168a28e2.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta6 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Today's linux-next merge of the driver-core tree got a conflict in
drivers/pcmcia/ds.c between commit
933a838aa1aae8388438bb002fbdaf6fca519a5c ("pcmcia: make use of
pcmcia_dev_resume() return value") from the pcmcia tree and commit
df5a0aec4591ae8a5deb67bc8cb6be3d0812abb2 ("drivers/base: Convert dev->sem
to mutex") from the driver-core tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/pcmcia/ds.c
index 76a2163,263bdc8..0000000
--- a/drivers/pcmcia/ds.c
+++ b/drivers/pcmcia/ds.c
@@@ -999,10 -974,9 +999,10 @@@ static int runtime_resume(struct devic
  {
  	int rc;
  
- 	down(&dev->sem);
+ 	mutex_lock(&dev->mutex);
  	rc = pcmcia_dev_resume(dev);
- 	up(&dev->sem);
+ 	mutex_unlock(&dev->mutex);
 +	return rc;
  }
  
  /************************ per-device sysfs output ***************************/
