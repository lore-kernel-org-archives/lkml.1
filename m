Return-Path: <linux-kernel-owner+w=401wt.eu-S1753199Ab0AGQFH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199Ab0AGQFH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 11:05:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753113Ab0AGQFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 11:05:06 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:57411 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116Ab0AGQFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 11:05:04 -0500
Date: Thu, 7 Jan 2010 08:04:02 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: mmotm 2010-01-06-14-34 uploaded (squashfs+lib/decomp)
Message-Id: <20100107080402.2f41d6f9.randy.dunlap@oracle.com>
In-Reply-To: <12823.1262836907@localhost>
References: <201001062259.o06MxQrp023236@imap1.linux-foundation.org>
	<12343.1262836096@localhost>
	<12823.1262836907@localhost>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4B460615.0098:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Jan 2010 23:01:47 -0500 Valdis.Kletnieks@vt.edu wrote:

> On Wed, 06 Jan 2010 22:48:16 EST, Valdis.Kletnieks@vt.edu said:
> 
> > Building with CONFIG_SQUASHFS=m, CONFIG_SQUASHFS_LZMA=y ,
> > and CONFIG_DECOMPRESS_LZMA=n fails:
> 
> > Looks like a missing select/depends for DECOMPRESS_LZMA.  Somebody else can
> > decide which it should be...
> 
> Digging further:
>   
>   x Symbol: DECOMPRESS_LZMA [=n]                                            x  
>   x   Selected by: RD_LZMA [=n] && BLK_DEV_INITRD [=y] || SQUASHFS_LZMA [=y x  
> 
> How the heck did this happen?  Looks like a SELECT *is* there but it's
> not firing??!?

I saw this build error in linux-next and sent a patch for it -- it's below.
However, it doesn't appear to be exactly the same config as yours.


---
From: Randy Dunlap <randy.dunlap@oracle.com>

When CONFIG_SQUASHFS=m and CONFIG_DECOMPRESS_LZMA=m, decompress_lzma
is built but then discarded from the library because no built-in code
uses it, so change it from a lib- to an obj- to force it to be kept
in the library.

ERROR: "unlzma" [fs/squashfs/squashfs.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: Michal Marek <mmarek@suse.cz>
---
 lib/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20100101.orig/lib/Makefile
+++ linux-next-20100101/lib/Makefile
@@ -69,7 +69,7 @@ obj-$(CONFIG_LZO_DECOMPRESS) += lzo/
 
 lib-$(CONFIG_DECOMPRESS_GZIP) += decompress_inflate.o
 lib-$(CONFIG_DECOMPRESS_BZIP2) += decompress_bunzip2.o
-lib-$(CONFIG_DECOMPRESS_LZMA) += decompress_unlzma.o
+obj-$(CONFIG_DECOMPRESS_LZMA) += decompress_unlzma.o
 
 obj-$(CONFIG_TEXTSEARCH) += textsearch.o
 obj-$(CONFIG_TEXTSEARCH_KMP) += ts_kmp.o
