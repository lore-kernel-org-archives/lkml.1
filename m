Return-Path: <linux-kernel-owner+w=401wt.eu-S1758962AbXK1J3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758962AbXK1J3U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 04:29:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755319AbXK1J3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 04:29:09 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:35583 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755102AbXK1J3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 04:29:08 -0500
Date: Wed, 28 Nov 2007 09:28:56 +0000
From: Al Viro <viro@ftp.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pierre Ossman <drzeus@drzeus.cx>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Sam Ravnborg <sam@ravnborg.org>, Marcel Holtmann <marcel@holtmann.org>,
       linux-kernel@vger.kernel.org
Subject: Re: m68k build failure
Message-ID: <20071128092856.GV8181@ftp.linux.org.uk>
References: <20071127220723.e2e3d0b4.akpm@linux-foundation.org> <20071128094856.056c0a3f@poseidon.drzeus.cx> <20071128010056.85703a34.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071128010056.85703a34.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2007 at 01:00:56AM -0800, Andrew Morton wrote:
> > No the slightest. 12 seems like the correct, padded size. A size of 10 is just weird as the unpadded size is 9 bytes. Could you dump the __mod_sdio_device_table section so we can determine if it is cropped or just oddly padded.
> > 
> 
> err, I'd rather not.  I have no shortage of bugs to be going on with here.
> 
> http://userweb.kernel.org/~akpm/cross-compilers/ has the i386->m68k
> cross-compiler which I use.

Eh...  m68k has 16bit alignment for unsigned long.  

diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -343,7 +343,8 @@ struct sdio_device_id {
 	__u8	class;			/* Standard interface or SDIO_ANY_ID */
 	__u16	vendor;			/* Vendor or SDIO_ANY_ID */
 	__u16	device;			/* Device ID or SDIO_ANY_ID */
-	kernel_ulong_t driver_data;	/* Data private to the driver */
+	kernel_ulong_t driver_data	/* Data private to the driver */
+		__attribute__((aligned(sizeof(kernel_ulong_t))));
 };
 
 /* SSB core, see drivers/ssb/ */
