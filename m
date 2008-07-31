Return-Path: <linux-kernel-owner+w=401wt.eu-S1757524AbYGaTVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757524AbYGaTVQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 15:21:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754154AbYGaTU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 15:20:56 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:55120 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753516AbYGaTUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 15:20:55 -0400
Date: Thu, 31 Jul 2008 20:20:33 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Andrew Morton <akpm@linux-foundation.org>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, bzolnier@gmail.com,
       sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: linux-next: Tree for July 30
In-Reply-To: <20080731115538.238b5e75.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0807312013460.7388@blonde.site>
References: <20080730170635.f737ffe9.sfr@canb.auug.org.au>
 <20080730231029.9818953c.akpm@linux-foundation.org> <20080731140708.GA11229@core.corenet.prv>
 <58cb370e0807310836x4a6e3c40rf5c3c8ec8b5caae0@mail.gmail.com>
 <20080731115301.ZZRA012@mailhub.coreip.homeip.net>
 <20080731104437.5e5669bc.akpm@linux-foundation.org>
 <20080731141302.ZZRA012@mailhub.coreip.homeip.net>
 <20080731112654.d9620b36.akpm@linux-foundation.org>
 <20080731143013.ZZRA012@mailhub.coreip.homeip.net>
 <20080731115538.238b5e75.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jul 2008, Andrew Morton wrote:
> On Thu, 31 Jul 2008 14:34:41 -0400
> Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> > > 
> > > Where would I (Aunt Tillie running FC5) go to find out how to fix my
> > > machine up again? 
> > 
> > What is Aunt Tillie doing compiling her own kernels on FC5? You
> > OTOH managed to get an answer fairly quickly ;)
> 
> I'll ask again: where do our users go to find out how to make their X
> server work again?  If the answer is "nowhere" then can we please at 
> least write up a simple step-by-step repair procedure, as we'll surely
> be needing it a lot.

Thanks for pursuing this, Andrew: here's a kernel patch deduced
from this thread, which has indeed got me moving again.  Perhaps
an optional patch for hotfixes while the right answer is decided.


If you want to test 2.6.27-rc1-mm1, but your Synaptics pad is making X
crash immediately, and like Aunt Tillie and me you're more comfortable
patching your kernel than messing around in your userspace,
then reverting back from 768 to 512 keys should help.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---

 include/linux/input.h           |    2 +-
 include/linux/mod_devicetable.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- 2.6.27-rc1-mm1/include/linux/input.h	2008-07-31 09:30:09.000000000 +0100
+++ linux/include/linux/input.h	2008-07-31 19:39:20.000000000 +0100
@@ -592,7 +592,7 @@ struct input_absinfo {
 
 /* We avoid low common keys in module aliases so they don't get huge. */
 #define KEY_MIN_INTERESTING	KEY_MUTE
-#define KEY_MAX			0x2ff
+#define KEY_MAX			0x1ff
 #define KEY_CNT			(KEY_MAX+1)
 
 /*
--- 2.6.27-rc1-mm1/include/linux/mod_devicetable.h	2008-07-31 09:30:09.000000000 +0100
+++ linux/include/linux/mod_devicetable.h	2008-07-31 19:43:19.000000000 +0100
@@ -274,7 +274,7 @@ struct pcmcia_device_id {
 /* Input */
 #define INPUT_DEVICE_ID_EV_MAX		0x1f
 #define INPUT_DEVICE_ID_KEY_MIN_INTERESTING	0x71
-#define INPUT_DEVICE_ID_KEY_MAX		0x2ff
+#define INPUT_DEVICE_ID_KEY_MAX		0x1ff
 #define INPUT_DEVICE_ID_REL_MAX		0x0f
 #define INPUT_DEVICE_ID_ABS_MAX		0x3f
 #define INPUT_DEVICE_ID_MSC_MAX		0x07
