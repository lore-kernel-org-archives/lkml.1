Return-Path: <linux-kernel-owner+w=401wt.eu-S1761413AbZEFVyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761413AbZEFVyn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 17:54:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757762AbZEFVyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 17:54:19 -0400
Received: from kroah.org ([198.145.64.141]:56836 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760819AbZEFVyR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 17:54:17 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed May  6 14:47:55 2009
Message-Id: <20090506214755.333764981@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 06 May 2009 14:45:29 -0700
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
       alan@lxorguk.ukuu.org.uk, Ed Swierk <eswierk@aristanetworks.com>,
       "David S. Miller" <davem@davemloft.net>,
       Tvrtko Ursulin <tvrtko.ursulin@sophos.com>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [patch 01/58] forcedeth: Fix resume from hibernation regression.
References: <20090506214528.660389067@mini.kroah.org>
Content-Disposition: inline; filename=forcedeth-fix-resume-from-hibernation-regression.patch
In-Reply-To: <20090506215017.GA21981@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ed Swierk <eswierk@aristanetworks.com>

upstream commit: 35a7433c789ba6df6d96b70fa745ae9e6cac0038

Reset phy state on resume, fixing a regression caused by powering down
the phy on hibernate.

Signed-off-by: Ed Swierk <eswierk@aristanetworks.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/net/forcedeth.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/forcedeth.c
+++ b/drivers/net/forcedeth.c
@@ -5995,6 +5995,9 @@ static int nv_resume(struct pci_dev *pde
 	for (i = 0;i <= np->register_size/sizeof(u32); i++)
 		writel(np->saved_config_space[i], base+i*sizeof(u32));
 
+	/* restore phy state, including autoneg */
+	phy_init(dev);
+
 	netif_device_attach(dev);
 	if (netif_running(dev)) {
 		rc = nv_open(dev);


