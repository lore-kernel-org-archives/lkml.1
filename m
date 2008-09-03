Return-Path: <linux-kernel-owner+w=401wt.eu-S1757855AbYICRn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757855AbYICRn2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 13:43:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753947AbYICRnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 13:43:09 -0400
Received: from mx2.suse.de ([195.135.220.15]:57375 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755469AbYICRnH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 13:43:07 -0400
Date: Wed, 3 Sep 2008 10:26:26 -0700
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
       alan@lxorguk.ukuu.org.uk, Vlad Yasevich <vladislav.yasevich@hp.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 30/42] sctp: correct bounds check in
	sctp_setsockopt_auth_key
Message-ID: <20080903172626.GE7731@suse.de>
References: <20080903171927.534216229@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0011-sctp-correct-bounds-check-in-sctp_setsockopt_auth_k.patch"
In-Reply-To: <20080903172447.GA7731@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Vlad Yasevich <vladislav.yasevich@hp.com>

[ Upstream commit 328fc47ea0bcc27d9afa69c3ad6e52431cadd76c ]

The bonds check to prevent buffer overlflow was not exactly
right.  It still allowed overflow of up to 8 bytes which is
sizeof(struct sctp_authkey).

Since optlen is already checked against the size of that struct,
we are guaranteed not to cause interger overflow either.

Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/sctp/socket.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3054,7 +3054,7 @@ static int sctp_setsockopt_auth_key(stru
 		goto out;
 	}
 
-	if (authkey->sca_keylength > optlen) {
+	if (authkey->sca_keylength > optlen - sizeof(struct sctp_authkey)) {
 		ret = -EINVAL;
 		goto out;
 	}

-- 
