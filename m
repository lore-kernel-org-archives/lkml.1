Return-Path: <linux-kernel-owner+w=401wt.eu-S1757151AbYEKMw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757151AbYEKMw3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 08:52:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756968AbYEKMwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 08:52:14 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:59293 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756950AbYEKMwM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 08:52:12 -0400
Date: Sun, 11 May 2008 14:52:09 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: perex@perex.cz, ricardo@scarybox.net, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 4/4] sound/usb: use unsigned for loop index
Message-ID: <Pine.LNX.4.64.0805111451380.29620@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

A few more cases in the spirit of the patch "Trivial: Replacement of always
>0 ints with unsigned ints" submitted by Ricardo Martins <ricardo@scarybox.net>

The transformation was made using the following semantic patch
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r exists@ // find anything that might decrement the variable
identifier i;
expression E;
position p;
@@

  int i@p;
  ...
(
  &i
|
  i--
|
  --i
|
  i-=E
|
  i+=E
)

@x disable decl_init@
identifier r.i;
expression E;
position p1 != r.p;
@@

(
  volatile int i = 0;
|
  volatile int i;
|
+ unsigned
  int i@p1 = 0;
|
+ unsigned
  int i@p1;
)
  <... when != i = E      
(
  i = 0
|
  i = 1
)
  ...>
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---

 sound/usb/usbaudio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p a/sound/usb/usbaudio.c b/sound/usb/usbaudio.c
--- a/sound/usb/usbaudio.c 2008-04-27 11:41:12.000000000 +0200
+++ b/sound/usb/usbaudio.c 2008-05-11 12:20:14.000000000 +0200
@@ -2835,7 +2835,7 @@ static int parse_audio_endpoints(struct 
  */
 static void snd_usb_stream_disconnect(struct list_head *head)
 {
-	int idx;
+	unsigned int idx;
 	struct snd_usb_stream *as;
 	struct snd_usb_substream *subs;
 
