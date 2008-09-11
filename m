Return-Path: <linux-kernel-owner+w=401wt.eu-S1755098AbYIKRXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755098AbYIKRXP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 13:23:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752383AbYIKRXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 13:23:00 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:58701 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290AbYIKRXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 13:23:00 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 11 Sep 2008 19:22:53 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: invalid tests on unsigned
To: roel kluin <roel.kluin@gmail.com>
cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
In-Reply-To: <48C685F6.8020108@gmail.com>
Message-ID: <tkrat.bcb8c2523d8a9de4@s5r6.in-berlin.de>
References: <48C685F6.8020108@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On  9 Sep, roel kluin wrote on LKML:
> Using spatch I have found the following occurrences where there is
> an invalid test on an unsigned.
> 
> Some may be not seriously, but just redundant, others may indicate
> an incorrect assumption (that the variable can be negative).
...

 
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: ieee1394: dv1394, video1394: remove unnecessary expressions

init->channel and v.buffer are unsigned and tests for < 0 therefore
always false.  gcc knows this and eliminates the code, but anyway...
Reported by Roel Kluin.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/ieee1394/dv1394.c    |    2 +-
 drivers/ieee1394/video1394.c |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

Index: linux/drivers/ieee1394/dv1394.c
===================================================================
--- linux.orig/drivers/ieee1394/dv1394.c
+++ linux/drivers/ieee1394/dv1394.c
@@ -918,7 +918,7 @@ static int do_dv1394_init(struct video_c
 		/* default SYT offset is 3 cycles */
 		init->syt_offset = 3;
 
-	if ( (init->channel > 63) || (init->channel < 0) )
+	if (init->channel > 63)
 		init->channel = 63;
 
 	chan_mask = (u64)1 << init->channel;
Index: linux/drivers/ieee1394/video1394.c
===================================================================
--- linux.orig/drivers/ieee1394/video1394.c
+++ linux/drivers/ieee1394/video1394.c
@@ -893,7 +893,7 @@ static long video1394_ioctl(struct file 
 		if (unlikely(d == NULL))
 			return -EFAULT;
 
-		if (unlikely((v.buffer<0) || (v.buffer>=d->num_desc - 1))) {
+		if (unlikely(v.buffer >= d->num_desc - 1)) {
 			PRINT(KERN_ERR, ohci->host->id,
 			      "Buffer %d out of range",v.buffer);
 			return -EINVAL;
@@ -959,7 +959,7 @@ static long video1394_ioctl(struct file 
 		if (unlikely(d == NULL))
 			return -EFAULT;
 
-		if (unlikely((v.buffer<0) || (v.buffer>d->num_desc - 1))) {
+		if (unlikely(v.buffer > d->num_desc - 1)) {
 			PRINT(KERN_ERR, ohci->host->id,
 			      "Buffer %d out of range",v.buffer);
 			return -EINVAL;
@@ -1030,7 +1030,7 @@ static long video1394_ioctl(struct file 
 		d = find_ctx(&ctx->context_list, OHCI_ISO_TRANSMIT, v.channel);
 		if (d == NULL) return -EFAULT;
 
-		if ((v.buffer<0) || (v.buffer>=d->num_desc - 1)) {
+		if (v.buffer >= d->num_desc - 1) {
 			PRINT(KERN_ERR, ohci->host->id,
 			      "Buffer %d out of range",v.buffer);
 			return -EINVAL;
@@ -1137,7 +1137,7 @@ static long video1394_ioctl(struct file 
 		d = find_ctx(&ctx->context_list, OHCI_ISO_TRANSMIT, v.channel);
 		if (d == NULL) return -EFAULT;
 
-		if ((v.buffer<0) || (v.buffer>=d->num_desc-1)) {
+		if (v.buffer >= d->num_desc - 1) {
 			PRINT(KERN_ERR, ohci->host->id,
 			      "Buffer %d out of range",v.buffer);
 			return -EINVAL;


-- 
Stefan Richter
-=====-==--- =--= -=-==
http://arcgraph.de/sr/

