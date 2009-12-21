Return-Path: <linux-kernel-owner+w=401wt.eu-S1756758AbZLUQHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758AbZLUQHy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 11:07:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756745AbZLUQHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 11:07:52 -0500
Received: from smtp.ispras.ru ([83.149.198.201]:48852 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756658AbZLUQHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 11:07:50 -0500
From: Alexander Strakh <strakh@ispras.ru>
Organization: ISP RAS
To: Frederic Rible <frible@teaser.fr>, Thomas Sailer <sailer@ife.ee.ethz.ch>,
       "Jean-Paul Roubelat" <jpr@f6fbb.org>, linux-hams@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: BUG null dereference in driver ./drivers/net/hamradio/yam.c
Date: Mon, 21 Dec 2009 20:13:01 +0000
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-0.1-desktop; KDE/4.3.1; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200912212013.01887.strakh@ispras.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

        KERNEL_VERSION: 2.6.32
        SUBJECT: null derefernce in function __init yam_init_driver
        SUBSCRIBE:
        In driver drivers/net/hamradio/yam.c in function __init 
yam_init_driver:

1. If in line 1153 dev = NULL then we goto line 1154
2. In line 1155 we have null dereference of "dev->name"

1153                 if (!dev) {
1154                         printk(KERN_ERR "yam: cannot allocate net device 
%s\n",
1155                                dev->name);
1156                         err = -ENOMEM;
1157                         goto error;
1158                 }

Found by Linux Device Drivers Verification Project (Svace Detector)
