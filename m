Return-Path: <linux-kernel-owner+w=401wt.eu-S934439AbXHXAXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934439AbXHXAXb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 20:23:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965129AbXHXAW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 20:22:58 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:44462 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965119AbXHXAW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 20:22:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:resent-from:resent-to:resent-date:resent-message-id:message-id:in-reply-to:references:from:date:subject:to:cc:mime-version:content-transfer-encoding:content-disposition;
        b=ufSqW6PkPVuilST+NL32KV5KymORgt0Ua38ssVR9iFPlDoUG5GhLanaaBmy44TNOmwsvL7RnkQO8CHZQXjI+fwrSebeXiqlARtqIL4A78lKkLBz3mpvSBamWsJ6RLGV6qqPMj93Ja9v4cb8enujtoykG+RdyxB+3tvGrsy5dKok=
Message-Id: <6e3f66d353155af12b075c2e919066908a2ce44c.1187912217.git.jesper.juhl@gmail.com>
In-Reply-To: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com>
References: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com>
From: Jesper Juhl <jesper.juhl@gmail.com>
Date: Fri, 24 Aug 2007 02:20:04 +0200
Subject: [PATCH 22/30] ivtv: kzalloc() returns void pointer, no need to cast
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Kevin Thayer <nufan_wfk@yahoo.com>, Chris Kennedy <c@groovy.org>,
       Hans Verkuil <hverkuil@xs4all.nl>, video4linux-list@redhat.com,
       Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Since kzalloc() returns a void pointer, we don't need to cast the
return value in drivers/media/video/ivtv/ivtv-queue.c

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---
 drivers/media/video/ivtv/ivtv-queue.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/ivtv/ivtv-queue.c b/drivers/media/video/ivtv/ivtv-queue.c
index a04f938..45825b8 100644
--- a/drivers/media/video/ivtv/ivtv-queue.c
+++ b/drivers/media/video/ivtv/ivtv-queue.c
@@ -196,7 +196,7 @@ int ivtv_stream_alloc(struct ivtv_stream *s)
 		s->name, s->buffers, s->buf_size, s->buffers * s->buf_size / 1024);
 
 	if (ivtv_might_use_pio(s)) {
-		s->PIOarray = (struct ivtv_SG_element *)kzalloc(SGsize, GFP_KERNEL);
+		s->PIOarray = kzalloc(SGsize, GFP_KERNEL);
 		if (s->PIOarray == NULL) {
 			IVTV_ERR("Could not allocate PIOarray for %s stream\n", s->name);
 			return -ENOMEM;
@@ -204,7 +204,7 @@ int ivtv_stream_alloc(struct ivtv_stream *s)
 	}
 
 	/* Allocate DMA SG Arrays */
-	s->SGarray = (struct ivtv_SG_element *)kzalloc(SGsize, GFP_KERNEL);
+	s->SGarray = kzalloc(SGsize, GFP_KERNEL);
 	if (s->SGarray == NULL) {
 		IVTV_ERR("Could not allocate SGarray for %s stream\n", s->name);
 		if (ivtv_might_use_pio(s)) {
-- 
1.5.2.2

