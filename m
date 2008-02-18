Return-Path: <linux-kernel-owner+w=401wt.eu-S1761881AbYBRWDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761881AbYBRWDU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 17:03:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752935AbYBRWDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 17:03:12 -0500
Received: from an-out-0708.google.com ([209.85.132.244]:15006 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbYBRWDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 17:03:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=fuEsruuCoXYBo0hBBlRsP3ImfXf7tUphn/wrUXgRhz4V4/1cfsV4SGp/qyJctHHaFoie1ceulCTd1vGreRYo1BRfO5sotJSQpDwWZSjqfsjH7cbKozvC6+bPd5e1jIqek2iBp2ole2aWohjPPYjvr+oZAx4MTCBrGtey2kniR5Y=
Message-ID: <97a0a9ac0802181403ja79c32v864b093414b2755@mail.gmail.com>
Date: Mon, 18 Feb 2008 15:03:10 -0700
From: "Gordon Farquharson" <gordonfarquharson@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [RFC] [PATCH] Fix b43 driver build for arm
Cc: linville@tuxdriver.com, mb@bu3sch.de, stefano.brivio@polimi.it,
       rmk@arm.linux.org.uk
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The b43 driver in 2.6.25-rc[12] fails to build for arm on an x86_64
box using a cross-compiler:

FATAL: drivers/net/wireless/b43/b43: sizeof(struct ssb_device_id)=6 is
not a modulo of the size of section __mod_ssb_device_table=64.
Fix definition of struct ssb_device_id in mod_devicetable.h

The following patch fixes the build, but given the discussion in
regarding the fix for the module device table definition for m68k [1],
I'm not sure that this patch is the right thing to do. However, the
fix for m68k was implemented in 2.6.25 [2].

diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index 139d49d..0471294 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -351,7 +351,8 @@ struct sdio_device_id {
 struct ssb_device_id {
 	__u16	vendor;
 	__u16	coreid;
-	__u8	revision;
+	__u8	revision
+		__attribute__((aligned(sizeof(__u32))));
 };
 #define SSB_DEVICE(_vendor, _coreid, _revision)  \
 	{ .vendor = _vendor, .coreid = _coreid, .revision = _revision, }

Please CC me on replies as I'm not subscribed to the list.

Gordon

[1] http://lkml.org/lkml/2007/11/28/12
[2] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=7492d4a416d68ab4bd254b36ffcc4e0138daa8ff

-- 
Gordon Farquharson
GnuPG Key ID: 32D6D676
