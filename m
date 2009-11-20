Return-Path: <linux-kernel-owner+w=401wt.eu-S1756071AbZKTVyz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071AbZKTVyz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 16:54:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754917AbZKTVyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 16:54:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3698 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755863AbZKTVyx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 16:54:53 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 3/3] FS-Cache: Provide nop fscache_stat_d() if
	CONFIG_FSCACHE_STATS=n
To: wilhelm.meier@fh-kl.de, linux-cachefs@redhat.com, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org
Cc: dhowells@redhat.com, steved@redhat.com
Date: Fri, 20 Nov 2009 21:54:52 +0000
Message-ID: <20091120215452.15448.14310.stgit@warthog.procyon.org.uk>
In-Reply-To: <20091120215437.15448.26909.stgit@warthog.procyon.org.uk>
References: <20091120215437.15448.26909.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide nop fscache_stat_d() macro if CONFIG_FSCACHE_STATS=n lest errors like
the following occur:

	fs/fscache/cache.c: In function 'fscache_withdraw_cache':
	fs/fscache/cache.c:386: error: implicit declaration of function 'fscache_stat_d'
	fs/fscache/cache.c:386: error: 'fscache_n_cop_sync_cache' undeclared (first use in this function)
	fs/fscache/cache.c:386: error: (Each undeclared identifier is reported only once
	fs/fscache/cache.c:386: error: for each function it appears in.)
	fs/fscache/cache.c:392: error: 'fscache_n_cop_dissociate_pages' undeclared (first use in this function)

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/fscache/internal.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/fscache/internal.h b/fs/fscache/internal.h
index 0ca2566..edd7434 100644
--- a/fs/fscache/internal.h
+++ b/fs/fscache/internal.h
@@ -259,6 +259,7 @@ extern const struct file_operations fscache_stats_fops;
 
 #define __fscache_stat(stat) (NULL)
 #define fscache_stat(stat) do {} while (0)
+#define fscache_stat_d(stat) do {} while (0)
 #endif
 
 /*

