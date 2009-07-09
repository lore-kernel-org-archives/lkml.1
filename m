Return-Path: <linux-kernel-owner+w=401wt.eu-S1759222AbZGIBkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759222AbZGIBkt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 21:40:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756865AbZGIBkj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 21:40:39 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:58442 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754972AbZGIBki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 21:40:38 -0400
Date: Thu, 9 Jul 2009 11:40:34 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Hin-Tak Leung" <hintak.leung@gmail.com>,
       Pascal Terjan <pterjan@mandriva.com>
Subject: linux-next: manual merge of the wireless tree with the
 wireless-current tree
Message-Id: <20090709114034.02e66f09.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

Today's linux-next merge of the wireless tree got a conflict in
drivers/net/wireless/zd1211rw/zd_usb.c between a couple of commits from
the wireless-current tree and commit
04755d92e9d150a3f308dd39664f859cc2182536 ("zd1211rw: sort vid/pid pairs
by numerical value") from the wireless tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/net/wireless/zd1211rw/zd_usb.c
index 0e6e446,2c24dd9..0000000
--- a/drivers/net/wireless/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zd1211rw/zd_usb.c
@@@ -36,58 -36,57 +36,58 @@@
  
  static struct usb_device_id usb_ids[] = {
  	/* ZD1211 */
+ 	{ USB_DEVICE(0x0105, 0x145f), .driver_info = DEVICE_ZD1211 },
+ 	{ USB_DEVICE(0x0586, 0x3401), .driver_info = DEVICE_ZD1211 },
+ 	{ USB_DEVICE(0x0586, 0x3402), .driver_info = DEVICE_ZD1211 },
+ 	{ USB_DEVICE(0x0586, 0x3407), .driver_info = DEVICE_ZD1211 },
+ 	{ USB_DEVICE(0x0586, 0x3409), .driver_info = DEVICE_ZD1211 },
+ 	{ USB_DEVICE(0x079b, 0x004a), .driver_info = DEVICE_ZD1211 },
 -	{ USB_DEVICE(0x07b8, 0x6001), .driver_info = DEVICE_ZD1211 },
  	{ USB_DEVICE(0x0ace, 0x1211), .driver_info = DEVICE_ZD1211 },
  	{ USB_DEVICE(0x0ace, 0xa211), .driver_info = DEVICE_ZD1211 },
- 	{ USB_DEVICE(0x126f, 0xa006), .driver_info = DEVICE_ZD1211 },
- 	{ USB_DEVICE(0x6891, 0xa727), .driver_info = DEVICE_ZD1211 },
+ 	{ USB_DEVICE(0x0b05, 0x170c), .driver_info = DEVICE_ZD1211 },
+ 	{ USB_DEVICE(0x0b3b, 0x1630), .driver_info = DEVICE_ZD1211 },
+ 	{ USB_DEVICE(0x0b3b, 0x5630), .driver_info = DEVICE_ZD1211 },
  	{ USB_DEVICE(0x0df6, 0x9071), .driver_info = DEVICE_ZD1211 },
  	{ USB_DEVICE(0x0df6, 0x9075), .driver_info = DEVICE_ZD1211 },
- 	{ USB_DEVICE(0x157e, 0x300b), .driver_info = DEVICE_ZD1211 },
- 	{ USB_DEVICE(0x079b, 0x004a), .driver_info = DEVICE_ZD1211 },
- 	{ USB_DEVICE(0x1740, 0x2000), .driver_info = DEVICE_ZD1211 },
- 	{ USB_DEVICE(0x157e, 0x3204), .driver_info = DEVICE_ZD1211 },
- 	{ USB_DEVICE(0x0586, 0x3402), .driver_info = DEVICE_ZD1211 },
- 	{ USB_DEVICE(0x0b3b, 0x5630), .driver_info = DEVICE_ZD1211 },
- 	{ USB_DEVICE(0x0b05, 0x170c), .driver_info = DEVICE_ZD1211 },
+ 	{ USB_DEVICE(0x126f, 0xa006), .driver_info = DEVICE_ZD1211 },
+ 	{ USB_DEVICE(0x129b, 0x1666), .driver_info = DEVICE_ZD1211 },
+ 	{ USB_DEVICE(0x13b1, 0x001e), .driver_info = DEVICE_ZD1211 },
  	{ USB_DEVICE(0x1435, 0x0711), .driver_info = DEVICE_ZD1211 },
- 	{ USB_DEVICE(0x0586, 0x3409), .driver_info = DEVICE_ZD1211 },
- 	{ USB_DEVICE(0x0b3b, 0x1630), .driver_info = DEVICE_ZD1211 },
- 	{ USB_DEVICE(0x0586, 0x3401), .driver_info = DEVICE_ZD1211 },
  	{ USB_DEVICE(0x14ea, 0xab13), .driver_info = DEVICE_ZD1211 },
- 	{ USB_DEVICE(0x13b1, 0x001e), .driver_info = DEVICE_ZD1211 },
- 	{ USB_DEVICE(0x0586, 0x3407), .driver_info = DEVICE_ZD1211 },
- 	{ USB_DEVICE(0x129b, 0x1666), .driver_info = DEVICE_ZD1211 },
  	{ USB_DEVICE(0x157e, 0x300a), .driver_info = DEVICE_ZD1211 },
- 	{ USB_DEVICE(0x0105, 0x145f), .driver_info = DEVICE_ZD1211 },
+ 	{ USB_DEVICE(0x157e, 0x300b), .driver_info = DEVICE_ZD1211 },
+ 	{ USB_DEVICE(0x157e, 0x3204), .driver_info = DEVICE_ZD1211 },
+ 	{ USB_DEVICE(0x1740, 0x2000), .driver_info = DEVICE_ZD1211 },
+ 	{ USB_DEVICE(0x6891, 0xa727), .driver_info = DEVICE_ZD1211 },
  	/* ZD1211B */
+ 	{ USB_DEVICE(0x0053, 0x5301), .driver_info = DEVICE_ZD1211B },
+ 	{ USB_DEVICE(0x0411, 0x00da), .driver_info = DEVICE_ZD1211B },
+ 	{ USB_DEVICE(0x0471, 0x1236), .driver_info = DEVICE_ZD1211B },
+ 	{ USB_DEVICE(0x0471, 0x1237), .driver_info = DEVICE_ZD1211B },
+ 	{ USB_DEVICE(0x050d, 0x705c), .driver_info = DEVICE_ZD1211B },
 +	{ USB_DEVICE(0x054c, 0x0257), .driver_info = DEVICE_ZD1211B },
- 	{ USB_DEVICE(0x0ace, 0x1215), .driver_info = DEVICE_ZD1211B },
- 	{ USB_DEVICE(0x0ace, 0xb215), .driver_info = DEVICE_ZD1211B },
- 	{ USB_DEVICE(0x157e, 0x300d), .driver_info = DEVICE_ZD1211B },
+ 	{ USB_DEVICE(0x0586, 0x340a), .driver_info = DEVICE_ZD1211B },
+ 	{ USB_DEVICE(0x0586, 0x340f), .driver_info = DEVICE_ZD1211B },
+ 	{ USB_DEVICE(0x0586, 0x3410), .driver_info = DEVICE_ZD1211B },
+ 	{ USB_DEVICE(0x0586, 0x3412), .driver_info = DEVICE_ZD1211B },
+ 	{ USB_DEVICE(0x0586, 0x3413), .driver_info = DEVICE_ZD1211B },
  	{ USB_DEVICE(0x079b, 0x0062), .driver_info = DEVICE_ZD1211B },
- 	{ USB_DEVICE(0x1582, 0x6003), .driver_info = DEVICE_ZD1211B },
- 	{ USB_DEVICE(0x050d, 0x705c), .driver_info = DEVICE_ZD1211B },
++	{ USB_DEVICE(0x07b8, 0x6001), .driver_info = DEVICE_ZD1211B },
+ 	{ USB_DEVICE(0x07fa, 0x1196), .driver_info = DEVICE_ZD1211B },
+ 	{ USB_DEVICE(0x083a, 0x4505), .driver_info = DEVICE_ZD1211B },
  	{ USB_DEVICE(0x083a, 0xe503), .driver_info = DEVICE_ZD1211B },
  	{ USB_DEVICE(0x083a, 0xe506), .driver_info = DEVICE_ZD1211B },
- 	{ USB_DEVICE(0x083a, 0x4505), .driver_info = DEVICE_ZD1211B },
- 	{ USB_DEVICE(0x0471, 0x1236), .driver_info = DEVICE_ZD1211B },
- 	{ USB_DEVICE(0x13b1, 0x0024), .driver_info = DEVICE_ZD1211B },
- 	{ USB_DEVICE(0x0586, 0x340f), .driver_info = DEVICE_ZD1211B },
+ 	{ USB_DEVICE(0x0ace, 0x1215), .driver_info = DEVICE_ZD1211B },
+ 	{ USB_DEVICE(0x0ace, 0xb215), .driver_info = DEVICE_ZD1211B },
  	{ USB_DEVICE(0x0b05, 0x171b), .driver_info = DEVICE_ZD1211B },
- 	{ USB_DEVICE(0x0586, 0x3410), .driver_info = DEVICE_ZD1211B },
  	{ USB_DEVICE(0x0baf, 0x0121), .driver_info = DEVICE_ZD1211B },
- 	{ USB_DEVICE(0x0586, 0x3412), .driver_info = DEVICE_ZD1211B },
- 	{ USB_DEVICE(0x0586, 0x3413), .driver_info = DEVICE_ZD1211B },
- 	{ USB_DEVICE(0x0053, 0x5301), .driver_info = DEVICE_ZD1211B },
- 	{ USB_DEVICE(0x0411, 0x00da), .driver_info = DEVICE_ZD1211B },
- 	{ USB_DEVICE(0x2019, 0x5303), .driver_info = DEVICE_ZD1211B },
- 	{ USB_DEVICE(0x129b, 0x1667), .driver_info = DEVICE_ZD1211B },
  	{ USB_DEVICE(0x0cde, 0x001a), .driver_info = DEVICE_ZD1211B },
- 	{ USB_DEVICE(0x0586, 0x340a), .driver_info = DEVICE_ZD1211B },
- 	{ USB_DEVICE(0x0471, 0x1237), .driver_info = DEVICE_ZD1211B },
- 	{ USB_DEVICE(0x07fa, 0x1196), .driver_info = DEVICE_ZD1211B },
  	{ USB_DEVICE(0x0df6, 0x0036), .driver_info = DEVICE_ZD1211B },
- 	{ USB_DEVICE(0x07b8, 0x6001), .driver_info = DEVICE_ZD1211B },
+ 	{ USB_DEVICE(0x129b, 0x1667), .driver_info = DEVICE_ZD1211B },
+ 	{ USB_DEVICE(0x13b1, 0x0024), .driver_info = DEVICE_ZD1211B },
+ 	{ USB_DEVICE(0x1582, 0x6003), .driver_info = DEVICE_ZD1211B },
+ 	{ USB_DEVICE(0x157e, 0x300d), .driver_info = DEVICE_ZD1211B },
+ 	{ USB_DEVICE(0x2019, 0x5303), .driver_info = DEVICE_ZD1211B },
  	/* "Driverless" devices that need ejecting */
  	{ USB_DEVICE(0x0ace, 0x2011), .driver_info = DEVICE_INSTALLER },
  	{ USB_DEVICE(0x0ace, 0x20ff), .driver_info = DEVICE_INSTALLER },
