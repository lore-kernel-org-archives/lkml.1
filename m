Return-Path: <linux-kernel-owner+w=401wt.eu-S1754989AbZERPLd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989AbZERPLd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 11:11:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751968AbZERPL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 11:11:26 -0400
Received: from mail-pz0-f115.google.com ([209.85.222.115]:46158 "EHLO
	mail-pz0-f115.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951AbZERPLZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 11:11:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=nBpya3eOhHHjGBskm3FGlDQ9Tuzo4ct3Eeg4dp7PTvNq0ixY+KoS7iSpptLYzhhvBf
         jIowuDmEJbU/wpre64hcEtZeP0+invlrhLjE4FUaL0ULfQtZIjGLun+R7mhlNjmBfjwp
         HlaIo+dPYopShOB7RnKfaia6vARqWF5y/Oc9M=
Date: Mon, 18 May 2009 23:11:15 +0800
From: Ming Lei <tom.leiming@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, rostedt@goodmis.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu
Subject: Re: [PATCH] ftrace:fix check for return value of
 register_module_notifier
Message-ID: <20090518231115.1cd598a2@linux-lm>
In-Reply-To: <20090518142507.GE4704@nowhere>
References: <1242545498-7285-1-git-send-email-tom.leiming@gmail.com>
	<4A10B1B4.5080309@cn.fujitsu.com>
	<20090518203957.0bc1eff8@linux-lm>
	<20090518142507.GE4704@nowhere>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.4; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch fixes another check in event_trace_init.
Thanks.

>From 121f44b1658c137b8404756fdbd97dcf1d0c58f9 Mon Sep 17 00:00:00 2001
From: Ming Lei <tom.leiming@gmail.com>
Date: Mon, 18 May 2009 23:04:46 +0800
Subject: [PATCH] ftrace:fix check for return value of register_module_notifier in event_trace_init

return zero should be correct, so fix it.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
Reported-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace_events.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 0eec0c5..9e91c4a 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1174,7 +1174,7 @@ static __init int event_trace_init(void)
 	}
 
 	ret = register_module_notifier(&trace_module_nb);
-	if (!ret)
+	if (ret)
 		pr_warning("Failed to register trace events module notifier\n");
 
 	return 0;
-- 
1.6.0.GIT


-- 
Lei Ming
