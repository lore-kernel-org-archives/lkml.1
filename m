Return-Path: <linux-kernel-owner+w=401wt.eu-S1758011AbYIDKQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758011AbYIDKQs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 06:16:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757624AbYIDKQd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 06:16:33 -0400
Received: from pc125.solomon-systech.com ([202.76.106.125]:34019 "HELO
	virus-gateway.solomon-systech.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756746AbYIDKQc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 06:16:32 -0400
X-Greylist: delayed 3629 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Sep 2008 06:16:31 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.0.6603.0
content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: mmc/card/block.c : mmc_blk_open readonly mount bug?
Date: Thu, 4 Sep 2008 17:17:15 +0800
Message-ID: <6334E09627481B4AA5C8DE1E69E19D3B09D1F13A@SSLEXCHANGE.solomonsystech.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: mmc/card/block.c : mmc_blk_open readonly mount bug?
Thread-Index: AckObteOuECMxxTBQmWgR+W+tW+Xig==
From: <sasin@solomon-systech.com>
To: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mmc_block_open increments md->usage although it returns with -EROFS when
default mounting a MMC/SD card with write protect switch on.  This
reference counting bug prevents /dev/mmcblkX from being released on card
removal, and situation worsen with reinsertion until the minor number
range runs out.

"return -EROFS;"

should be replaced by

"
{
ret = -EROFS;
mmc_blk_put(md);
}
"


Best regards,
Sasi
