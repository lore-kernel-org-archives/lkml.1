Return-Path: <linux-kernel-owner+w=401wt.eu-S1763944AbZLQCNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763944AbZLQCNu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 21:13:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758595AbZLQCNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 21:13:49 -0500
Received: from cgp-fe01.mtu.ru ([62.5.255.15]:59856 "EHLO umail.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758328AbZLQCNs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 21:13:48 -0500
From: Pavel Vasilyev <pavel@pavlinux.ru>
Organization: Pavlinux. Inc
To: linux-kernel@vger.kernel.org
Subject: HTC Dream camera, not need sizeof
Date: Thu, 17 Dec 2009 05:13:45 +0300
User-Agent: KMail/1.12.4 (Linux/2.6.32; KDE/4.3.4; x86_64; ; )
X-Face: $dO4505L-bM3\Iz"(
 =?utf-8?q?V=3Dy=2EbL/75=7B5ys3=3AB=5B-aPBQvs*Z=25fdBqFhvc85hmZN4j1kwRzwvY*?=
 =?utf-8?q?R=0A=094=09nvQ/=23/+kWXH?=((aXWh\%mvG1V()Z0k:NwZAIu\S0d1%,nv`^
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200912170513.45388@PAVLINUX->
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

        http://bugzilla.kernel.org/show_bug.cgi?id=14825


  On line 258,  sizeof(extlen), always will be sizeof( unit32_t) or 4  

  It seems that something is wrong?!?!  :)


Original 

 255    extlen = sizeof(struct vfe_frame_extra);
 256
 257        extdata =
 258                kmalloc(sizeof(extlen), GFP_ATOMIC);

is equal         kmalloc(sizeof(uint32_t), GFP_ATOMIC);
But then do not need to calculate the size of the structure - 
sizeof(vfe_frame_extra) ???

 259        if (!extdata) {
 260                rc = -ENOMEM;
 261                goto init_fail;

---------------------
May be next?


diff --git a/drivers/staging/dream/camera/msm_vfe7x.c 
b/drivers/staging/dream/camera/msm_vfe7x.c
index 33ab3ac..4d39848 100644
--- a/drivers/staging/dream/camera/msm_vfe7x.c
+++ b/drivers/staging/dream/camera/msm_vfe7x.c
@@ -256,7 +256,7 @@ static int vfe_7x_init(struct msm_vfe_callback *presp,
        extlen = sizeof(struct vfe_frame_extra);

        extdata =
-               kmalloc(sizeof(extlen), GFP_ATOMIC);
+               kmalloc(extlen, GFP_ATOMIC);
        if (!extdata) {
                rc = -ENOMEM;
                goto init_fail;
