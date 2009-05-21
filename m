Return-Path: <linux-kernel-owner+w=401wt.eu-S1755212AbZEUNrM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212AbZEUNrM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 09:47:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753467AbZEUNq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 09:46:59 -0400
Received: from ocean.emcraft.com ([213.221.7.182]:33893 "EHLO
	ocean.emcraft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368AbZEUNq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 09:46:58 -0400
Message-ID: <4A155B53.4040905@emcraft.com>
Date: Thu, 21 May 2009 17:46:59 +0400
From: Sergei Poselenov <sposelenov@emcraft.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Re: 'make headers_check' failed to install headers to arbitrary
 location
References: <4A0C3BFB.1010305@emcraft.com>
In-Reply-To: <4A0C3BFB.1010305@emcraft.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

A time ago I noted a 'make headers_check' failure, see the
original message here:
http://lkml.org/lkml/2009/5/14/248

The proposed patch fixes this error, please review.
Tested on 2.6.30-rc5.

Signed-off-by: Sergei Poselenov <sposelenov@emcraft.com>
---
  scripts/Makefile.headersinst |    5 +++--
  1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/scripts/Makefile.headersinst b/scripts/Makefile.headersinst
index 095cfc8..2bd5fe4 100644
--- a/scripts/Makefile.headersinst
+++ b/scripts/Makefile.headersinst
@@ -54,8 +54,9 @@ quiet_cmd_remove = REMOVE  $(unwanted)
        cmd_remove = rm -f $(unwanted-file)

  quiet_cmd_check = CHECK   $(printdir) ($(words $(all-files)) files)
-      cmd_check = $(PERL) $< $(INSTALL_HDR_PATH)/include $(SRCARCH) \
-                  $(addprefix $(install)/, $(all-files));           \
+      cmd_check = (for f in $(all-files); do                        \
+                  $(PERL) $< $(INSTALL_HDR_PATH)/include $(SRCARCH) \
+                  $(install)/$${f}; done);                          \
  	          touch $@

  PHONY += __headersinst __headerscheck
-- 
1.6.0.6
