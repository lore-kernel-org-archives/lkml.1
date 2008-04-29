Return-Path: <linux-kernel-owner+w=401wt.eu-S1765658AbYD2Syw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765658AbYD2Syw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 14:54:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762349AbYD2SvZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 14:51:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41426 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761002AbYD2SvX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 14:51:23 -0400
Date: Tue, 29 Apr 2008 11:50:10 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Paul Bolle <pebolle@tiscali.nl>,
       "David S. Miller" <davem@davemloft.net>
Subject: [12/12] ISDN: Do not validate ISDN net device address prior to
	interface-up
Message-ID: <20080429185010.GN24199@suse.de>
References: <20080429184543.308594866@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="isdn-do-not-validate-isdn-net-device-address-prior-to-interface-up.patch"
In-Reply-To: <20080429184911.GA24199@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.24-stable review patch.  If anyone has any objections, please let us know.

------------------

Commit bada339 (Validate device addr prior to interface-up) caused a regression
in the ISDN network code, see: http://bugzilla.kernel.org/show_bug.cgi?id=9923
The trivial fix is to remove the pointer to eth_validate_addr() in the
net_device struct in isdn_net_init().

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/isdn/i4l/isdn_net.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/isdn/i4l/isdn_net.c
+++ b/drivers/isdn/i4l/isdn_net.c
@@ -2010,6 +2010,7 @@ isdn_net_init(struct net_device *ndev)
 	ndev->flags = IFF_NOARP|IFF_POINTOPOINT;
 	ndev->type = ARPHRD_ETHER;
 	ndev->addr_len = ETH_ALEN;
+	ndev->validate_addr = NULL;
 
 	/* for clients with MPPP maybe higher values better */
 	ndev->tx_queue_len = 30;

-- 
