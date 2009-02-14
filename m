Return-Path: <linux-kernel-owner+w=401wt.eu-S1765739AbZBNBg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765739AbZBNBg0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 20:36:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761332AbZBNBQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 20:16:28 -0500
Received: from kroah.org ([198.145.64.141]:50398 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764116AbZBNBQT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 20:16:19 -0500
Date: Fri, 13 Feb 2009 17:13:02 -0800
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
Subject: [patch 21/48] drivers/net/skfp: if !capable(CAP_NET_ADMIN):
	inverted logic
Message-ID: <20090214011302.GV17706@kroah.com>
References: <20090214010805.419403436@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="drivers-net-skfp-if-capable-inverted-logic.patch"
In-Reply-To: <20090214011208.GA17706@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

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

