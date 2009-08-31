Return-Path: <linux-kernel-owner+w=401wt.eu-S1751809AbZHaEVN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751809AbZHaEVN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 00:21:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751059AbZHaEVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 00:21:12 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:35414 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929AbZHaEVM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 00:21:12 -0400
Date: Mon, 31 Aug 2009 14:21:05 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ben Hutchings <ben@decadent.org.uk>, Divy Le Ray <divy@chelsio.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: linux-next: manual merge of the drm tree with the net tree
Message-Id: <20090831142105.7c05ae77.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

Today's linux-next merge of the drm tree got a conflict in
firmware/Makefile between commit 2e8c07c35b3ffee7689406be61fd1448ee45d3cd
("cxgb3: use request_firmware() for the EDC registers setup") from the
net tree and commit ece2be7993cc5e269cbf0cad6442b401a2c31915 ("drm/mga:
Use request_firmware() to load microcode") from the drm tree.

Just context changes. I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc firmware/Makefile
index 878329c,d166a7f..0000000
--- a/firmware/Makefile
+++ b/firmware/Makefile
@@@ -42,10 -41,23 +42,26 @@@ fw-shipped-$(CONFIG_CASSINI) += sun/cas
  fw-shipped-$(CONFIG_COMPUTONE) += intelliport2.bin
  fw-shipped-$(CONFIG_CHELSIO_T3) += cxgb3/t3b_psram-1.1.0.bin \
  				   cxgb3/t3c_psram-1.1.0.bin \
 -				   cxgb3/t3fw-7.4.0.bin
 +				   cxgb3/t3fw-7.4.0.bin \
 +				   cxgb3/ael2005_opt_edc.bin \
 +				   cxgb3/ael2005_twx_edc.bin \
 +				   cxgb3/ael2020_twx_edc.bin
+ fw-shipped-$(CONFIG_DRM_MGA) += matrox/g200_warp.fw matrox/g400_warp.fw
+ fw-shipped-$(CONFIG_DRM_R128) += r128/r128_cce.bin
+ fw-shipped-$(CONFIG_DRM_RADEON) += radeon/R100_cp.bin radeon/R200_cp.bin \
+ 				   radeon/R300_cp.bin radeon/R420_cp.bin \
+ 				   radeon/RS690_cp.bin radeon/RS600_cp.bin \
+ 				   radeon/R520_cp.bin \
+ 				   radeon/R600_pfp.bin radeon/R600_me.bin \
+ 				   radeon/RV610_pfp.bin radeon/RV610_me.bin \
+ 				   radeon/RV630_pfp.bin radeon/RV630_me.bin \
+ 				   radeon/RV620_pfp.bin radeon/RV620_me.bin \
+ 				   radeon/RV635_pfp.bin radeon/RV635_me.bin \
+ 				   radeon/RV670_pfp.bin radeon/RV670_me.bin \
+ 				   radeon/RS780_pfp.bin radeon/RS780_me.bin \
+ 				   radeon/RV770_pfp.bin radeon/RV770_me.bin \
+ 				   radeon/RV730_pfp.bin radeon/RV730_me.bin \
+ 				   radeon/RV710_pfp.bin radeon/RV710_me.bin
  fw-shipped-$(CONFIG_DVB_AV7110) += av7110/bootcode.bin
  fw-shipped-$(CONFIG_DVB_TTUSB_BUDGET) += ttusb-budget/dspbootcode.bin
  fw-shipped-$(CONFIG_E100) += e100/d101m_ucode.bin e100/d101s_ucode.bin \
