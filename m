Return-Path: <linux-kernel-owner+w=401wt.eu-S934486AbYEBMs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934486AbYEBMs7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 08:48:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760161AbYEBMsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 08:48:53 -0400
Received: from mail.ift.unesp.br ([200.145.46.3]:42042 "EHLO mail.ift.unesp.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760142AbYEBMsw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 08:48:52 -0400
Date: Fri, 2 May 2008 09:47:04 -0300
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: kernel/time.c: integer constant is too large for long type
Message-ID: <20080502124703.GA4274@beyonder.ift.unesp.br>
Mail-Followup-To: "H. Peter Anvin" <hpa@zytor.com>,
	linux-kernel@vger.kernel.org
References: <20080502024636.GA31465@beyonder.ift.unesp.br> <481A992D.4070807@zytor.com> <481A9C52.8040909@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <481A9C52.8040909@zytor.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu  1.May'08 at 21:45:06 -0700, H. Peter Anvin wrote:
> H. Peter Anvin wrote:
>>
>> Your patch is simpler, so if Linus doesn't take the patch series this 
>> window we should push your patch after the window closes.
>>
>
> Actually, your patch is actively preferable, so I'll push it to Linus and 
> drop that part of the patchset.

Oh nice, thank you very much for doing that!!

The commit log I've sent yesterday had a small error in my english,
so please take the one below instead. Thanks!

Carlos

>From 6fd31aa2448603a5f44cfe9b6469c2cad7b77151 Mon Sep 17 00:00:00 2001
From: Carlos R. Mafra <crmafra@ift.unesp.br>
Date: Thu, 1 May 2008 23:30:49 -0300
Subject: [PATCH] kernel/time.c: Silence gcc warning 'integer constant to large for long type'

This patch removes these gcc warnings:

kernel/time.c: In function msecs_to_jiffies:
kernel/time.c:479: warning: integer constant is too large for long type
kernel/time.c: In function usecs_to_jiffies:
kernel/time.c:494: warning: integer constant is too large for long type

by casting MSEC_TO_HZ_ADJ32 and USEC_TO_HZ_ADJ32 to u64.

Signed-off-by: Carlos R. Mafra <crmafra@ift.unesp.br>
---
 kernel/time.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/time.c b/kernel/time.c
index cbe0d5a..76dcc0f 100644
--- a/kernel/time.c
+++ b/kernel/time.c
@@ -476,7 +476,7 @@ unsigned long msecs_to_jiffies(const unsigned int m)
 	if (HZ > MSEC_PER_SEC && m > jiffies_to_msecs(MAX_JIFFY_OFFSET))
 		return MAX_JIFFY_OFFSET;
 
-	return ((u64)MSEC_TO_HZ_MUL32 * m + MSEC_TO_HZ_ADJ32)
+	return ((u64)MSEC_TO_HZ_MUL32 * m + (u64)MSEC_TO_HZ_ADJ32)
 		>> MSEC_TO_HZ_SHR32;
 #endif
 }
@@ -491,7 +491,7 @@ unsigned long usecs_to_jiffies(const unsigned int u)
 #elif HZ > USEC_PER_SEC && !(HZ % USEC_PER_SEC)
 	return u * (HZ / USEC_PER_SEC);
 #else
-	return ((u64)USEC_TO_HZ_MUL32 * u + USEC_TO_HZ_ADJ32)
+	return ((u64)USEC_TO_HZ_MUL32 * u + (u64)USEC_TO_HZ_ADJ32)
 		>> USEC_TO_HZ_SHR32;
 #endif
 }
-- 
1.5.4.3



