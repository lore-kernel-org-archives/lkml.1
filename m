Return-Path: <linux-kernel-owner+w=401wt.eu-S1757372AbZKEQ3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757372AbZKEQ3R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 11:29:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756679AbZKEQ3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 11:29:16 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:63228 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755153AbZKEQ3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 11:29:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=etiAWRsjPVyZmNBKWv3LYBjLqKllw9gEKGB5YD8ITq9qLjDjnU7ky2Hz4e1bQZyrC4
         p5+aldPeOCbil6orRF3nFtTYM0c4/QYxotDA74pvruPU7Uo6XE/DKMYnZ7zpq1fmq/7q
         mzraJ2UQPaMG4BqcaIseGTLqlCQwcolXUdR3k=
Message-ID: <4AF3000C.8080607@gmail.com>
Date: Thu, 05 Nov 2009 17:40:44 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] sparc,sparc64: replace parentheses in pmul()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

`>>' has a higher precedence than `?' so src2 evaluated to
either 16 or 0 dependent on the bits set in rs2.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 arch/sparc/kernel/visemul.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

I am not 100% sure that the code was incorrect, however, if it
was intended I think it is a very strange way to write it.

Roel

diff --git a/arch/sparc/kernel/visemul.c b/arch/sparc/kernel/visemul.c
index b956fd7..d231cbd 100644
--- a/arch/sparc/kernel/visemul.c
+++ b/arch/sparc/kernel/visemul.c
@@ -617,7 +617,7 @@ static void pmul(struct pt_regs *regs, unsigned int insn, unsigned int opf)
 		rs2 = fps_regval(f, RS2(insn));
 
 		rd_val = 0;
-		src2 = (rs2 >> (opf == FMUL8x16AU_OPF) ? 16 : 0);
+		src2 = rs2 >> (opf == FMUL8x16AU_OPF ? 16 : 0);
 		for (byte = 0; byte < 4; byte++) {
 			u16 src1 = (rs1 >> (byte * 8)) & 0x00ff;
 			u32 prod = src1 * src2;
