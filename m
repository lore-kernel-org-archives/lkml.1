Return-Path: <linux-kernel-owner+w=401wt.eu-S1757859AbZJFPjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757859AbZJFPjn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 11:39:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756103AbZJFPjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 11:39:42 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:17573 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757316AbZJFPjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 11:39:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=EqA5ZntqHhvMKWXuqSBKIvOSqMsOBUBckzSmkGy7/eWY9erFurQ2PekbCM1v/3KdIk
         rlgV1TWbdBWZInDR7DX3F6mlI3JDnyLiAomyd3/So6nulhXrriDBGISfxXg3YRj8493E
         uQ0So1MHcWEOxL4sd177V/qAPzOzaA/VqMDkQ=
Message-ID: <4ACB6684.5010108@gmail.com>
Date: Tue, 06 Oct 2009 17:47:16 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] ixj: Fix test in ixj_selfprobe()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not makes it a bool before the comparison.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Was below intended?

diff --git a/drivers/telephony/ixj.c b/drivers/telephony/ixj.c
index 40de151..da3c9a0 100644
--- a/drivers/telephony/ixj.c
+++ b/drivers/telephony/ixj.c
@@ -6831,7 +6831,7 @@ static int ixj_selfprobe(IXJ *j)
 	} else {
 		switch (j->cardtype) {
 		case QTI_PHONEJACK:
-			if (!j->dsp.low != 0x20) {
+			if (j->dsp.low != 0x20) {
 				j->dsp.high = 0x80;
 				j->dsp.low = 0x20;
 				ixj_WriteDSPCommand(0x3800, j);
