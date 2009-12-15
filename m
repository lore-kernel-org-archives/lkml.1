Return-Path: <linux-kernel-owner+w=401wt.eu-S1760206AbZLONtv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760206AbZLONtv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 08:49:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757684AbZLONts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 08:49:48 -0500
Received: from smtp.ispras.ru ([83.149.198.201]:50425 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757657AbZLONtr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 08:49:47 -0500
From: Alexander Strakh <strakh@ispras.ru>
Organization: ISP RAS
To: Fritz Elfert <fritz@isdn4linux.de>, Karsten Keil <isdn@linux-pingi.de>,
       Armin Schindler <mac@melware.de>, linux-kernel@vger.kernel.org
Subject: BUG null dereference in driver ./drivers/isdn/icn/icn.c
Date: Tue, 15 Dec 2009 17:55:06 +0000
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-0.1-desktop; KDE/4.3.1; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200912151755.06796.strakh@ispras.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	KERNEL_VERSION: 2.6.32
	SUBJECT: null dereference after check
	DESCRIBE:
	In driver ./drivers/isdn/icn/icn.c in function icn_addcard:

1. If in line 1580 card2 = NULL  then we goto line 1581
2. In line 1581 we have null dereference because printk called with card2-
>interface.id in third parameter.

1580        if (!(card2 = icn_initcard(port, id2))) {
1581                printk(KERN_INFO
1582                       "icn: (%s) half ICN-4B, port 0x%x added\n",
1583                       card2->interface.id, port);
1584                return 0;
1585        }

Found by Linux Device Drivers Verification Project (Svace Detector)
