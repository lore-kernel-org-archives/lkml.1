Return-Path: <linux-kernel-owner+w=401wt.eu-S1757392AbYHRSz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757392AbYHRSz7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 14:55:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756344AbYHRSyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 14:54:39 -0400
Received: from ns2.suse.de ([195.135.220.15]:35726 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754838AbYHRSyh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 14:54:37 -0400
Date: Mon, 18 Aug 2008 11:43:21 -0700
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
       alan@lxorguk.ukuu.org.uk, Eugene Teo <eugeneteo@kernel.sg>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Gerrit Renker <gerrit@erg.abdn.ac.uk>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 24/60] dccp: change L/R must have at least one byte in the
	dccpsf_val field
Message-ID: <20080818184321.GY29394@suse.de>
References: <20080818183230.966310219@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="dccp-change-l-r-must-have-at-least-one-byte-in-the-dccpsf_val-field.patch"
In-Reply-To: <20080818184035.GA29394@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Arnaldo Carvalho de Melo <acme@redhat.com>

commit 3e8a0a559c66ee9e7468195691a56fefc3589740 upstream

Thanks to Eugene Teo for reporting this problem.

Signed-off-by: Eugene Teo <eugeneteo@kernel.sg>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Gerrit Renker <gerrit@erg.abdn.ac.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/dccp/proto.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/net/dccp/proto.c
+++ b/net/dccp/proto.c
@@ -476,6 +476,11 @@ static int dccp_setsockopt_change(struct
 
 	if (copy_from_user(&opt, optval, sizeof(opt)))
 		return -EFAULT;
+	/*
+	 * rfc4340: 6.1. Change Options
+	 */
+	if (opt.dccpsf_len < 1)
+		return -EINVAL;
 
 	val = kmalloc(opt.dccpsf_len, GFP_KERNEL);
 	if (!val)

-- 
