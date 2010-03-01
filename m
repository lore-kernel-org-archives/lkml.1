Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800Ab0CAXTf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 18:19:35 -0500
Received: from exprod6og107.obsmtp.com ([64.18.1.208]:47896 "HELO
	exprod6og107.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752628Ab0CAXTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 18:19:34 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: staging/dt3155: Question about dt3155_init_isr
Date: Mon, 1 Mar 2010 18:19:34 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE1909021BA2A9@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: staging/dt3155: Question about dt3155_init_isr
Thread-Index: Acq5laenT23ON7xISLGgGe9yT7KVGw==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>
Cc: "Greg KH" <greg@kroah.com>, <ss@aao.gov.au>
X-OriginalArrivalTime: 01 Mar 2010 23:19:31.0659 (UTC) FILETIME=[A5CF91B0:01CAB995]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o21NKFmE000729

Hello all,

In dt3155_drv.c the function dt3155_init_isr() sets up the card for
interrupt generation.  About half way thru the function is the following:

  /* 50/60 Hz should be set before this point but let's make sure it is */
  /* right anyway */

  ReadI2C(dt3155_lbase[ minor ], CONFIG, &i2c_csr2.reg);
  i2c_csr2.fld.HZ50 = FORMAT50HZ;
  WriteI2C(dt3155_lbase[ minor ], CONFIG, i2c_config.reg);

Based on the register definitions in dt3155_io.h shouldn't this actually
be:

  ReadI2C(dt3155_lbase[ minor ], CSR2, &i2c_csr2.reg);
  i2c_csr2.fld.HZ50 = FORMAT50HZ;
  WriteI2C(dt3155_lbase[ minor ], CSR2, i2c_csr2.reg);

Regards,
Hartley
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
