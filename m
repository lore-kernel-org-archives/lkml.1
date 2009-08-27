Return-Path: <linux-kernel-owner+w=401wt.eu-S932298AbZH0CdE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932298AbZH0CdE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 22:33:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932228AbZH0CdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 22:33:00 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:54351 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932260AbZH0Cc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 22:32:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=jS5gQXP9ur0M6+3doJCc8ujZW69mzo/qYSuBkQuzOJR15OVaPNTFPpmeC3jyO0fFye
         tsCOt0BafzxqNVXSNjQaGy56RhtKwmYOFIhLfkBjjwQ5PXCSnyY1fKXw+W0AC63ClZk8
         wHWar8bXWsHlH4aunm0qiEcuqhmGj5+MxnW5g=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Jim Keniston <jkenisto@us.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Avi Kivity <avi@redhat.com>, Andi Kleen <ak@linux.intel.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Jason Baron <jbaron@redhat.com>, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       =?utf-8?q?Przemys=C5=82aw=20Pawe=C5=82czyk?= 
	<przemyslaw@pawelczyk.it>,
       Roland McGrath <roland@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 15/18] x86: Check awk features before generating inat-tables.c
Date: Thu, 27 Aug 2009 04:32:14 +0200
Message-Id: <1251340337-5640-16-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1251340337-5640-1-git-send-email-fweisbec@gmail.com>
References: <1251340337-5640-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <mhiramat@redhat.com>

Check some awk mandatory features to generate inat-tables.c
that old mawk doesn't support.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jason Baron <jbaron@redhat.com>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Przemysław Pawełczyk <przemyslaw@pawelczyk.it>
Cc: Roland McGrath <roland@redhat.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>
LKML-Reference: <20090821194316.12478.57394.stgit@localhost.localdomain>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/tools/gen-insn-attr-x86.awk |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/arch/x86/tools/gen-insn-attr-x86.awk b/arch/x86/tools/gen-insn-attr-x86.awk
index 93b62c9..19ba096 100644
--- a/arch/x86/tools/gen-insn-attr-x86.awk
+++ b/arch/x86/tools/gen-insn-attr-x86.awk
@@ -4,7 +4,25 @@
 #
 # Usage: awk -f gen-insn-attr-x86.awk x86-opcode-map.txt > inat-tables.c
 
+# Awk implementation sanity check
+function check_awk_implement() {
+	if (!match("abc", "[[:lower:]]+"))
+		return "Your awk doesn't support charactor-class."
+	if (sprintf("%x", 0) != "0")
+		return "Your awk has a printf-format problem."
+	return ""
+}
+
 BEGIN {
+	# Implementation error checking
+	awkchecked = check_awk_implement()
+	if (awkchecked != "") {
+		print "Error: " awkchecked > "/dev/stderr"
+		print "Please try to use gawk." > "/dev/stderr"
+		exit 1
+	}
+
+	# Setup generating tables
 	print "/* x86 opcode map generated from x86-opcode-map.txt */"
 	print "/* Do not change this code. */"
 	ggid = 1
@@ -293,6 +311,8 @@ function convert_operands(opnd,       i,imm,mod)
 }
 
 END {
+	if (awkchecked != "")
+		exit 1
 	# print escape opcode map's array
 	print "/* Escape opcode map array */"
 	print "const insn_attr_t const *inat_escape_tables[INAT_ESC_MAX + 1]" \
-- 
1.6.2.3

