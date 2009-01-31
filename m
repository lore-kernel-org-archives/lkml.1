Return-Path: <linux-kernel-owner+w=401wt.eu-S1758254AbZAaDJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758254AbZAaDJ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 22:09:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755583AbZAaCrq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 21:47:46 -0500
Received: from kroah.org ([198.145.64.141]:55538 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753090AbZAaCrh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 21:47:37 -0500
Date: Fri, 30 Jan 2009 18:44:25 -0800
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
       alan@lxorguk.ukuu.org.uk, Robin Holt <holt@sgi.com>,
       Dean Nelson <dcn@sgi.com>
Subject: [patch 30/43] sgi-xpc: Remove NULL pointer dereference.
Message-ID: <20090131024425.GE12368@kroah.com>
References: <20090131022548.656772939@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sgi-xpc-remove-null-pointer-dereference.patch"
In-Reply-To: <20090131024158.GA12368@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Robin Holt <holt@sgi.com>

commit 17e2161654da4e6bdfd8d53d4f52e820ee93f423 upstream.

If the bte copy fails, the attempt to retrieve payloads merely returns a
null pointer deref and not NULL as was expected.

Signed-off-by: Robin Holt <holt@sgi.com>
Signed-off-by: Dean Nelson <dcn@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/misc/sgi-xp/xpc_sn2.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/misc/sgi-xp/xpc_sn2.c
+++ b/drivers/misc/sgi-xp/xpc_sn2.c
@@ -1961,11 +1961,13 @@ xpc_get_deliverable_payload_sn2(struct x
 
 			msg = xpc_pull_remote_msg_sn2(ch, get);
 
-			DBUG_ON(msg != NULL && msg->number != get);
-			DBUG_ON(msg != NULL && (msg->flags & XPC_M_SN2_DONE));
-			DBUG_ON(msg != NULL && !(msg->flags & XPC_M_SN2_READY));
+			if (msg != NULL) {
+				DBUG_ON(msg->number != get);
+				DBUG_ON(msg->flags & XPC_M_SN2_DONE);
+				DBUG_ON(!(msg->flags & XPC_M_SN2_READY));
 
-			payload = &msg->payload;
+				payload = &msg->payload;
+			}
 			break;
 		}
 

