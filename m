Return-Path: <linux-kernel-owner+w=401wt.eu-S1756505AbYICRhe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505AbYICRhe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 13:37:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756220AbYICRgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 13:36:42 -0400
Received: from ns2.suse.de ([195.135.220.15]:55627 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754318AbYICRgl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 13:36:41 -0400
Date: Wed, 3 Sep 2008 10:25:44 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
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
       alan@lxorguk.ukuu.org.uk, Jay Cliburn <jacliburn@bellsouth.net>,
       Jeff Garzik <jgarzik@redhat.com>
Subject: [patch 14/42] atl1: disable TSO by default
Message-ID: <20080903172544.GO7731@suse.de>
References: <20080903171927.534216229@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="atl1-disable-tso-by-default.patch"
In-Reply-To: <20080903172447.GA7731@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jay Cliburn <jacliburn@bellsouth.net>

commit 82c26a9d117f0178b8c1b33429014b6d99c470f6 upstream

The atl1 driver is causing stalled connections and file corruption
whenever TSO is enabled.  Two examples are here:

http://lkml.org/lkml/2008/7/15/325
http://lkml.org/lkml/2008/8/18/543

Disable TSO by default until we can determine the source of the
problem.

Signed-off-by: Jay Cliburn <jacliburn@bellsouth.net>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/atlx/atl1.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/net/atlx/atl1.c
+++ b/drivers/net/atlx/atl1.c
@@ -3019,7 +3019,6 @@ static int __devinit atl1_probe(struct p
 	netdev->features = NETIF_F_HW_CSUM;
 	netdev->features |= NETIF_F_SG;
 	netdev->features |= (NETIF_F_HW_VLAN_TX | NETIF_F_HW_VLAN_RX);
-	netdev->features |= NETIF_F_TSO;
 	netdev->features |= NETIF_F_LLTX;
 
 	/*

-- 
