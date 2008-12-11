Return-Path: <linux-kernel-owner+w=401wt.eu-S1757876AbYLKTTK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757876AbYLKTTK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 14:19:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756111AbYLKTSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 14:18:06 -0500
Received: from kroah.org ([198.145.64.141]:55727 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756467AbYLKTSD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 14:18:03 -0500
Date: Thu, 11 Dec 2008 11:13:32 -0800
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
       alan@lxorguk.ukuu.org.uk, Jianjun Kong <jianjun@zeuux.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 02/83] af_unix: netns: fix problem of return value
Message-ID: <20081211191332.GB5894@kroah.com>
References: <20081211190201.612240183@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0001-af_unix-netns-fix-problem-of-return-value.patch"
In-Reply-To: <20081211191014.GA5759@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jianjun Kong <jianjun@zeuux.org>

[ Upstream commit 48dcc33e5e11de0f76b65b113988dbc930d17395 ]

fix problem of return value

net/unix/af_unix.c: unix_net_init()
when error appears, it should return 'error', not always return 0.

Signed-off-by: Jianjun Kong <jianjun@zeuux.org>
Signed-off-by: David S. Miller <davem@davemloft.net>

---
 net/unix/af_unix.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2230,7 +2230,7 @@ static int unix_net_init(struct net *net
 #endif
 	error = 0;
 out:
-	return 0;
+	return error;
 }
 
 static void unix_net_exit(struct net *net)

