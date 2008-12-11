Return-Path: <linux-kernel-owner+w=401wt.eu-S1757955AbYLKTTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757955AbYLKTTh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 14:19:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756807AbYLKTSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 14:18:07 -0500
Received: from kroah.org ([198.145.64.141]:55787 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756352AbYLKTSD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 14:18:03 -0500
Date: Thu, 11 Dec 2008 11:13:40 -0800
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
       alan@lxorguk.ukuu.org.uk,
       Frederic Moulins <frederic.moulins@alsatis.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 05/83] pppol2tp: Add missing sock_put() in
	pppol2tp_release()
Message-ID: <20081211191340.GE5894@kroah.com>
References: <20081211190201.612240183@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline; filename="0004-pppol2tp-Add-missing-sock_put-in-pppol2tp_release.patch"
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081211191014.GA5759@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Frédéric Moulins <frederic.moulins@alsatis.com>

[ Upstream commit e6358135147807351db3b7782d3e198a1bba8b62 ]

pppol2tp_sock_to_session() do sock_hold() if the session to release is
not NULL.

Signed-off-by: Frederic Moulins <frederic.moulins@alsatis.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

---
 drivers/net/pppol2tp.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/pppol2tp.c
+++ b/drivers/net/pppol2tp.c
@@ -1353,6 +1353,7 @@ static int pppol2tp_release(struct socke
 			kfree_skb(skb);
 			sock_put(sk);
 		}
+		sock_put(sk);
 	}
 
 	release_sock(sk);

