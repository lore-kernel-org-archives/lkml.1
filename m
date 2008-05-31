Return-Path: <linux-kernel-owner+w=401wt.eu-S1754011AbYEaNtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011AbYEaNtV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 09:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752553AbYEaNtG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 09:49:06 -0400
Received: from mu-out-0910.google.com ([209.85.134.190]:63461 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529AbYEaNtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 09:49:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=thOBdqpcTYv9xbkINDzB2YDa2Ueq+zvq6SMtsyLZo99lw4p7awMZVm5uL1yZGjWIzaJUpslQjbmxtxZVdKOHUYsgmeZgOT3UxLibStzCg5JrC5WRXv2zTnm8krwUhA+a5K5ldy/TkLOEZhvXZ80Kgogz4NhHxJlG7fYUBGm2wYA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] ide-generic: add missing hwif->chipset setup
Date: Sat, 31 May 2008 15:43:30 +0200
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org, "John Keller" <jpk@sgi.com>,
       Dmitri Vorobiev <dmitri.vorobiev@gmail.com>, Mel Gorman <mel@csn.ul.ie>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200805311543.30501.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hwif->chipset need to be set properly or ide-generic driver will break once
we make a final step in fixing host drivers' dependence on ide_hwifs[].

Problem was catched early thanks to IDE tree exposure in -mm / -next trees
and reported by people listed people (thank you guys!).

Reported-by: "John Keller" <jpk@sgi.com>
Reported-by: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Reported-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
With this patch applied we can bring "ide: fix hwif-s initialization"
and "ide: make ide_hwifs[] static" patches back into IDE tree! :)

 drivers/ide/ide-generic.c |    1 +
 1 file changed, 1 insertion(+)

Index: b/drivers/ide/ide-generic.c
===================================================================
--- a/drivers/ide/ide-generic.c
+++ b/drivers/ide/ide-generic.c
@@ -125,6 +125,7 @@ static int __init ide_generic_init(void)
 			memset(&hw, 0, sizeof(hw));
 			ide_std_init_ports(&hw, io_addr, io_addr + 0x206);
 			hw.irq = ide_default_irq(io_addr);
+			hw.chipset = ide_generic;
 			ide_init_port_hw(hwif, &hw);
 
 			idx[i] = i;
