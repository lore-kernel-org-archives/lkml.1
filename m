Return-Path: <linux-kernel-owner+w=401wt.eu-S935295AbZLGPSa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935295AbZLGPSa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 10:18:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935259AbZLGPS1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 10:18:27 -0500
Received: from ppsw-6.csi.cam.ac.uk ([131.111.8.136]:35397 "EHLO
	ppsw-6.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932683AbZLGPS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 10:18:26 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4B1D1CF5.6030502@cam.ac.uk>
Date: Mon, 07 Dec 2009 15:19:17 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20091029)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] Staging: IIO: add selection of IIO_SW_RING to LIS3L02DQ as
 needed
References: <20091204203014.e8ee54ca.sfr@canb.auug.org.au> <20091206101225.7d8ce4a4.randy.dunlap@oracle.com>
In-Reply-To: <20091206101225.7d8ce4a4.randy.dunlap@oracle.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
---

 Thanks to Randy for the report. Sorry for the slow response.
 I've been meaning to carefully check for any remaining cases like
 this.
 Here I've kept the selection of IIO_SW_RING separate from
 IIO_TRIGGER as it will go away fairly shortly when the ring buffer
 type becomes configurable on a per device basis, whereas the
 IIO_TRIGGER select will remain. Whether to retain the option to
 remove the support for ring buffers entirely is one for after that
 support is in place.

 Touch wood I think this is the last one, but I'll try a selection of
 unusual combinations now and post others as replies to this email.

 drivers/staging/iio/accel/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/iio/accel/Kconfig b/drivers/staging/iio/accel/Kconfig
index 4044663..3d3c333 100644
--- a/drivers/staging/iio/accel/Kconfig
+++ b/drivers/staging/iio/accel/Kconfig
@@ -14,6 +14,7 @@ config LIS3L02DQ
 	tristate "ST Microelectronics LIS3L02DQ Accelerometer Driver"
 	depends on SPI
 	select IIO_TRIGGER if IIO_RING_BUFFER
+	select IIO_SW_RING if IIO_RING_BUFFER
 	help
 	  Say yes here to build SPI support for the ST microelectronics
 	  accelerometer. The driver supplies direct access via sysfs files
-- 
1.6.4.4
