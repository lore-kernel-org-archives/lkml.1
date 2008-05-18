Return-Path: <linux-kernel-owner+w=401wt.eu-S1759904AbYERNBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759904AbYERNBV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 09:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756011AbYERNBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 09:01:10 -0400
Received: from yumi.tdiedrich.de ([85.10.210.183]:33235 "EHLO mx.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754799AbYERNBJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 09:01:09 -0400
Date: Sun, 18 May 2008 15:00:36 +0200
From: Tobias Diedrich <ranma+kernel@tdiedrich.de>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ayaz Abdulla <aabdulla@nvidia.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: [PATCH 1/4] Restore multicast settings on resume
Message-ID: <20080518130035.GA21417@yamamaya.is-a-geek.org>
Mail-Followup-To: Tobias Diedrich <ranma+kernel@tdiedrich.de>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ayaz Abdulla <aabdulla@nvidia.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Stephen Hemminger <shemminger@linux-foundation.org>
References: <20080518125715.GA19229@yamamaya.is-a-geek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080518125715.GA19229@yamamaya.is-a-geek.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tobias Diedrich <ranma+kernel@tdiedrich.de>

nv_open() resets multicast settings, call nv_set_multicast(dev) to restore them.
(Maybe this should rather be moved into nv_open())

Signed-off-by: Tobias Diedrich <ranma+kernel@tdiedrich.de>

Index: linux-2.6.26-rc2.forcedwol/drivers/net/forcedeth.c
===================================================================
--- linux-2.6.26-rc2.forcedwol.orig/drivers/net/forcedeth.c	2008-05-18 13:52:59.000000000 +0200
+++ linux-2.6.26-rc2.forcedwol/drivers/net/forcedeth.c	2008-05-18 13:53:02.000000000 +0200
@@ -5823,6 +5823,7 @@
 	writel(txreg, base + NvRegTransmitPoll);
 
 	rc = nv_open(dev);
+	nv_set_multicast(dev);
 out:
 	return rc;
 }
