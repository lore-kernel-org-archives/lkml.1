Return-Path: <linux-kernel-owner+w=401wt.eu-S1755795AbZKJDTK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755795AbZKJDTK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 22:19:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755345AbZKJDTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 22:19:10 -0500
Received: from ozlabs.org ([203.10.76.45]:47575 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755002AbZKJDTJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 22:19:09 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCHv9 3/3] vhost_net: a kernel-level virtio server
Date: Tue, 10 Nov 2009 13:49:09 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; i686; ; )
Cc: netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       linux-mm@kvack.org, akpm@linux-foundation.org, hpa@zytor.com,
       gregory.haskins@gmail.com, s.hetze@linux-ag.com,
       Daniel Walker <dwalker@fifo99.com>,
       Eric Dumazet <eric.dumazet@gmail.com>
References: <cover.1257786516.git.mst@redhat.com> <20091109172230.GD4724@redhat.com>
In-Reply-To: <20091109172230.GD4724@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911101349.09783.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One fix:

vhost: fix TUN=m VHOST_NET=y

	drivers/built-in.o: In function `get_tun_socket':
	net.c:(.text+0x15436e): undefined reference to `tun_get_socket'

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/vhost/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
--- a/drivers/vhost/Kconfig
+++ b/drivers/vhost/Kconfig
@@ -1,6 +1,6 @@
 config VHOST_NET
 	tristate "Host kernel accelerator for virtio net (EXPERIMENTAL)"
-	depends on NET && EVENTFD && EXPERIMENTAL
+	depends on NET && EVENTFD && TUN && EXPERIMENTAL
 	---help---
 	  This kernel module can be loaded in host kernel to accelerate
 	  guest networking with virtio_net. Not to be confused with virtio_net
