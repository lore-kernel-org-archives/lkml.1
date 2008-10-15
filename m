Return-Path: <linux-kernel-owner+w=401wt.eu-S1753336AbYJOJup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336AbYJOJup (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 05:50:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752266AbYJOJug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 05:50:36 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52132 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751969AbYJOJug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 05:50:36 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] metronomefb: Fix warning when building 64bit
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Wed, 15 Oct 2008 10:50:32 +0100
Message-ID: <20081015094859.32708.10705.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The metronome driver produces warnings when built on x86-64 as it assumes that
size_t is an int. Use %Zd instead.

Signed-off-by: Alan Cox <alan@redhat.com>

---

 drivers/video/metronomefb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/drivers/video/metronomefb.c b/drivers/video/metronomefb.c
index afeed06..df1f757 100644
--- a/drivers/video/metronomefb.c
+++ b/drivers/video/metronomefb.c
@@ -188,7 +188,7 @@ static int __devinit load_waveform(u8 *mem, size_t size, int m, int t,
 		epd_frame_table[par->dt].wfm_size = user_wfm_size;
 
 	if (size != epd_frame_table[par->dt].wfm_size) {
-		dev_err(dev, "Error: unexpected size %d != %d\n", size,
+		dev_err(dev, "Error: unexpected size %Zd != %d\n", size,
 					epd_frame_table[par->dt].wfm_size);
 		return -EINVAL;
 	}

