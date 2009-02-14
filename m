Return-Path: <linux-kernel-owner+w=401wt.eu-S1763326AbZBNBkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763326AbZBNBkW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 20:40:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762217AbZBNBQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 20:16:37 -0500
Received: from kroah.org ([198.145.64.141]:50538 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763344AbZBNBQ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 20:16:29 -0500
Date: Fri, 13 Feb 2009 17:13:22 -0800
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
       alan@lxorguk.ukuu.org.uk, Alexey Dobriyan <adobriyan@gmail.com>,
       Stephen Hemminger <shemminger@vyatta.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 32/48] sky2: fix hard hang with netconsoling and iface
	going up
Message-ID: <20090214011322.GF17706@kroah.com>
References: <20090214010805.419403436@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sky2-fix-hard-hang-with-netconsoling-and-iface-going-up.patch"
In-Reply-To: <20090214011208.GA17706@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alexey Dobriyan <adobriyan@gmail.com>

[ Upstream commit a11da890e4c9850411303efcf6514f048ca880ee ]

Printing anything over netconsole before hw is up and running is,
of course, not going to work.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Acked-by: Stephen Hemminger <shemminger@vyatta.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/sky2.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/sky2.c
+++ b/drivers/net/sky2.c
@@ -1403,9 +1403,6 @@ static int sky2_up(struct net_device *de
 
  	}
 
-	if (netif_msg_ifup(sky2))
-		printk(KERN_INFO PFX "%s: enabling interface\n", dev->name);
-
 	netif_carrier_off(dev);
 
 	/* must be power of 2 */
@@ -1484,6 +1481,9 @@ static int sky2_up(struct net_device *de
 	sky2_write32(hw, B0_IMSK, imask);
 
 	sky2_set_multicast(dev);
+
+	if (netif_msg_ifup(sky2))
+		printk(KERN_INFO PFX "%s: enabling interface\n", dev->name);
 	return 0;
 
 err_out:

