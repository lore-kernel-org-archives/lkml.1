Return-Path: <linux-kernel-owner+w=401wt.eu-S1752201AbZJYPFY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201AbZJYPFY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 11:05:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752090AbZJYPFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 11:05:23 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:52743 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbZJYPFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 11:05:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=NeJJbhuaHtm2hF4frNdyfw0uIodskwbNo8lYEH0/0pagc3w8JOyIrad2rpWalHySEU
         w0JgsGhqe4ReCEMbOaEwP7z5VzpLXGlMGb1ObAl0i1U/yP2PSQc8qRh1rNe6aNKoa7MJ
         eOCfYLdJlSn0WJaTOhkMr+nQiNQsSWHCvfQ4I=
Message-ID: <4AE46934.2000203@tuffmail.co.uk>
Date: Sun, 25 Oct 2009 15:05:24 +0000
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: linux-kbuild@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] kallsyms: clean up alignment (potentially save a few bytes
 on ARM)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On ARM, .align N means "align to 2^N bytes".  What we actually want is
"align to N bytes".

Let's use the .balign directive of gnu as, which is explicitly defined
to address this issue.

Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
---
 scripts/kallsyms.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
index 86c3896..55de9e8 100644
--- a/scripts/kallsyms.c
+++ b/scripts/kallsyms.c
@@ -297,10 +297,10 @@ static void write_src(void)
 	printf("#include <asm/types.h>\n");
 	printf("#if BITS_PER_LONG == 64\n");
 	printf("#define PTR .quad\n");
-	printf("#define ALGN .align 8\n");
+	printf("#define ALGN .balign 8\n");
 	printf("#else\n");
 	printf("#define PTR .long\n");
-	printf("#define ALGN .align 4\n");
+	printf("#define ALGN .balign 4\n");
 	printf("#endif\n");
 
 	printf("\t.section .rodata, \"a\"\n");

