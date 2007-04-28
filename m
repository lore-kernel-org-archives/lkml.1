Return-Path: <linux-kernel-owner+w=401wt.eu-S1750888AbXD1N7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750888AbXD1N7b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 09:59:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752024AbXD1N7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 09:59:31 -0400
Received: from ihemail3.lucent.com ([135.245.0.37]:46294 "EHLO
	ihemail3.lucent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbXD1N7a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 09:59:30 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 8BIT
X-MimeOLE: Produced By Microsoft Exchange V6.0.6249.0
Subject: RE: can a kmalloc be both GFP_ATOMIC and GFP_KERNEL at the same time?
Date: Sat, 28 Apr 2007 21:58:49 +0800
Message-ID: <2AC135F730C4A045BAE4F1C1CB83FD4B03EF6F87@exch03.qd.lucent.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: can a kmalloc be both GFP_ATOMIC and GFP_KERNEL at the same time?
Thread-Index: AceJnQJlOXT1UurZSRqK+djRWrvjtAAAFLzg
From: "Shan, Guo Wen (Gavin)" <gshan@alcatel-lucent.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 28 Apr 2007 13:58:50.0160 (UTC) FILETIME=[5921B300:01C7899D]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


#define GFP_ATOMIC      (__GFP_HIGH)
#define GFP_NOIO        (__GFP_WAIT)
#define GFP_NOFS        (__GFP_WAIT | __GFP_IO)
#define GFP_KERNEL      (__GFP_WAIT | __GFP_IO | __GFP_FS)

-----Original Message-----
From: Robert P. J. Day [mailto:rpjday@mindspring.com]
Sent: Saturday, April 28, 2007 9:41 PM
To: Linux Kernel Mailing List
Subject: can a kmalloc be both GFP_ATOMIC and GFP_KERNEL at the same
time?



  i'd always assumed that the type flags of GFP_ATOMIC and GFP_KERNEL
were mutually exclusive when it came to calling kmalloc(), at least
based on everything i'd read.  so i'm not sure how to interpret the
following:

drivers/scsi/aic7xxx_old.c:  aic_dev = kmalloc(sizeof(struct aic_dev_data), GFP_ATOMIC | GFP_KERNEL);
drivers/message/i2o/device.c:   resblk = kmalloc(buflen + 8, GFP_KERNEL | GFP_ATOMIC);

  clarification?

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
-
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
