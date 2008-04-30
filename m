Return-Path: <linux-kernel-owner+w=401wt.eu-S1760940AbYD3Hsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760940AbYD3Hsl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 03:48:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756377AbYD3Hsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 03:48:32 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50507 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755682AbYD3Hsb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 03:48:31 -0400
Date: Wed, 30 Apr 2008 09:48:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: [patch, -git] drivers/media build fix for modular builds
Message-ID: <20080430074807.GA11224@elte.hu>
References: <20080429185009.716c3284@gaivota>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080429185009.716c3284@gaivota>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix allmodconfig build bug introduced in latest -git by commit 
7c91f0624a9 ("V4L/DVB(7767): Move tuners to common/tuners"):

  LD      kernel/built-in.o
  LD      drivers/built-in.o
  ld: drivers/media/built-in.o: No such file: No such file or directory

which happens if all media drivers are modular:

  http://redhat.com/~mingo/misc/config-Wed_Apr_30_09_24_48_CEST_2008.bad

In that case there's no obj-y rule connecting all the built-in.o files and
the link tree breaks.

the fix is to add a guaranteed obj-y rule for the core vmlinux to build.
(which results in an empty object file if all media drivers are modular)

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/media/Makefile |    2 ++
 1 file changed, 2 insertions(+)

Index: linux/drivers/media/Makefile
===================================================================
--- linux.orig/drivers/media/Makefile
+++ linux/drivers/media/Makefile
@@ -2,6 +2,8 @@
 # Makefile for the kernel multimedia device drivers.
 #
 
+obj-y := common/
+
 obj-$(CONFIG_VIDEO_MEDIA) += common/
 
 # Since hybrid devices are here, should be compiled if DVB and/or V4L
