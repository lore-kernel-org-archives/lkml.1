Return-Path: <linux-kernel-owner+w=401wt.eu-S1760680AbZAIXlm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760680AbZAIXlm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 18:41:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932316AbZAIXjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 18:39:24 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:52863 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758833AbZAIXjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 18:39:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:to:from:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=CqXCQ00JoQ8n7pc4Ff6s6qcCHAYrEHzqUM938lVqvqRXDQBwjr5ySywBb47LOu8JXh
         14S12iZjjkTD8IyxUaRe/HqgyjDs33n/ZZGJ30eUiwjRAKY2mSsq4Y0uzE6Bfpgsiu9o
         ZsYDU8uT7f9c3TssjyR2zvP/qvm+KvgAQ4dyw=
Subject: [PATCH 5/5] Fix dubious bitwise 'and' usage spotted by sparse.
To: LKML <linux-kernel@vger.kernel.org>
From: Alexey Zaytsev <alexey.zaytsev@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Trivial Kernel Patches <trivial@kernel.org>
Date: Sat, 10 Jan 2009 02:48:28 +0300
Message-ID: <20090109234828.11800.10915.stgit@zaytsev.su>
In-Reply-To: <20090109234113.11800.55672.stgit@zaytsev.su>
References: <20090109234113.11800.55672.stgit@zaytsev.su>
User-Agent: StGit/0.14.3.292.gb975
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It doesn't change the semantics, but clearly
the logical 'and' was meant to be used here.

Signed-off-by: Alexey Zaytsev <alexey.zaytsev@gmail.com>
---
 drivers/usb/wusbcore/security.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/wusbcore/security.c b/drivers/usb/wusbcore/security.c
index a101cad..8f953ab 100644
--- a/drivers/usb/wusbcore/security.c
+++ b/drivers/usb/wusbcore/security.c
@@ -626,7 +626,7 @@ void wusbhc_gtk_rekey(struct wusbhc *wusbhc)
 		struct wusb_dev *wusb_dev;
 
 		wusb_dev = wusbhc->port[p].wusb_dev;
-		if (!wusb_dev || !wusb_dev->usb_dev | !wusb_dev->usb_dev->authenticated)
+		if (!wusb_dev || !wusb_dev->usb_dev || !wusb_dev->usb_dev->authenticated)
 			continue;
 
 		usb_fill_control_urb(wusb_dev->set_gtk_urb, wusb_dev->usb_dev,

