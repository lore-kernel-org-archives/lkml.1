Return-Path: <linux-kernel-owner+w=401wt.eu-S1754730AbYGVRUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730AbYGVRUp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 13:20:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754426AbYGVRUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 13:20:25 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:39640 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754326AbYGVRUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 13:20:24 -0400
Date: Tue, 22 Jul 2008 20:20:12 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: ivtv-devel@ivtvdriver.org, v4l-dvb-maintainer@linuxtv.org,
       linux-kernel@vger.kernel.org
Subject: [2.6 patch] make ivtv_claim_stream() static
Message-ID: <20080722172012.GL14846@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ivtv_claim_stream() can now become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/media/video/ivtv/ivtv-fileops.c |    2 +-
 drivers/media/video/ivtv/ivtv-fileops.h |    5 -----
 2 files changed, 1 insertion(+), 6 deletions(-)

b37d68a97cbf9a53c753bb0d63a3b1e8380ea51c 
diff --git a/drivers/media/video/ivtv/ivtv-fileops.c b/drivers/media/video/ivtv/ivtv-fileops.c
index 7ec5c99..304261e 100644
--- a/drivers/media/video/ivtv/ivtv-fileops.c
+++ b/drivers/media/video/ivtv/ivtv-fileops.c
@@ -39,7 +39,7 @@
    associated VBI streams are also automatically claimed.
    Possible error returns: -EBUSY if someone else has claimed
    the stream or 0 on success. */
-int ivtv_claim_stream(struct ivtv_open_id *id, int type)
+static int ivtv_claim_stream(struct ivtv_open_id *id, int type)
 {
 	struct ivtv *itv = id->itv;
 	struct ivtv_stream *s = &itv->streams[type];
diff --git a/drivers/media/video/ivtv/ivtv-fileops.h b/drivers/media/video/ivtv/ivtv-fileops.h
index 2c8d518..df81e79 100644
--- a/drivers/media/video/ivtv/ivtv-fileops.h
+++ b/drivers/media/video/ivtv/ivtv-fileops.h
@@ -38,11 +38,6 @@ void ivtv_unmute(struct ivtv *itv);
 
 /* Utilities */
 
-/* Try to claim a stream for the filehandle. Return 0 on success,
-   -EBUSY if stream already claimed. Once a stream is claimed, it
-   remains claimed until the associated filehandle is closed. */
-int ivtv_claim_stream(struct ivtv_open_id *id, int type);
-
 /* Release a previously claimed stream. */
 void ivtv_release_stream(struct ivtv_stream *s);
 

