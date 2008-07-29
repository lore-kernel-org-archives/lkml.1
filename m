Return-Path: <linux-kernel-owner+w=401wt.eu-S1757942AbYG2LqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757942AbYG2LqT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 07:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755599AbYG2LqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 07:46:10 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:32477 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755404AbYG2LqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 07:46:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent:from;
        b=CitVS4w0Icy8/2mhFxmawHfIPK2sRxub9OX0HQUnir2EW11Y5VKMgOqubc2VOBd2LY
         dwux5YzZiZn3lbKsGEBcgisLIFqF3F7wbLSsU9hrk5XVslnn3zzfE6tx9/V8zm8tJwQN
         4C04ZNuz4m1onm0FXCCO9dU9lOwoA/QuU2ACo=
Date: Tue, 29 Jul 2008 13:45:40 +0200
To: "John W. Linville" <linville@tuxdriver.com>,
       Masakazu Mokuno <mokuno@sm.sony.co.jp>
Cc: Julia Lawall <julia@diku.dk>, Alexey Dobriyan <adobriyan@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] PS3: gelic: use unsigned long for irqflags
Message-ID: <20080729114540.GB26181@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PS: Using a bit more context once the patch is applied, it's easier to spot
where the flags are used.

The semantic patch I used was this:

@@
expression lock;
identifier flags;
expression subclass;
@@

- unsigned int flags;
+ unsigned long flags;

...

<+...

(
 spin_lock_irqsave(lock, flags)
|
 _spin_lock_irqsave(lock)
|
 spin_unlock_irqrestore(lock, flags)
|
 _spin_unlock_irqrestore(lock, flags)
|
 read_lock_irqsave(lock, flags)
|
 _read_lock_irqsave(lock)
|
 read_unlock_irqrestore(lock, flags)
|
 _read_unlock_irqrestore(lock, flags)
|
 write_lock_irqsave(lock, flags)
|
 _write_lock_irqsave(lock)
|
 write_unlock_irqrestore(lock, flags)
|
 _write_unlock_irqrestore(lock, flags)
|
 spin_lock_irqsave_nested(lock, flags, subclass)
|
 _spin_lock_irqsave_nested(lock, subclass)
|
 spin_unlock_irqrestore(lock, flags)
|
 _spin_unlock_irqrestore(lock, flags)
|
 _raw_spin_lock_flags(lock, flags)
|
 __raw_spin_lock_flags(lock, flags)
)

...+>


>From dff3eafa820b68cecd2982ad714b6a88d6a06d41 Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Tue, 29 Jul 2008 13:31:47 +0200
Subject: [PATCH] PS3: gelic: use unsigned long for irqflags

This patch was generated using the Coccinelle framework.

Cc: Masakazu Mokuno <mokuno@sm.sony.co.jp>
Cc: Julia Lawall <julia@diku.dk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 drivers/net/ps3_gelic_wireless.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ps3_gelic_wireless.c b/drivers/net/ps3_gelic_wireless.c
index 6b2dee0..a834b52 100644
--- a/drivers/net/ps3_gelic_wireless.c
+++ b/drivers/net/ps3_gelic_wireless.c
@@ -1024,7 +1024,7 @@ static int gelic_wl_set_encode(struct net_device *netdev,
 	struct gelic_wl_info *wl = port_wl(netdev_priv(netdev));
 	struct iw_point *enc = &data->encoding;
 	__u16 flags;
-	unsigned int irqflag;
+	unsigned long irqflag;
 	int key_index, index_specified;
 	int ret = 0;
 
@@ -1097,7 +1097,7 @@ static int gelic_wl_get_encode(struct net_device *netdev,
 {
 	struct gelic_wl_info *wl = port_wl(netdev_priv(netdev));
 	struct iw_point *enc = &data->encoding;
-	unsigned int irqflag;
+	unsigned long irqflag;
 	unsigned int key_index, index_specified;
 	int ret = 0;
 
@@ -1215,7 +1215,7 @@ static int gelic_wl_set_encodeext(struct net_device *netdev,
 	struct iw_encode_ext *ext = (struct iw_encode_ext *)extra;
 	__u16 alg;
 	__u16 flags;
-	unsigned int irqflag;
+	unsigned long irqflag;
 	int key_index;
 	int ret = 0;
 
@@ -1303,7 +1303,7 @@ static int gelic_wl_get_encodeext(struct net_device *netdev,
 	struct gelic_wl_info *wl = port_wl(netdev_priv(netdev));
 	struct iw_point *enc = &data->encoding;
 	struct iw_encode_ext *ext = (struct iw_encode_ext *)extra;
-	unsigned int irqflag;
+	unsigned long irqflag;
 	int key_index;
 	int ret = 0;
 	int max_key_len;
@@ -1426,7 +1426,7 @@ static int gelic_wl_priv_set_psk(struct net_device *net_dev,
 {
 	struct gelic_wl_info *wl = port_wl(netdev_priv(net_dev));
 	unsigned int len;
-	unsigned int irqflag;
+	unsigned long irqflag;
 	int ret = 0;
 
 	pr_debug("%s:<- len=%d\n", __func__, data->data.length);
@@ -1467,7 +1467,7 @@ static int gelic_wl_priv_get_psk(struct net_device *net_dev,
 {
 	struct gelic_wl_info *wl = port_wl(netdev_priv(net_dev));
 	char *p;
-	unsigned int irqflag;
+	unsigned long irqflag;
 	unsigned int i;
 
 	pr_debug("%s:<-\n", __func__);
-- 
1.5.5.1

