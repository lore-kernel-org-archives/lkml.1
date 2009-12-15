Return-Path: <linux-kernel-owner+w=401wt.eu-S1760231AbZLONty@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760231AbZLONty (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 08:49:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757784AbZLONtt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 08:49:49 -0500
Received: from smtp.ispras.ru ([83.149.198.201]:50426 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757638AbZLONtr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 08:49:47 -0500
From: Alexander Strakh <strakh@ispras.ru>
Organization: ISP RAS
To: Donald Becker <becker@scyld.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: BUG null dereference in driver ./drivers/net/3c507.c
Date: Tue, 15 Dec 2009 17:55:08 +0000
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-0.1-desktop; KDE/4.3.1; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200912151755.08345.strakh@ispras.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	KERNEL_VERSION: 2.6.32
	SUBJECT: null dereference aftre check
	DESCRIBE:
	In driver drivers/net/3c507.c in function Iirqreturn_t el16_interrupt:

1. If in line 555 dev = NULL then we goto line 556
2. In line 556 we have null dereference because pr_err called with dev->name 
in third parameter.

 555        if (dev == NULL) {
 556                pr_err("%s: net_interrupt(): irq %d for unknown device.
\n",
 557                        dev->name, irq);
 558                return IRQ_NONE;
 559        }

Found by Linux Device Drivers Verification Project (Svace Detector)
