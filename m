Return-Path: <linux-kernel-owner+w=401wt.eu-S1755447AbZKHVlK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447AbZKHVlK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 16:41:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754946AbZKHVlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 16:41:09 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:34331 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754059AbZKHVlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 16:41:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=kuGBXUqHAuLMm0pexxQdioFJZ/aCRLcowdM3AflUbHaX8cJtLw1K60vYwkYihoTJlf
         N6eV4c4Lh1y+Pcizi9DOo3aPbJ16Gagq6JMeUUlR2oXVpSkpeWpI80ouxvVnlwAv8qID
         U6AP5AEhGjv/Bgs59ZCboKtZuZxPnmcgTMm9A=
Message-ID: <4AF7397D.2050202@gmail.com>
Date: Sun, 08 Nov 2009 22:34:53 +0100
From: Carmelo Amoroso <carmelo73@gmail.com>
Reply-To: carmelo73@gmail.com
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: [PATCH] kbuild: Allow to use depmod from a non default install
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allow to specify the directory where to find the
depmod tool other than being forced to use the module-init-tools
installed on the host. The reason for this is explained below.
When doing cross-compilation, it not guaranteed that the
module-init-tools installed on the host (and used during kernel build)
are exactly the same and compatible with those used on the target at runtime.
For example, recent changes in how depmod writes modules.dep using
root-less path, make older modprobe unusable on the target.
User in ths case could install in a different path the module-init-tools
compatible with the version used on the target and specify the path on the
command line.

Signed-off-by: Carmelo Amoroso <carmelo.amoroso@st.com>
---
 Makefile |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index b4c04f7..f5286c4 100644
--- a/Makefile
+++ b/Makefile
@@ -316,7 +316,8 @@ OBJDUMP             = $(CROSS_COMPILE)objdump
 AWK            = awk
 GENKSYMS       = scripts/genksyms/genksyms
 INSTALLKERNEL  := installkernel
-DEPMOD         = /sbin/depmod
+DEPMOD_PATH    ?= /sbin
+DEPMOD         = $(DEPMOD_PATH)/depmod
 KALLSYMS       = scripts/kallsyms
 PERL           = perl
 CHECK          = sparse
-- 
1.6.3.3
