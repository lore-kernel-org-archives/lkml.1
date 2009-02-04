Return-Path: <linux-kernel-owner+w=401wt.eu-S1758941AbZBDSis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758941AbZBDSis (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 13:38:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758190AbZBDShD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 13:37:03 -0500
Received: from kroah.org ([198.145.64.141]:50930 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758247AbZBDShA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 13:37:00 -0500
Date: Wed, 4 Feb 2009 10:34:22 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Adrian Bunk <bunk@kernel.org>,
       Greg Ungerer <gerg@uclinux.org>
Subject: [patch 04/33] m68knommu: set NO_DMA
Message-ID: <20090204183422.GE13936@kroah.com>
References: <20090204182823.831027530@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="m68knommu-set-no_dma.patch"
In-Reply-To: <20090204183403.GA13936@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Adrian Bunk <bunk@kernel.org>

commit e0212e72186e855027dd35b37e9d7a99a078448c upstream.

m68knommu does not set the Kconfig NO_DMA variable, but also does
not provide the required functions, resulting in the following
build error triggered by commit a40c24a13366e324bc0ff8c3bb107db89312c984
(net: Add SKB DMA mapping helper functions.):

<--  snip  -->

..
  LD      vmlinux
net/built-in.o: In function `skb_dma_unmap':
(.text+0xac5e): undefined reference to `dma_unmap_single'
net/built-in.o: In function `skb_dma_unmap':
(.text+0xac7a): undefined reference to `dma_unmap_page'
net/built-in.o: In function `skb_dma_map':
(.text+0xacdc): undefined reference to `dma_map_single'
net/built-in.o: In function `skb_dma_map':
(.text+0xace8): undefined reference to `dma_mapping_error'
net/built-in.o: In function `skb_dma_map':
(.text+0xad10): undefined reference to `dma_map_page'
net/built-in.o: In function `skb_dma_map':
(.text+0xad82): undefined reference to `dma_unmap_page'
net/built-in.o: In function `skb_dma_map':
(.text+0xadc6): undefined reference to `dma_unmap_single'
make[1]: *** [vmlinux] Error 1

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Greg Ungerer <gerg@uclinux.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/m68knommu/Kconfig |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/m68knommu/Kconfig
+++ b/arch/m68knommu/Kconfig
@@ -14,6 +14,10 @@ config MMU
 	bool
 	default n
 
+config NO_DMA
+	bool
+	default y
+
 config FPU
 	bool
 	default n

