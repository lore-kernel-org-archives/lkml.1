Return-Path: <linux-kernel-owner+w=401wt.eu-S1764778AbZLQQTX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764778AbZLQQTX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 11:19:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762851AbZLQQTV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 11:19:21 -0500
Received: from hera.kernel.org ([140.211.167.34]:54903 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761484AbZLQQTU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 11:19:20 -0500
Date: Thu, 17 Dec 2009 16:18:50 GMT
From: tip-bot for Roland Dreier <rdreier@cisco.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rdreier@cisco.com, rolandd@cisco.com, tglx@linutronix.de,
       mhiramat@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rdreier@cisco.com, tglx@linutronix.de, rolandd@cisco.com,
       mhiramat@redhat.com
In-Reply-To: <adabphy750b.fsf@roland-alpha.cisco.com>
References: <adabphy750b.fsf@roland-alpha.cisco.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Don't use POSIX character classes in gen-insn-attr-x86.awk
Message-ID: <tip-4beb3d6d144c41525541cce2b611858b2645c725@git.kernel.org>
Git-Commit-ID: 4beb3d6d144c41525541cce2b611858b2645c725
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4beb3d6d144c41525541cce2b611858b2645c725
Gitweb:     http://git.kernel.org/tip/4beb3d6d144c41525541cce2b611858b2645c725
Author:     Roland Dreier <rdreier@cisco.com>
AuthorDate: Wed, 16 Dec 2009 17:39:48 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 17 Dec 2009 07:03:21 -0800

x86: Don't use POSIX character classes in gen-insn-attr-x86.awk

Not all awk implementations (including the default awk in Ubuntu 9.10)
support POSIX character classes.  Since x86-opcode-map.txt is plain
ASCII, we can just use explicit ranges for lower case, alphabetic, and
alphanumeric characters instead.

Signed-off-by: Roland Dreier <rolandd@cisco.com>
Acked-by: Masami Hiramatsu <mhiramat@redhat.com>
LKML-Reference: <adabphy750b.fsf@roland-alpha.cisco.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/tools/gen-insn-attr-x86.awk |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/x86/tools/gen-insn-attr-x86.awk b/arch/x86/tools/gen-insn-attr-x86.awk
index 7a68506..eaf11f5 100644
--- a/arch/x86/tools/gen-insn-attr-x86.awk
+++ b/arch/x86/tools/gen-insn-attr-x86.awk
@@ -6,8 +6,6 @@
 
 # Awk implementation sanity check
 function check_awk_implement() {
-	if (!match("abc", "[[:lower:]]+"))
-		return "Your awk doesn't support charactor-class."
 	if (sprintf("%x", 0) != "0")
 		return "Your awk has a printf-format problem."
 	return ""
@@ -44,12 +42,12 @@ BEGIN {
 	delete gtable
 	delete atable
 
-	opnd_expr = "^[[:alpha:]/]"
+	opnd_expr = "^[A-Za-z/]"
 	ext_expr = "^\\("
 	sep_expr = "^\\|$"
-	group_expr = "^Grp[[:alnum:]]+"
+	group_expr = "^Grp[0-9A-Za-z]+"
 
-	imm_expr = "^[IJAO][[:lower:]]"
+	imm_expr = "^[IJAO][a-z]"
 	imm_flag["Ib"] = "INAT_MAKE_IMM(INAT_IMM_BYTE)"
 	imm_flag["Jb"] = "INAT_MAKE_IMM(INAT_IMM_BYTE)"
 	imm_flag["Iw"] = "INAT_MAKE_IMM(INAT_IMM_WORD)"
@@ -62,7 +60,7 @@ BEGIN {
 	imm_flag["Ob"] = "INAT_MOFFSET"
 	imm_flag["Ov"] = "INAT_MOFFSET"
 
-	modrm_expr = "^([CDEGMNPQRSUVW/][[:lower:]]+|NTA|T[012])"
+	modrm_expr = "^([CDEGMNPQRSUVW/][a-z]+|NTA|T[012])"
 	force64_expr = "\\([df]64\\)"
 	rex_expr = "^REX(\\.[XRWB]+)*"
 	fpu_expr = "^ESC" # TODO
