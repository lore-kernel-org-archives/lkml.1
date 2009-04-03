Return-Path: <linux-kernel-owner+w=401wt.eu-S934408AbZDCPrB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934408AbZDCPrB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 11:47:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933597AbZDCPpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 11:45:55 -0400
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:48192 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933427AbZDCPpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 11:45:53 -0400
Date: Fri, 3 Apr 2009 17:42:01 +0200
From: Bastian Blank <waldi@debian.org>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH 4/5] libgcc: Disable usage of special do_div version
Message-ID: <20090403154201.GD7200@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <waldi@debian.org>,
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
References: <20090403153941.GA7045@wavehammer.waldi.eu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090403153941.GA7045@wavehammer.waldi.eu.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gcc takes care of large div and mod operations and redirects them into
the libgcc.  There is no need to do it by hand in this case.

Signed-off-by: Bastian Blank <waldi@debian.org>
---
 include/asm-generic/div64.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-generic/div64.h b/include/asm-generic/div64.h
index 8f4e319..45f618d 100644
--- a/include/asm-generic/div64.h
+++ b/include/asm-generic/div64.h
@@ -20,7 +20,7 @@
 #include <linux/types.h>
 #include <linux/compiler.h>
 
-#if BITS_PER_LONG == 64
+#if BITS_PER_LONG == 64 || CONFIG_LIBGCC_SUPPORT
 
 # define do_div(n,base) ({					\
 	uint32_t __base = (base);				\
-- 
1.6.2.1
