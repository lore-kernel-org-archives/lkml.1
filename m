Return-Path: <linux-kernel-owner+w=401wt.eu-S1759227AbYEXGSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759227AbYEXGSk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 02:18:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755051AbYEXGSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 02:18:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:53449 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755017AbYEXGS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 02:18:29 -0400
Date: Sat, 24 May 2008 02:18:28 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Clark Williams <clark.williams@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH RT] remove user_trace_stop
Message-ID: <Pine.LNX.4.58.0805240217130.1841@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ Doing a full config compile I came up with this ]

Remove user_trace_stop that was more of a hack to debug xrun latencies.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 sound/core/pcm_lib.c |    1 -
 1 file changed, 1 deletion(-)

Index: linux-2.6.24.7-rt10/sound/core/pcm_lib.c
===================================================================
--- linux-2.6.24.7-rt10.orig/sound/core/pcm_lib.c	2008-05-24 00:53:24.000000000 -0400
+++ linux-2.6.24.7-rt10/sound/core/pcm_lib.c	2008-05-24 01:57:44.000000000 -0400
@@ -131,7 +131,6 @@ static void xrun(struct snd_pcm_substrea
 	snd_pcm_stop(substream, SNDRV_PCM_STATE_XRUN);
 #ifdef CONFIG_SND_PCM_XRUN_DEBUG
 	if (substream->pstr->xrun_debug) {
-		user_trace_stop();
 		snd_printd(KERN_DEBUG "XRUN: pcmC%dD%d%c\n",
 			   substream->pcm->card->number,
 			   substream->pcm->device,

