Return-Path: <linux-kernel-owner+w=401wt.eu-S1755572AbXEJDvJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572AbXEJDvJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 23:51:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754463AbXEJDu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 23:50:57 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:44536 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754410AbXEJDu4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 23:50:56 -0400
Date: Thu, 10 May 2007 12:50:28 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Roland Dreier <rolandd@cisco.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] net: trivial MLX4_DEBUG dependency fix.
Message-ID: <20070510035028.GA26453@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Roland Dreier <rolandd@cisco.com>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

First SLUB_DEBUG, and now this..

CONFIG_MLX4_DEBUG works out to a def_bool y for those that
have CONFIG_EMBEDDED set. Make it depend on MLX4_CORE..

I'll let someone else wonder why debugging output is default enabled,
this seems to be a worrying trend as of late.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

--

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index fa489b1..b3f4ffa 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -2500,6 +2500,7 @@ config MLX4_CORE
 
 config MLX4_DEBUG
 	bool "Verbose debugging output" if (MLX4_CORE && EMBEDDED)
+	depends on MLX4_CORE
 	default y
 	---help---
 	  This option causes debugging code to be compiled into the
