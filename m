Return-Path: <linux-kernel-owner+w=401wt.eu-S1761253AbZLOVx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761253AbZLOVx5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 16:53:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761241AbZLOVx4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 16:53:56 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:51546 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761239AbZLOVxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 16:53:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=dsRE1k2UqeWI/ZlkYt2p8JTD0pCR7LrrFFtMK8Hh0IM5KPktuFblSpTLtOSViIcIji
         HHo8Jqna+sABegJnYVLhyNI03A5/OJpLVIlmRnUH0vGABPKKbn2ZMl8b9ZyXOtBgU95f
         nwQfO/gEnHvrV9TwP+YjkxRgWKXk+sMC6vMKE=
Message-ID: <4B2805E0.2080304@gmail.com>
Date: Tue, 15 Dec 2009 22:55:44 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: drbd-dev@lists.linbit.com, drbd-user@lists.linbit.com,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] drbd: Fix test of unsigned in _drbd_fault_random()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rsp->count is unsigned so the test does not work.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Found using coccinelle: http://coccinelle.lip6.fr/

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 157d1e4..c2594c1 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -3623,7 +3623,7 @@ _drbd_fault_random(struct fault_random_state *rsp)
 {
 	long refresh;
 
-	if (--rsp->count < 0) {
+	if (!rsp->count--) {
 		get_random_bytes(&refresh, sizeof(refresh));
 		rsp->state += refresh;
 		rsp->count = FAULT_RANDOM_REFRESH;
