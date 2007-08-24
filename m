Return-Path: <linux-kernel-owner+w=401wt.eu-S1762280AbXHXWBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762280AbXHXWBi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 18:01:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757733AbXHXWBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 18:01:31 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:55041 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757035AbXHXWBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 18:01:30 -0400
Date: Fri, 24 Aug 2007 15:00:21 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: sekharan@us.ibm.com
Cc: Martin Michlmayr <tbm@cyrius.com>, Mike Christie <michaelc@cs.wisc.edu>,
       linux-kernel@vger.kernel.org
Subject: Re: DM_MULTIPATH_RDAC: "scsi_normalize_sense" undefined
Message-Id: <20070824150021.a7fdc9f6.randy.dunlap@oracle.com>
In-Reply-To: <1187991182.17399.336.camel@linuxchandra>
References: <20070824160834.GA7029@deprecation.cyrius.com>
	<1187991182.17399.336.camel@linuxchandra>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Aug 2007 14:33:02 -0700 Chandra Seetharaman wrote:

> It does, but "rdac" _is_ for a SCSI device.

It does __what__ ?  depend on SCSI?
I don't see that in drivers/md/Kconfig.
Sounds like Martin is correct, SCSI needs to be added, like below.


> What device are you using it with ?
> 
> On Fri, 2007-08-24 at 18:08 +0200, Martin Michlmayr wrote:
> > I just got:
> > 
> >   Building modules, stage 2.
> >   MODPOST 414 modules
> > ERROR: "scsi_normalize_sense" [drivers/md/dm-rdac.ko] undefined!
> > make[1]: *** [__modpost] Error 1
> > 
> > Presumably DM_MULTIPATH_RDAC needs to depend on SCSI (not enabled
> > here) since it uses scsi_normalize_sense.

---

From: Randy Dunlap <randy.dunlap@oracle.com>

DM_MULTIPATH_RDAC uses SCSI API(s) and is for a SCSI device,
so add SCSI to its depends on to prevent build errors.

Not tested.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/md/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.23-rc3-git6.orig/drivers/md/Kconfig
+++ linux-2.6.23-rc3-git6/drivers/md/Kconfig
@@ -263,7 +263,7 @@ config DM_MULTIPATH_EMC
 
 config DM_MULTIPATH_RDAC
 	tristate "LSI/Engenio RDAC multipath support (EXPERIMENTAL)"
-	depends on DM_MULTIPATH && BLK_DEV_DM && EXPERIMENTAL
+	depends on DM_MULTIPATH && BLK_DEV_DM && SCSI && EXPERIMENTAL
 	---help---
 	  Multipath support for LSI/Engenio RDAC.
 
