Return-Path: <linux-kernel-owner+w=401wt.eu-S1755242AbZG2NDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242AbZG2NDi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 09:03:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754888AbZG2NDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 09:03:37 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:2614 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754729AbZG2NDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 09:03:37 -0400
Subject: Re: [PATCH 4/4] Staging: hv: Fix warning by casting a (const void
 *) to (void *)
From: Joe Perches <joe@perches.com>
To: Nicolas Palix <npalix@diku.dk>
Cc: gregkh@suse.de, hjanssen@microsoft.com, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <200907291410.29355.npalix@diku.dk>
References: <200907291410.29355.npalix@diku.dk>
Content-Type: text/plain
Date: Wed, 29 Jul 2009 06:03:28 -0700
Message-Id: <1248872608.3493.26.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-29 at 14:10 +0200, Nicolas Palix wrote: 
> Fix compilation warning by casting the const void *Buffer
> variable into a void *.
> diff --git a/drivers/staging/hv/Channel.c b/drivers/staging/hv/Channel.c
> index 68f3442..854fa30 100644
> --- a/drivers/staging/hv/Channel.c
> +++ b/drivers/staging/hv/Channel.c
> @@ -787,7 +787,7 @@ VmbusChannelSendPacket(
>  	bufferList[0].Data = &desc;
>  	bufferList[0].Length = sizeof(VMPACKET_DESCRIPTOR);
>  
> -	bufferList[1].Data = Buffer;
> +	bufferList[1].Data = (void *)Buffer;
>  	bufferList[1].Length = BufferLen;

Perhaps this is better?

diff --git a/drivers/staging/hv/RingBuffer.c b/drivers/staging/hv/RingBuffer.c
index 6a9f568..fa40f46 100644
--- a/drivers/staging/hv/RingBuffer.c
+++ b/drivers/staging/hv/RingBuffer.c
@@ -228,7 +228,7 @@ static u32
 CopyToRingBuffer(
 	RING_BUFFER_INFO	*RingInfo,
 	u32				StartWriteOffset,
-	void *				Src,
+	const void *			Src,
 	u32				SrcLen);
 
 static u32
@@ -559,7 +559,7 @@ u32
 CopyToRingBuffer(
 	RING_BUFFER_INFO	*RingInfo,
 	u32				StartWriteOffset,
-	void *				Src,
+	const void *			Src,
 	u32				SrcLen)
 {
 	void * ringBuffer=GetRingBuffer(RingInfo);
diff --git a/drivers/staging/hv/RingBuffer.h b/drivers/staging/hv/RingBuffer.h
index a0b6e0e..4cea2af 100644
--- a/drivers/staging/hv/RingBuffer.h
+++ b/drivers/staging/hv/RingBuffer.h
@@ -28,7 +28,7 @@
 #include "include/osd.h"
 
 typedef struct _SG_BUFFER_LIST {
-	void *	Data;
+	const void *Data;
 	u32	Length;
 } SG_BUFFER_LIST;
 


