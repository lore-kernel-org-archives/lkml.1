Return-Path: <linux-kernel-owner+w=401wt.eu-S1753994Ab0AHTC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994Ab0AHTC2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 14:02:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753966Ab0AHTC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 14:02:27 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:26039 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753648Ab0AHTC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 14:02:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=JN5tCuqCPS9ylzEB/6BDe37xYNzObShKBR1CnwEkWTrHE+ORpXQJhhSrB/5si2S3c3
         AJ9ymcwjw1KquisylQwOAte+I6jjHT+Eb4FyeQBb1QT5gYy6/6LHojHMFckjbJx2LWgb
         SrZX1DDQinktE3JlRCL4gVYivV8EWreLgx+zk=
Message-ID: <4B47822E.1080402@gmail.com>
Date: Fri, 08 Jan 2010 20:06:22 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Mike Frysinger <vapier@gentoo.org>,
       uclinux-dist-devel@blackfin.uclinux.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] Blackfin arch: Fix decoding of opcodes 41-47 in decode_instruction()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This condition allowed only decoding of opcode 0x0040

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 arch/blackfin/kernel/traps.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

Found with static code analysis. Correct?

diff --git a/arch/blackfin/kernel/traps.c b/arch/blackfin/kernel/traps.c
index d3cbcd6..870d74b 100644
--- a/arch/blackfin/kernel/traps.c
+++ b/arch/blackfin/kernel/traps.c
@@ -712,7 +712,7 @@ static void decode_instruction(unsigned short *address)
 			verbose_printk("RTE");
 		else if (opcode == 0x0025)
 			verbose_printk("EMUEXCPT");
-		else if (opcode == 0x0040 && opcode <= 0x0047)
+		else if (opcode >= 0x0040 && opcode <= 0x0047)
 			verbose_printk("STI R%i", opcode & 7);
 		else if (opcode >= 0x0050 && opcode <= 0x0057)
 			verbose_printk("JUMP (P%i)", opcode & 7);
