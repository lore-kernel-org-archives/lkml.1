Return-Path: <linux-kernel-owner+w=401wt.eu-S1761486AbYERAy6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761486AbYERAy6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 20:54:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754949AbYERAyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 20:54:20 -0400
Received: from smtp110.sbc.mail.mud.yahoo.com ([68.142.198.209]:41568 "HELO
	smtp110.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752249AbYERAyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 20:54:19 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=oDhUs7/Wm4BoWggDgao1Z6lcaFNQSaU0Dn87iUiixu/Ll45oL+FVKztWYasLWRzZpe907MEd6Ld4FwcSNhdiBJaiZQBNNmHCJmVFhBd7bHTA8dgyP8ZINBn/4murMa35+ea4yN+LO0tjgwriMHprM+K0lfP6M2PJEZAJIqPCr0c=  ;
X-YMail-OSG: BiW6.zMVM1lZBlVNRKib.W6Z1C7Dth__sywIMmmQC9tVFg2ql1sU0vDAGPvGNqsMWW7WloXULupKT2yNFMqHswUx9dJ8ObKcjXr_mUEChA--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 2.6.26-rc2-git] gpio: mcp23s08 debug fix
Date: Sat, 17 May 2008 17:41:32 -0700
User-Agent: KMail/1.9.6
Cc: lkml <linux-kernel@vger.kernel.org>, Roel Kluin <12o3l@tiscali.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805171741.32404.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roel Kluin <12o3l@tiscali.nl>

The return value of mcp23s08_read_regs() can only be evaluated when signed

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>

--- a/drivers/gpio/mcp23s08.c
+++ b/drivers/gpio/mcp23s08.c
@@ -168,7 +168,7 @@ static void mcp23s08_dbg_show(struct seq_file *s, struct gpio_chip *chip)
 {
 	struct mcp23s08	*mcp;
 	char		bank;
-	unsigned	t;
+	int		t;
 	unsigned	mask;
 
 	mcp = container_of(chip, struct mcp23s08, chip);
