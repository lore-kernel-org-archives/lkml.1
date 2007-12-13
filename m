Return-Path: <linux-kernel-owner+w=401wt.eu-S1760363AbXLMGnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760363AbXLMGnu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 01:43:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758654AbXLMGhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 01:37:40 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:56395 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758643AbXLMGhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 01:37:36 -0500
Date: Wed, 12 Dec 2007 22:34:50 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, bunk@kernel.org,
       davem@davemloft.net
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Herbert Xu <herbert@gondor.apana.org.au>
Subject: [patch 18/36] PFKEY: Sending an SADB_GET responds with an SADB_GET
Message-ID: <20071213063450.GS25301@kroah.com>
References: <20071213062511.265908583@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="pfkey-sending-an-sadb_get-responds-with-an-sadb_get.patch"
In-Reply-To: <20071213063308.GA25301@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Charles Hardin <chardin@2wire.com>

[PFKEY]: Sending an SADB_GET responds with an SADB_GET

[ Upstream commit: 435000bebd94aae3a7a50078d142d11683d3b193 ]

Kernel needs to respond to an SADB_GET with the same message type to
conform to the RFC 2367 Section 3.1.5

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/key/af_key.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -1543,7 +1543,7 @@ static int pfkey_get(struct sock *sk, st
 
 	out_hdr = (struct sadb_msg *) out_skb->data;
 	out_hdr->sadb_msg_version = hdr->sadb_msg_version;
-	out_hdr->sadb_msg_type = SADB_DUMP;
+	out_hdr->sadb_msg_type = SADB_GET;
 	out_hdr->sadb_msg_satype = pfkey_proto2satype(proto);
 	out_hdr->sadb_msg_errno = 0;
 	out_hdr->sadb_msg_reserved = 0;

-- 
