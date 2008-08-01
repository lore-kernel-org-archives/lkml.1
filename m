Return-Path: <linux-kernel-owner+w=401wt.eu-S1760255AbYHAVDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760255AbYHAVDh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 17:03:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759472AbYHAVDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 17:03:12 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:52251 "EHLO
	SG2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758664AbYHAVDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 17:03:10 -0400
X-BigFish: VPS-6(zz655Ozz10d3izzz2fh6bh8ah66h)
X-Spam-TCS-SCL: 5:0
Message-ID: <48937AAE.5070407@am.sony.com>
Date: Fri, 1 Aug 2008 14:05:50 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: linux-embedded <linux-embedded@vger.kernel.org>
CC: linux kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] embedded: fix vc_translate operator precedence
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Aug 2008 21:02:56.0213 (UTC) FILETIME=[F8980050:01C8F419]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a bug in operator precedence in the newly introduced vc_translate
macro.  Without this fix, the translation of some characters on the
kernel console is garbled.

This patch was copied to the e-mail list previously for testing.  Now,
all reports confirm that it works, so this is an official post for
application.

Signed-off-by: Tim Bird <tim.bird@am.sony.com>
---
 vt_kern.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/vt_kern.h b/include/linux/vt_kern.h
index 14c0e91..8c8119f 100644
--- a/include/linux/vt_kern.h
+++ b/include/linux/vt_kern.h
@@ -74,7 +74,7 @@ void con_protect_unimap(struct vc_data *vc, int rdonly);
 int con_copy_unimap(struct vc_data *dst_vc, struct vc_data *src_vc);

 #define vc_translate(vc, c) ((vc)->vc_translate[(c) |			\
-					(vc)->vc_toggle_meta ? 0x80 : 0])
+					((vc)->vc_toggle_meta ? 0x80 : 0)])
 #else
 #define con_set_trans_old(arg) (0)
 #define con_get_trans_old(arg) (-EINVAL)

