Return-Path: <linux-kernel-owner+w=401wt.eu-S1031419AbXDZSSL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031419AbXDZSSL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 14:18:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031417AbXDZSSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 14:18:11 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:59820 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031419AbXDZSSI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 14:18:08 -0400
Date: Thu, 26 Apr 2007 22:17:44 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Dan Williams <dan.j.williams@intel.com>
Subject: Re: W1 printk format warning
Message-ID: <20070426181743.GA3552@2ka.mipt.ru>
References: <20070425162104.168c32b6.randy.dunlap@oracle.com> <20070425164509.715ca5c9.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070425164509.715ca5c9.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Thu, 26 Apr 2007 22:17:47 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2007 at 04:45:09PM -0700, Andrew Morton (akpm@linux-foundation.org) wrote:
> On Wed, 25 Apr 2007 16:21:04 -0700 Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
> > in 2.6.21-rc7-mm1.  Are you aware of this?
> > 
> > drivers/w1/w1.c:460: warning: too few arguments for format
> > 
> > 	dev_dbg(&sl->dev, "%s: registering %s as %p.\n", __func__,
> > 		&sl->dev.bus_id[0]);
> > 
> 
> Yeah, that's because Dan's dev_dbg-check-dev_dbg-arguments.patch added
> printk arg-checking to dev_dbg() and a bunch of bugs got exposed.  I fixed
> a few of them.

Could you post a full list for w1, if there is only one, here is a fix.

Thanks a lot, Randy.

diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
index 63c0724..7d6876d 100644
--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -459,7 +459,7 @@ static int __w1_attach_slave_device(struct w1_slave *sl)
 		 (unsigned long long) sl->reg_num.id);
 
 	dev_dbg(&sl->dev, "%s: registering %s as %p.\n", __func__,
-		&sl->dev.bus_id[0]);
+		&sl->dev.bus_id[0], sl);
 
 	err = device_register(&sl->dev);
 	if (err < 0) {
-- 
	Evgeniy Polyakov
