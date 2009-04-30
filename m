Return-Path: <linux-kernel-owner+w=401wt.eu-S1764640AbZD3RH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764640AbZD3RH7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 13:07:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763453AbZD3RHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 13:07:15 -0400
Received: from kroah.org ([198.145.64.141]:39094 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756394AbZD3RHM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 13:07:12 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Apr 30 09:57:38 2009
Message-Id: <20090430165738.622968895@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 30 Apr 2009 09:55:51 -0700
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
       alan@lxorguk.ukuu.org.uk, Al Viro <viro@zeniv.linux.org.uk>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 02/88] net: fix sctp breakage
References: <20090430165549.117010404@mini.kroah.org>
Content-Disposition: inline; filename=net-fix-sctp-breakage.patch
In-Reply-To: <20090430170122.GA16015@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit cb0dc77de0d23615a845e45844a2e22fc224d7fe ]

broken by commit 5e739d1752aca4e8f3e794d431503bfca3162df4; AFAICS should
be -stable fodder as well...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Aced-by: Vlad Yasevich <vladislav.yasevich@hp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/sctp/endpointola.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/sctp/endpointola.c
+++ b/net/sctp/endpointola.c
@@ -111,7 +111,8 @@ static struct sctp_endpoint *sctp_endpoi
 		if (sctp_addip_enable) {
 			auth_chunks->chunks[0] = SCTP_CID_ASCONF;
 			auth_chunks->chunks[1] = SCTP_CID_ASCONF_ACK;
-			auth_chunks->param_hdr.length += htons(2);
+			auth_chunks->param_hdr.length =
+					htons(sizeof(sctp_paramhdr_t) + 2);
 		}
 	}
 


