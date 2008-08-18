Return-Path: <linux-kernel-owner+w=401wt.eu-S1762622AbYHRTEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762622AbYHRTEf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 15:04:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759750AbYHRTCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 15:02:13 -0400
Received: from cantor.suse.de ([195.135.220.2]:43892 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756436AbYHRTCL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 15:02:11 -0400
Date: Mon, 18 Aug 2008 11:45:07 -0700
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
       alan@lxorguk.ukuu.org.uk, Steve French <sfrench@us.ibm.com>
Subject: [patch 43/60] CIFS: Fix compiler warning on 64-bit
Message-ID: <20080818184507.GR29394@suse.de>
References: <20080818183230.966310219@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="cifs-fix-compiler-warning-on-64-bit.patch"
In-Reply-To: <20080818184035.GA29394@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jan Beulich <jbeulich@novell.com>

commit 04e1e0cccade330ab3715ce59234f7e3b087e246 upstream.

Signed-off-by: Steve French <sfrench@us.ibm.com>
Cc: Eugene Teo <eteo@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/cifs/asn1.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/cifs/asn1.c
+++ b/fs/cifs/asn1.c
@@ -400,7 +400,7 @@ asn1_oid_decode(struct asn1_ctx *ctx,
 	size = eoc - ctx->pointer + 1;
 
 	/* first subid actually encodes first two subids */
-	if (size < 2 || size > ULONG_MAX/sizeof(unsigned long))
+	if (size < 2 || size > UINT_MAX/sizeof(unsigned long))
 		return 0;
 
 	*oid = kmalloc(size * sizeof(unsigned long), GFP_ATOMIC);

-- 
