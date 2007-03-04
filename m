Return-Path: <linux-kernel-owner+w=401wt.eu-S1751593AbXCDMOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751593AbXCDMOw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 07:14:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751594AbXCDMOw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 07:14:52 -0500
Received: from smtp.osdl.org ([65.172.181.24]:35399 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751589AbXCDMOv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 07:14:51 -0500
Date: Sun, 4 Mar 2007 04:11:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Maciej Rutecki <maciej.rutecki@gmail.com>
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: [Re: 2.6.21-rc2-mm1] #error no ROMFS backing store interface
 configured
Message-Id: <20070304041111.1d2774e7.akpm@linux-foundation.org>
In-Reply-To: <45EAB46F.1030709@gmail.com>
References: <20070302030026.5eef0c92.akpm@linux-foundation.org>
	<20070302030405.22f78999.akpm@linux-foundation.org>
	<45EAB46F.1030709@gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 04 Mar 2007 12:58:39 +0100 Maciej Rutecki <maciej.rutecki@gmail.com> wrote:

> CC [M]  fs/romfs/storage.o
> fs/romfs/storage.c:18:2: error: #error no ROMFS backing store interface
> configured
> make[3]: *** [fs/romfs/storage.o] Błąd 1
> make[2]: *** [fs/romfs] Błąd 2
> make[1]: *** [fs] Błąd 2
> make[1]: Opuszczenie katalogu `/usr/src/linux-mm'
> make: *** [debian/stamp-build-kernel] Błąd 2
> 

+config ROMFS_ON_BLOCK
+	bool "Block device-backed ROM file system support"
+	depends on ROMFS_FS && BLOCK
+	help
+	  This permits ROMFS to use block devices buffered through the page
+	  cache as the medium from which to retrieve data.  It does not allow
+	  direct mapping of the medium.
+
+	  If unsure, answer Y.
+
+config ROMFS_ON_MTD
+	bool "MTD-backed ROM file system support"
+	depends on ROMFS_FS && MTD
+	help
+	  This permits ROMFS to use MTD based devices directly, without the
+	  intercession of the block layer (which may have been disabled).  It
+	  also allows direct mapping of MTD devices through romfs files under
+	  NOMMU conditions if the underlying device is directly addressable by
+	  the CPU.
+

So we require that one of these be enabled if ROMFS.

There's a way of doing that, but I forget what it is.  iirc Adrian has done
this in the past and can perhaps point us at an example?
