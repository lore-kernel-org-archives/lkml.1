Return-Path: <linux-kernel-owner+w=401wt.eu-S1761446AbYBLAqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761446AbYBLAqj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 19:46:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757646AbYBLApI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 19:45:08 -0500
Received: from pythia.bakeyournoodle.com ([203.82.209.197]:46821 "EHLO
	pythia.bakeyournoodle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758026AbYBLApG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 19:45:06 -0500
Date: Tue, 12 Feb 2008 11:42:51 +1100
To: Toralf =?utf-8?Q?F=C3=B6rster?= <toralf.foerster@gmx.de>
Cc: video4linux-list@redhat.com, linux-kernel@vger.kernel.org,
       Michael Krufky <mkrufky@linuxtv.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: build #345 issue for v2.6.25-rc1 in tuner-core.c
Message-ID: <20080212004251.GT6887@bakeyournoodle.com>
References: <200802111154.31760.toralf.foerster@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200802111154.31760.toralf.foerster@gmx.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: tony@bakeyournoodle.com (Tony Breeds)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2008 at 11:54:31AM +0100, Toralf Förster wrote:
> 
> Hello,
> 
> the build with the attached .config failed, make ending with:
> ...
>   MODPOST vmlinux.o
> WARNING: modpost: Found 12 section mismatch(es).
> To see full details build your kernel with:
> 'make CONFIG_DEBUG_SECTION_MISMATCH=y'
>   GEN     .version
>   CHK     include/linux/compile.h
>   UPD     include/linux/compile.h
>   CC      init/version.o
>   LD      init/built-in.o
>   LD      .tmp_vmlinux1
> drivers/built-in.o: In function `set_type':
> tuner-core.c:(.text+0x8879d): undefined reference to `xc5000_attach'
> make: *** [.tmp_vmlinux1] Error 1

<snip>
Fix Build error for xc5000 tuner when built as module.

Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>

---
Not 100% certain this is correct but it works for me :) Michael?

 drivers/media/dvb/frontends/xc5000.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/frontends/xc5000.h b/drivers/media/dvb/frontends/xc5000.h
index e0e8456..32a5f1c 100644
--- a/drivers/media/dvb/frontends/xc5000.h
+++ b/drivers/media/dvb/frontends/xc5000.h
@@ -45,7 +45,8 @@ struct xc5000_config {
 /* xc5000 callback command */
 #define XC5000_TUNER_RESET		0
 
-#if defined(CONFIG_DVB_TUNER_XC5000) || defined(CONFIG_DVB_TUNER_XC5000_MODULE)
+#if defined(CONFIG_DVB_TUNER_XC5000) || \
+    (defined(CONFIG_DVB_TUNER_XC5000_MODULE) && defined(MODULE))
 extern struct dvb_frontend* xc5000_attach(struct dvb_frontend *fe,
 					  struct i2c_adapter *i2c,
 					  struct xc5000_config *cfg);
