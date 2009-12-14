Return-Path: <linux-kernel-owner+w=401wt.eu-S1757962AbZLNQqL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757962AbZLNQqL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 11:46:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757950AbZLNQqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 11:46:08 -0500
Received: from smtp.ispras.ru ([83.149.198.201]:46560 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756613AbZLNQqF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 11:46:05 -0500
From: Alexander Strakh <strakh@ispras.ru>
Organization: ISP RAS
To: Mark Lord <mlord@pobox.com>, linux-ide@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: BUG null dereference in drivers/ata/sata_mv.c
Date: Mon, 14 Dec 2009 20:51:33 +0000
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-0.1-desktop; KDE/4.3.1; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200912142051.34029.strakh@ispras.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	KERNEL_VERSION: 2.6.32
	SUBJECT: null dereference in function mv_unexpected_intr
	DESCRIBE:
	In ./drivers/ata/sata_mv.c in function mv_port_intr 

1. If ap == NULL in line 2778, then we goto line 2779.
2. In line 2779 function mv_unexpected_intr(ap, 0) is called.
3. In line 2538 null dereference: "ap->link.eh_info"

2773 static void mv_port_intr(struct ata_port *ap, u32 port_cause)
2774 {
...
2778         if (!ap || (ap->flags & ATA_FLAG_DISABLED)) {
2779                 mv_unexpected_intr(ap, 0);
2780                 return;
2781         }
...
2809 }

2536 static void mv_unexpected_intr(struct ata_port *ap, int edma_was_enabled)
2537 {
2538         struct ata_eh_info *ehi = &ap->link.eh_info;
...
2555 }

Found by Linux Device Drivers Verification Project (Svace Detector)
