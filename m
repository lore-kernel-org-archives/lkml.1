Return-Path: <linux-kernel-owner+w=401wt.eu-S1756372AbZBPXvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756372AbZBPXvi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 18:51:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753012AbZBPXq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 18:46:28 -0500
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:50807
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753534AbZBPXqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 18:46:20 -0500
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yinghai@kernel.org>, Ian Campbell <Ian.Campbell@citrix.com>,
       Mark McLoughlin <markmc@redhat.com>
Subject: [PATCH 16/19] xen mtrr: Kill some unneccessary includes
Date: Mon, 16 Feb 2009 15:46:10 -0800
Message-Id: <0cd342b898fbbc8ec6a02591a7848dc29140c6ed.1234826723.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <4215664baba2d7e72862150a9d0e8aa77241668d.1234826723.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <cover.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <cover.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <edde7fdd064390d321bdafcfb993b28b4d2588b1.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <9fbd402b72d6c494f453ff86e071ac1b2658ece9.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <f47f399029ba9035a14ae381b6ae504a5c5bd445.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <f1402ed2345e1d654faa823afefa53fc4745e368.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <f0d2b3f946de1b3398c278c7a33069f670b78268.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <83b1377d81029933b769798dbe1ca134f6d365ae.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <630b678d3259163fc237f673b6f2a4a5fa76ac25.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <8349825a016bec5b8712940ad6f8c3f18f8003fb.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <f156acbfffc23cccd71b71d36e6668c6c246f3b4.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <f156acbfffc23cccd71b71d36e6668c6c246f3b4.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <e59d440a548af3d4e4bb483c73e24614a5b3af63.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <2fe9663efa1686898ebf9d28e911daac3185b6b7.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <0b79be113b42a033f3b3ca4d4f3ca4035c8a7bf5.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <b4adea5f3e4c3ebba175f2344d138f85aa48dd57.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <0dda0d4d9cf8e5aebba5d370def8c268e93e9800.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <4215664baba2d7e72862150a9d0e8aa77241668d.1234826723.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1234826723.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1234826723.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark McLoughlin <markmc@redhat.com>

Signed-off-by: Mark McLoughlin <markmc@redhat.com>
---
 arch/x86/kernel/cpu/mtrr/mtrr.h |    2 ++
 arch/x86/kernel/cpu/mtrr/xen.c  |    8 +-------
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/mtrr.h b/arch/x86/kernel/cpu/mtrr/mtrr.h
index eb23ca2..6142d6e 100644
--- a/arch/x86/kernel/cpu/mtrr/mtrr.h
+++ b/arch/x86/kernel/cpu/mtrr/mtrr.h
@@ -5,6 +5,8 @@
 #include <linux/types.h>
 #include <linux/stddef.h>
 
+#include <asm/mtrr.h>
+
 #define MTRRcap_MSR     0x0fe
 #define MTRRdefType_MSR 0x2ff
 
diff --git a/arch/x86/kernel/cpu/mtrr/xen.c b/arch/x86/kernel/cpu/mtrr/xen.c
index e03532c..7a25f88 100644
--- a/arch/x86/kernel/cpu/mtrr/xen.c
+++ b/arch/x86/kernel/cpu/mtrr/xen.c
@@ -1,12 +1,6 @@
 #include <linux/init.h>
-#include <linux/proc_fs.h>
-#include <linux/ctype.h>
-#include <linux/module.h>
-#include <linux/seq_file.h>
-#include <asm/uaccess.h>
-#include <linux/mutex.h>
-
-#include <asm/mtrr.h>
+#include <linux/mm.h>
+
 #include "mtrr.h"
 
 #include <xen/interface/platform.h>
-- 
1.6.0.6

