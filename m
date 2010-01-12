Return-Path: <linux-kernel-owner+w=401wt.eu-S1754396Ab0ALAZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396Ab0ALAZV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 19:25:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754313Ab0ALAZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 19:25:20 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:47986 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753321Ab0ALAZT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 19:25:19 -0500
Date: Tue, 12 Jan 2010 11:25:16 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Albin Tonnerre <albin.tonnerre@free-electrons.com>
Subject: linux-next: manual merge of the squashfs tree with Linus' tree
Message-Id: <20100112112516.18e7b1aa.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta4 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Phillip,

Today's linux-next merge of the squashfs tree got conflicts in
lib/Kconfig and lib/Makefile between commit
cacb246f8db2b9eba89d44a0f0dd4f6ed93bc113 ("Add LZO compression support
for initramfs and old-style initrd") from Linus' tree and commits
2b817d5acc7a39c503d1393eb9e8268b39b5aa44 ("lzma: Make lzma available to
non initramfs/initrd code") and 58f168eba2ff08f04323544eb7aaa2de10d39c2f
("ibs: force lzma_wrapper to be retained") from the squashfs tree.

I fixed it up (see below) and can carry the fix for a while.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc lib/Kconfig
index 170d8ca,551d75d..0000000
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@@ -117,10 -117,9 +117,13 @@@ config DECOMPRESS_BZIP
  config DECOMPRESS_LZMA
  	tristate
  
+ config DECOMPRESS_LZMA_NEEDED
+ 	 boolean
+ 
 +config DECOMPRESS_LZO
 +	select LZO_DECOMPRESS
 +	tristate
 +
  #
  # Generic allocator support is selected if needed
  #
diff --cc lib/Makefile
index e02765d,4309e69..0000000
--- a/lib/Makefile
+++ b/lib/Makefile
@@@ -69,8 -68,7 +69,8 @@@ obj-$(CONFIG_LZO_DECOMPRESS) += lzo
  
  lib-$(CONFIG_DECOMPRESS_GZIP) += decompress_inflate.o
  lib-$(CONFIG_DECOMPRESS_BZIP2) += decompress_bunzip2.o
- lib-$(CONFIG_DECOMPRESS_LZMA) += decompress_unlzma.o
+ obj-$(CONFIG_DECOMPRESS_LZMA) += decompress_unlzma.o
 +lib-$(CONFIG_DECOMPRESS_LZO) += decompress_unlzo.o
  
  obj-$(CONFIG_TEXTSEARCH) += textsearch.o
  obj-$(CONFIG_TEXTSEARCH_KMP) += ts_kmp.o
