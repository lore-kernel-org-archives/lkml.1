Return-Path: <linux-kernel-owner+w=401wt.eu-S1758971AbZLKPhB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758971AbZLKPhB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 10:37:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758877AbZLKPg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 10:36:58 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:58443 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758830AbZLKPg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 10:36:56 -0500
Date: Fri, 11 Dec 2009 23:36:58 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Matt Mackall <mpm@selenic.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: hwrng: virtio - Rename driver object to remove section mismatch
	warning
Message-ID: <20091211153658.GA1207@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi:

Finally found the cause of the section mismatch warning in hwrng.
Apparently in addition to __devexit_p we now have to name the
variable in a certain way.

I'll add this patch.

commit 8afb602bb676ed7da3cba154f2f5edf3971a582b
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Fri Dec 11 23:35:06 2009 +0800

    hwrng: virtio - Rename driver object to remove section mismatch warning
    
    The section mismatch warning shows up unless the __devexit referencing
    variable is named in a certain way.
    
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
index bdaef8e..64fe0a7 100644
--- a/drivers/char/hw_random/virtio-rng.c
+++ b/drivers/char/hw_random/virtio-rng.c
@@ -114,7 +114,7 @@ static struct virtio_device_id id_table[] = {
 	{ 0 },
 };
 
-static struct virtio_driver virtio_rng = {
+static struct virtio_driver virtio_rng_driver = {
 	.driver.name =	KBUILD_MODNAME,
 	.driver.owner =	THIS_MODULE,
 	.id_table =	id_table,
@@ -124,12 +124,12 @@ static struct virtio_driver virtio_rng = {
 
 static int __init init(void)
 {
-	return register_virtio_driver(&virtio_rng);
+	return register_virtio_driver(&virtio_rng_driver);
 }
 
 static void __exit fini(void)
 {
-	unregister_virtio_driver(&virtio_rng);
+	unregister_virtio_driver(&virtio_rng_driver);
 }
 module_init(init);
 module_exit(fini);
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
