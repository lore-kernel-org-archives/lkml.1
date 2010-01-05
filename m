Return-Path: <linux-kernel-owner+w=401wt.eu-S1755453Ab0AEUGL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453Ab0AEUGL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 15:06:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755424Ab0AEUF6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 15:05:58 -0500
Received: from kroah.org ([198.145.64.141]:49927 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755416Ab0AEUF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 15:05:57 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan  5 12:02:59 2010
Message-Id: <20100105200259.042133835@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 05 Jan 2010 12:01:58 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable-review@kernel.org
Cc: Eric Millbrandt <emillbrandt@dekaresearch.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [02/39] ASoC: Do not write to invalid registers on the wm9712.
In-Reply-To: <20100105195007.GA23952@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eric Millbrandt <emillbrandt@dekaresearch.com>

commit 48e3cbb3f67a27d9c2db075f3d0f700246c40caa upstream.

This patch fixes a bug where "virtual" registers were being written to the ac97
bus.  This was causing unrelated registers to become corrupted (headphone 0x04,
touchscreen 0x78, etc).

This patch duplicates protection that was included in the wm9713 driver.

Signed-off-by: Eric Millbrandt <emillbrandt@dekaresearch.com>
Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/codecs/wm9712.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/sound/soc/codecs/wm9712.c
+++ b/sound/soc/codecs/wm9712.c
@@ -464,7 +464,8 @@ static int ac97_write(struct snd_soc_cod
 {
 	u16 *cache = codec->reg_cache;
 
-	soc_ac97_ops.write(codec->ac97, reg, val);
+	if (reg < 0x7c)
+		soc_ac97_ops.write(codec->ac97, reg, val);
 	reg = reg >> 1;
 	if (reg < (ARRAY_SIZE(wm9712_reg)))
 		cache[reg] = val;


