Return-Path: <linux-kernel-owner+w=401wt.eu-S1756631AbZLUP6B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631AbZLUP6B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 10:58:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756127AbZLUP6A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 10:58:00 -0500
Received: from smtp.ispras.ru ([83.149.198.201]:48810 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756109AbZLUP57 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 10:57:59 -0500
From: Alexander Strakh <strakh@ispras.ru>
Organization: ISP RAS
To: Thomas Winischhofer <thomas@winischhofer.net>,
       "Greg Kroah-Hartman" <gregkh@suse.de>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: BUG null dereference in driver ./drivers/usb/misc/sisusbvga/sisusb.c
Date: Mon, 21 Dec 2009 20:03:10 +0000
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-0.1-desktop; KDE/4.3.1; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200912212003.10697.strakh@ispras.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

        KERNEL_VERSION: 2.6.32
        SUBJECT: null derefernce in function sisusb_probe
        SUBSCRIBE:
        In driver drivers/usb/misc/sisusbvga/sisusb.c in function 
sisusb_probe:

1. if in line 3085 after calling function kzalloc variable sisub = 
NULL, then we goto line 3086.
2. In line 3086:  null dereference of sisusb - "&sisusb->sisusb_dev->dev".

3084         /* Allocate memory for our private */
3085         if (!(sisusb = kzalloc(sizeof(*sisusb), GFP_KERNEL))) {
3086                 dev_err(&sisusb->sisusb_dev->dev, "Failed to allocate 
memory for private data\n");
3087                 return -ENOMEM;
3088         }
3089         kref_init(&sisusb->kref);

Found by Linux Device Drivers Verification Project (Svace Detector)
