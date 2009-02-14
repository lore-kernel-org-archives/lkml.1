Return-Path: <linux-kernel-owner+w=401wt.eu-S1762870AbZBNBI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762870AbZBNBI3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 20:08:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760539AbZBNBBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 20:01:44 -0500
Received: from kroah.org ([198.145.64.141]:39617 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759929AbZBNBBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 20:01:41 -0500
Date: Fri, 13 Feb 2009 16:58:42 -0800
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
       alan@lxorguk.ukuu.org.uk, Roel Kluin <roel.kluin@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 19/47] drivers/net/skfp: if !capable(CAP_NET_ADMIN):
	inverted logic
Message-ID: <20090214005842.GT11282@kroah.com>
References: <20090214005130.617401075@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="drivers-net-skfp-if-capable-inverted-logic.patch"
In-Reply-To: <20090214005726.GA11282@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Roel Kluin <roel.kluin@gmail.com>

[ Upstream commit c25b9abbc2c2c0da88e180c3933d6e773245815a ]

Fix inverted logic

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/skfp/skfddi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/skfp/skfddi.c
+++ b/drivers/net/skfp/skfddi.c
@@ -998,9 +998,9 @@ static int skfp_ioctl(struct net_device 
 		break;
 	case SKFP_CLR_STATS:	/* Zero out the driver statistics */
 		if (!capable(CAP_NET_ADMIN)) {
-			memset(&lp->MacStat, 0, sizeof(lp->MacStat));
-		} else {
 			status = -EPERM;
+		} else {
+			memset(&lp->MacStat, 0, sizeof(lp->MacStat));
 		}
 		break;
 	default:

