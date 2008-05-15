Return-Path: <linux-kernel-owner+w=401wt.eu-S1758159AbYEODoG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758159AbYEODoG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 23:44:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751549AbYEODnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 23:43:52 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:36973 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756661AbYEODnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 23:43:41 -0400
Date: Wed, 14 May 2008 20:43:14 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 3/3] Example use of WARN()
Message-ID: <20080514204314.01a9caa6@infradead.org>
In-Reply-To: <20080513213606.1a295609.akpm@linux-foundation.org>
References: <20080506232017.247001e0@infradead.org>
	<20080506232113.7f066c26@infradead.org>
	<20080506232156.159ed493@infradead.org>
	<20080513213606.1a295609.akpm@linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 May 2008 21:36:06 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 6 May 2008 23:21:56 -0700 Arjan van de Ven
> <arjan@infradead.org> wrote:
> 
> > From: Arjan van de Ven <arjan@linux.intel.com>
> > Subject: Example use of WARN()
> > 
> > now that WARN() exists, we can fold some of the printk's into it
> 
> Wanna take a look at mips allnoconfig, please?
> 

this should fix this


From: Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH] Fix WARN() for the !CONFIG_BUG case

For the CONFIG_BUG=n case we need to provide a stub WARN() macro;
do this in the same style as WARN_ON() is done.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 include/asm-generic/bug.h |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
index dcefa5e..1d2b51f 100644
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -79,6 +79,14 @@ extern void warn_slowpath(const char *file, const int line, const char *fmt, ...
 	unlikely(__ret_warn_on);					\
 })
 #endif
+
+#ifndef WARN
+#define WARN(condition, format...) ({					\
+	int __ret_warn_on = !!(condition);				\
+	unlikely(__ret_warn_on);					\
+})
+#endif
+
 #endif
 
 #define WARN_ON_ONCE(condition)	({				\
-- 
1.5.4.5

