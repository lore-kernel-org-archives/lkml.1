Return-Path: <linux-kernel-owner+w=401wt.eu-S1763382AbZAULDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763382AbZAULDT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 06:03:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755877AbZAULDG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 06:03:06 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55211 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755864AbZAULDE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 06:03:04 -0500
Date: Wed, 21 Jan 2009 12:02:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, brgerst@gmail.com,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCHSET linux-2.6-x86:core/percpu] x86: misc clean up and
	unify x86_32/64 code paths
Message-ID: <20090121110248.GA21659@elte.hu>
References: <1232527578-1960-1-git-send-email-tj@kernel.org> <20090121092633.GA22506@elte.hu> <20090121093509.GA31613@elte.hu> <20090121104311.GA15947@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090121104311.GA15947@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
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

> This one was needed as well.
> 
> 	Ingo
> 
> ------------------->
> From 61e0178cf01b4acc914e9653b421e925f22be0cd Mon Sep 17 00:00:00 2001
> From: Ingo Molnar <mingo@elte.hu>
> Date: Wed, 21 Jan 2009 11:30:07 +0100
> Subject: [PATCH] x86: uv cleanup, build fix #2
> 
> Fix more build-failure fallout from the UV cleanup - the UV drivers
> were not updated to include <asm/uv/uv.h>.
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  drivers/misc/sgi-gru/grufile.c |    1 +
>  drivers/misc/sgi-xp/xp_main.c  |    2 ++
>  drivers/misc/sgi-xp/xp_uv.c    |    1 +
>  3 files changed, 4 insertions(+), 0 deletions(-)

i went for this solution instead - it covers more .c files and is the 
right thing to do as well.

	Ingo

----------------->
>From 5b221278d61e3907a5e4104a844b63bc8bb3d43a Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Wed, 21 Jan 2009 11:30:07 +0100
Subject: [PATCH] x86: uv cleanup, build fix #2

Fix more build-failure fallout from the UV cleanup - the UV drivers
were not updated to include <asm/uv/uv.h>.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/misc/sgi-gru/gru.h |    2 ++
 drivers/misc/sgi-xp/xp.h   |    2 ++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/misc/sgi-gru/gru.h b/drivers/misc/sgi-gru/gru.h
index f93f03a..1b5f579 100644
--- a/drivers/misc/sgi-gru/gru.h
+++ b/drivers/misc/sgi-gru/gru.h
@@ -19,6 +19,8 @@
 #ifndef __GRU_H__
 #define __GRU_H__
 
+#include <asm/uv/uv.h>
+
 /*
  * GRU architectural definitions
  */
diff --git a/drivers/misc/sgi-xp/xp.h b/drivers/misc/sgi-xp/xp.h
index 7b4cbd5..069ad3a 100644
--- a/drivers/misc/sgi-xp/xp.h
+++ b/drivers/misc/sgi-xp/xp.h
@@ -15,6 +15,8 @@
 
 #include <linux/mutex.h>
 
+#include <asm/uv/uv.h>
+
 #ifdef CONFIG_IA64
 #include <asm/system.h>
 #include <asm/sn/arch.h>	/* defines is_shub1() and is_shub2() */
