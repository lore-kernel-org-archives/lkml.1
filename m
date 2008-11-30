Return-Path: <linux-kernel-owner+w=401wt.eu-S1753490AbYK3Mjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490AbYK3Mjf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 07:39:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751378AbYK3Mj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 07:39:26 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:44011 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbYK3MjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 07:39:25 -0500
Date: Sun, 30 Nov 2008 12:39:24 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: linux-next: WARNING: at fs/sysfs/dir.c:425
	sysfs_add_one+0x31/0x7a()
Message-ID: <20081130123924.GW28946@ZenIV.linux.org.uk>
References: <1210366580.4148.4.camel@dhcppc1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1210366580.4148.4.camel@dhcppc1>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2008 at 10:56:20PM +0200, Thomas Meyer wrote:
> I get this warning while setting up a packet dvd mapping with:
> 
> # pktsetup pktcdvd0 /dev/sr0

[snip]

That ought to fix it:

diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index f20bf35..79981f2 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -417,6 +417,7 @@ static int pkt_sysfs_init(void)
 		printk(DRIVER_NAME": failed to create class pktcdvd\n");
 		return ret;
 	}
+	class_pktcdvd->dev_kobj = NULL;
 	return 0;
 }
 
