Return-Path: <linux-kernel-owner+w=401wt.eu-S1754982AbXKSS02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982AbXKSS02 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 13:26:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751538AbXKSSWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 13:22:16 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:49256 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104AbXKSSWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 13:22:14 -0500
Date: Mon, 19 Nov 2007 10:19:03 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       Maarten Bressers <mbressers@gmail.com>,
       gentoo kernel <kernel@gentoo.org>
Subject: [patch 13/26] ALSA: hdsp - Fix zero division
Message-ID: <20071119181903.GN15425@kroah.com>
References: <20071119181438.617190424@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="alsa-hdsp-fix-zero-division.patch"
In-Reply-To: <20071119181746.GA15425@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Takashi Iwai <tiwai@suse.de>

patch 2a3988f6d2c5be9d02463097775d1c66a8290527 in mainline.

Fix zero-division bug in the calculation dds offset.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Jaroslav Kysela <perex@perex.cz>
Cc: Maarten Bressers <mbressers@gmail.com>
Cc: gentoo kernel <kernel@gentoo.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/rme9652/hdsp.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/sound/pci/rme9652/hdsp.c
+++ b/sound/pci/rme9652/hdsp.c
@@ -3108,6 +3108,9 @@ static int hdsp_dds_offset(struct hdsp *
 	unsigned int dds_value = hdsp->dds_value;
 	int system_sample_rate = hdsp->system_sample_rate;
 
+	if (!dds_value)
+		return 0;
+
 	n = DDS_NUMERATOR;
 	/*
 	 * dds_value = n / rate

-- 
