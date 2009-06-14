Return-Path: <linux-kernel-owner+w=401wt.eu-S1762522AbZFNPxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762522AbZFNPxV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 11:53:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762360AbZFNPxD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 11:53:03 -0400
Received: from mail-px0-f187.google.com ([209.85.216.187]:33518 "EHLO
	mail-px0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762466AbZFNPxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 11:53:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=gv3vZrAHIK/2D7bTq5+aEsabehdfEQ27uVFMGTqkrotGPLcRhvCYhm8qxaEjICWiRX
         vCun++6F7SDveWEJO0cU73NdWLUsTMC5kq6I/3gs95tbpP/gjchp2WR/pdBxMqR3I12t
         ec0k375q/VYQ8VdLAQhAlIiTNPTJnJauzlq0E=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Cc: Wang Liming <liming.wang@windriver.com>, Wu Zhangjin <wuzj@lemote.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Ralf Baechle <ralf@linux-mips.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Nicholas Mc Guire <der.herr@hofr.at>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH v3] filter local function prefixed by $L
Date: Sun, 14 Jun 2009 23:52:54 +0800
Message-Id: <d0983eb71d7517d0e536352f3288e995abbb0e07.1244994151.git.wuzj@lemote.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <cover.1244994151.git.wuzj@lemote.com>
References: <cover.1244994151.git.wuzj@lemote.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Zhangjin <wuzj@lemote.com>

this patch fixed the warning as following:

mipsel-linux-gnu-objcopy: 'fs/proc/.tmp_gl_devices.o': No such file
mipsel-linux-gnu-ld: fs/proc/.tmp_gl_devices.o: No such file: No such
file or directory
rm: cannot remove `fs/proc/.tmp_gl_devices.o': No such file or directory
rm: cannot remove `fs/proc/.tmp_mx_devices.o': No such file or directory

the real reason of above warning is that the $Lxx local functions will
be treated as global symbols, so, should be filtered.

Signed-off-by: Wu Zhangjin <wuzj@lemote.com>
---
 scripts/recordmcount.pl |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index 533d3bf..542cb04 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -343,6 +343,10 @@ sub update_funcs
 	if (!$use_locals) {
 	    return;
 	}
+	# filter $LXXX tags
+	if ("$ref_func" =~ m/\$L/) {
+		return;
+	}
 	$convert{$ref_func} = 1;
     }
 
-- 
1.6.0.4

