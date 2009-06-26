Return-Path: <linux-kernel-owner+w=401wt.eu-S1756158AbZFZCMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158AbZFZCMT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 22:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752724AbZFZCML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 22:12:11 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:59837 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552AbZFZCML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 22:12:11 -0400
Message-ID: <4A442E7C.7070301@oss.ntt.co.jp>
Date: Fri, 26 Jun 2009 11:12:12 +0900
From: =?UTF-8?B?RmVybmFuZG8gTHVpcyBWw6F6cXVleiBDYW8=?= 
	<fernando@oss.ntt.co.jp>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: gregkh@suse.de, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging/vt6655: pointer to driver_data needs to be type long
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the compilation error below while at it.

drivers/staging/vt6655/device_main.c:347: warning: cast from pointer to integer of different size
drivers/staging/vt6655/device_main.c:347: error: initializer element is not constant
drivers/staging/vt6655/device_main.c:347: error: (near initialization for ‘device_id_table[0].driver_data’)

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
---

diff -urNp linux-2.6.31-rc1-orig/drivers/staging/vt6655/device_main.c linux-2.6.31-rc1/drivers/staging/vt6655/device_main.c
--- linux-2.6.31-rc1-orig/drivers/staging/vt6655/device_main.c	2009-06-26 10:58:19.752045244 +0900
+++ linux-2.6.31-rc1/drivers/staging/vt6655/device_main.c	2009-06-26 10:47:43.954543595 +0900
@@ -344,7 +344,7 @@ static CHIP_INFO chip_info_table[]= {
  };

  static struct pci_device_id device_id_table[] __devinitdata = {
-{ 0x1106, 0x3253, PCI_ANY_ID, PCI_ANY_ID, 0, 0, (int)&chip_info_table[0]},
+{ 0x1106, 0x3253, PCI_ANY_ID, PCI_ANY_ID, 0, 0, (long)&chip_info_table[0]},
  { 0, }
  };
  #endif
