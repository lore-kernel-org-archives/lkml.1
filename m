Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932168Ab0AONhM (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 08:37:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753641Ab0AONhL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 08:37:11 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:46550 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177Ab0AONhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 08:37:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=TSerXE20qnV2hOOUz3YIWL6XL7Om+4h7X90hBs9Yfoc+GcenD/Gbaw41mDXGKYBOTC
         QR+rHGr1xIv46Ow1vv4rPhr0xo/041IuZB08AcwBySXFi1MDs5lNwRM6Jxh6YA9oZsk2
         KT+/Nc1BU4Ri8QvsJofKKbsYCvKRDqGjLnU/E=
Message-ID: <4B507093.6050002@gmail.com>
Date: Fri, 15 Jan 2010 14:41:39 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: bau_msg_head points to a_queue_first in uv_table_bases_finish()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bau_msg_head should point to bau_msg_head

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Is this correct?

diff --git a/arch/x86/kernel/tlb_uv.c b/arch/x86/kernel/tlb_uv.c
index 364d015..3d66331 100644
--- a/arch/x86/kernel/tlb_uv.c
+++ b/arch/x86/kernel/tlb_uv.c
@@ -691,7 +691,7 @@ uv_table_bases_finish(int blade,
 			continue;
 
 		bcp = (struct bau_control *)&per_cpu(bau_control, cpu);
-		bcp->bau_msg_head	= bau_tablesp->va_queue_first;
+		bcp->bau_msg_head	= bau_tablesp->bau_msg_head;
 		bcp->va_queue_first	= bau_tablesp->va_queue_first;
 		bcp->va_queue_last	= bau_tablesp->va_queue_last;
 		bcp->msg_statuses	= bau_tablesp->msg_statuses;
