Return-Path: <linux-kernel-owner+w=401wt.eu-S1755520AbZKHVoB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520AbZKHVoB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 16:44:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755266AbZKHVoB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 16:44:01 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:49195 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754946AbZKHVoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 16:44:00 -0500
X-Greylist: delayed 550 seconds by postgrey-1.27 at vger.kernel.org; Sun, 08 Nov 2009 16:44:00 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=UWX72pXD/v+Yc94cqXivZtxFSsOv65niDVFgqM5UyZKMSDkt7my/mZY3BYb22ofDse
         liecP/KrkwojFU9qYmTzaWARoQW3svUSb/lT3B4t5JNhORnRqidukxgNJX8PdiGtPDSA
         SmRSF8F48+BLcK2xRbZlum9NydtVpKUuEVOFQ=
Message-ID: <4AF73BA4.3000501@gmail.com>
Date: Sun, 08 Nov 2009 22:44:04 +0100
From: Carmelo Amoroso <carmelo73@gmail.com>
Reply-To: Carmelo Amoroso <carmelo73@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Carmelo AMOROSO <carmelo.amoroso@st.com>
Subject: [PATCH] modules: Allow to use depmod from a non default install
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
-- 1.6.3.3
