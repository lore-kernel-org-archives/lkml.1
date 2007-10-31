Return-Path: <linux-kernel-owner+w=401wt.eu-S1759974AbXJaV3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759974AbXJaV3t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 17:29:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754707AbXJaV3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 17:29:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42894 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753872AbXJaV3j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 17:29:39 -0400
Date: Wed, 31 Oct 2007 17:29:32 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: per.liden@ericsson.com, jon.maloy@ericsson.com,
       allan.stephens@windriver.com
Subject: [PATCH] Fix make headers_check for tipc
Message-ID: <20071031212932.GA4933@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, per.liden@ericsson.com,
	jon.maloy@ericsson.com, allan.stephens@windriver.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

make headers_check currently fails in mainline with..

include/linux/tipc_config.h requires linux/string.h, which does not exist in exported headers

There's no reason to even include this in this header as far as I can tell.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/include/linux/tipc_config.h b/include/linux/tipc_config.h
index b0c916d..83532ee 100644
--- a/include/linux/tipc_config.h
+++ b/include/linux/tipc_config.h
@@ -38,7 +38,6 @@
 #define _LINUX_TIPC_CONFIG_H_
 
 #include <linux/types.h>
-#include <linux/string.h>
 #include <asm/byteorder.h>
 
 /*

-- 
http://www.codemonkey.org.uk
