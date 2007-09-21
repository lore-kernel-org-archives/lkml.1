Return-Path: <linux-kernel-owner+w=401wt.eu-S1764050AbXIUVyM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764050AbXIUVyM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 17:54:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756544AbXIUVx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 17:53:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47038 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486AbXIUVx5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 17:53:57 -0400
Date: Fri, 21 Sep 2007 17:53:51 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Fix printk levels in intel-rng
Message-ID: <20070921215351.GH11455@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

intel_rng has extraneous printk levels which cause some odd looking
output during boot.

[   41.250634] intel_rng: Firmware space is locked read-only. <4>intel_rng: If you can't or
[   41.250638]  don't want to <4>intel_rng: disable this in firmware setup, and <4>intel_rng: if
[   41.250639]  you are certain that your <4>intel_rng: system has a functional
[   41.250641]  RNG, try<4>intel_rng: using the 'no_fwh_detect' option.
[   41.250706] agpgart: AGP aperture is 128M @ 0xe8000000

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/drivers/char/hw_random/intel-rng.c b/drivers/char/hw_random/intel-rng.c
index 753f460..45b43b8 100644
--- a/drivers/char/hw_random/intel-rng.c
+++ b/drivers/char/hw_random/intel-rng.c
@@ -297,9 +297,9 @@ static int __init intel_init_hw_struct(struct intel_rng_hw *intel_rng_hw,
 	    == BIOS_CNTL_LOCK_ENABLE_MASK) {
 		static __initdata /*const*/ char warning[] =
 			KERN_WARNING PFX "Firmware space is locked read-only. If you can't or\n"
-			KERN_WARNING PFX "don't want to disable this in firmware setup, and if\n"
-			KERN_WARNING PFX "you are certain that your system has a functional\n"
-			KERN_WARNING PFX "RNG, try using the 'no_fwh_detect' option.\n";
+			PFX "don't want to disable this in firmware setup, and if\n"
+			PFX "you are certain that your system has a functional\n"
+			PFX "RNG, try using the 'no_fwh_detect' option.\n";
 
 		if (no_fwh_detect)
 			return -ENODEV;
-- 
http://www.codemonkey.org.uk
