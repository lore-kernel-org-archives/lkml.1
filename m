Return-Path: <linux-kernel-owner+w=401wt.eu-S1761004AbXIUOvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761004AbXIUOvA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 10:51:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760095AbXIUOtY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 10:49:24 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51234 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758877AbXIUOtW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 10:49:22 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 17/22] AFS: Add TestSetPageError()
To: viro@ftp.linux.org.uk, hch@infradead.org, Trond.Myklebust@netapp.com,
       sds@tycho.nsa.gov, casey@schaufler-ca.com
Cc: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, dhowells@redhat.com
Date: Fri, 21 Sep 2007 15:48:30 +0100
Message-ID: <20070921144830.8323.66572.stgit@warthog.procyon.org.uk>
In-Reply-To: <20070921144703.8323.50492.stgit@warthog.procyon.org.uk>
References: <20070921144703.8323.50492.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add a TestSetPageError() macro to the suite of page flag manipulators.  This
can be used by AFS to prevent over-excision of rejected writes from the page
cache.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/linux/page-flags.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index eaf9854..b59506b 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -130,6 +130,7 @@
 #define PageError(page)		test_bit(PG_error, &(page)->flags)
 #define SetPageError(page)	set_bit(PG_error, &(page)->flags)
 #define ClearPageError(page)	clear_bit(PG_error, &(page)->flags)
+#define TestSetPageError(page)	test_and_set_bit(PG_error, &(page)->flags)
 
 #define PageReferenced(page)	test_bit(PG_referenced, &(page)->flags)
 #define SetPageReferenced(page)	set_bit(PG_referenced, &(page)->flags)

