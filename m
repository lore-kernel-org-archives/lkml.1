Return-Path: <linux-kernel-owner+w=401wt.eu-S965616AbYD1VXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965616AbYD1VXv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 17:23:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761451AbYD1VXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 17:23:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39427 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754032AbYD1VXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 17:23:42 -0400
Date: Mon, 28 Apr 2008 23:23:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] dvb: build failure fix
Message-ID: <20080428212329.GA11067@elte.hu>
References: <20080428162421.GA16566@elte.hu> <20080428164730.43349c3d@gaivota> <20080428203056.GI15840@elte.hu> <20080428180327.7f6f5204@gaivota> <20080428211748.GJ15840@elte.hu> <20080428212030.GA10912@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080428212030.GA10912@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

>   http://redhat.com/~mingo/misc/config-Mon_Apr_28_23_14_46_CEST_2008.bad
> 
> build log below. Note that this seems to be a more clear-cut case as 
> module support was disabled.

ok, found one bug, find the fix for that below. One more bug to go:

drivers/built-in.o: In function `cx23885_dvb_register':
: undefined reference to `dib7000p_attach'

	Ingo

-------------->
Subject: dvb: fix3
From: Ingo Molnar <mingo@elte.hu>
Date: Mon Apr 28 23:22:13 CEST 2008

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/media/video/cx23885/Kconfig |    1 +
 1 file changed, 1 insertion(+)

Index: linux/drivers/media/video/cx23885/Kconfig
===================================================================
--- linux.orig/drivers/media/video/cx23885/Kconfig
+++ linux/drivers/media/video/cx23885/Kconfig
@@ -9,6 +9,7 @@ config VIDEO_CX23885
 	select VIDEO_IR
 	select VIDEOBUF_DVB
 	select VIDEO_CX25840
+	select VIDEO_CX2341X
 	select DVB_TUNER_MT2131 if !DVB_FE_CUSTOMISE
 	select DVB_S5H1409 if !DVB_FE_CUSTOMISE
 	select DVB_LGDT330X if !DVB_FE_CUSTOMISE
