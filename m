Return-Path: <linux-kernel-owner+w=401wt.eu-S1758592AbZLGANw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758592AbZLGANw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:13:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932836AbZLGANr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:13:47 -0500
Received: from kroah.org ([198.145.64.141]:34592 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758543AbZLGANe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:13:34 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:54 2009
Message-Id: <20091207000654.364893397@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:00:54 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Roel Kluin <roel.kluin@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [078/119] sparc64: replace parentheses in pmul()
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=sparc64-replace-parentheses-in-pmul.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Roel Kluin <roel.kluin@gmail.com>

[ Upstream commit 88b938e63e68fd35e603421f722be0f35dde1016 ]

`>>' has a higher precedence than `?' so src2 evaluated to
either 16 or 0 dependent on the bits set in rs2.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/sparc/kernel/visemul.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/sparc/kernel/visemul.c
+++ b/arch/sparc/kernel/visemul.c
@@ -617,7 +617,7 @@ static void pmul(struct pt_regs *regs, u
 		rs2 = fps_regval(f, RS2(insn));
 
 		rd_val = 0;
-		src2 = (rs2 >> (opf == FMUL8x16AU_OPF) ? 16 : 0);
+		src2 = rs2 >> (opf == FMUL8x16AU_OPF ? 16 : 0);
 		for (byte = 0; byte < 4; byte++) {
 			u16 src1 = (rs1 >> (byte * 8)) & 0x00ff;
 			u32 prod = src1 * src2;


