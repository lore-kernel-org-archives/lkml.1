Return-Path: <linux-kernel-owner+w=401wt.eu-S965090AbXIBL0N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965090AbXIBL0N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 07:26:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964789AbXIBL0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 07:26:00 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:49172 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755702AbXIBLZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 07:25:59 -0400
Date: Sun, 2 Sep 2007 13:25:57 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, davem@davemloft.net
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [-mm patch] IPV6 must select XFRM
Message-ID: <20070902112557.GK16016@stusta.de>
References: <20070831215822.26e1432b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070831215822.26e1432b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2007 at 09:58:22PM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.23-rc3-mm1:
>...
>  git-net.patch
>...
>  git trees
>...

This patch fixes the following compile error:

<--  snip  -->

...
  LD      .tmp_vmlinux1
net/built-in.o: In function `inet6_csk_xmit':
(.text+0x72b0f): undefined reference to `flow_cache_genid'
net/built-in.o: In function `inet6_csk_xmit':
(.text+0x72be5): undefined reference to `flow_cache_genid'
make[1]: *** [.tmp_vmlinux1] Error 1

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
--- a/net/ipv6/Kconfig
+++ b/net/ipv6/Kconfig
@@ -5,6 +5,7 @@
 #   IPv6 as module will cause a CRASH if you try to unload it
 config IPV6
 	tristate "The IPv6 protocol"
+	select XFRM
 	default m
 	---help---
 	  This is complemental support for the IP version 6.

