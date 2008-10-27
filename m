Return-Path: <linux-kernel-owner+w=401wt.eu-S1752675AbYJ0Kkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675AbYJ0Kkt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 06:40:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751518AbYJ0Kkl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 06:40:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47834 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881AbYJ0Kkk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 06:40:40 -0400
Date: Mon, 27 Oct 2008 11:40:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <srostedt@redhat.com>
Cc: Jonas Bonn <jonas.bonn@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] asm-generic: define DIE_OOPS in asm-generic
Message-ID: <20081027104026.GL8116@elte.hu>
References: <1224928160-19147-1-git-send-email-jonas.bonn@gmail.com> <4903621B.9040101@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4903621B.9040101@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <srostedt@redhat.com> wrote:

> Jonas Bonn wrote:
>> DIE_OOPS is now used in the generic trace handling code so it needs to
>> be defined for all architectures.  Define it in asm-generic so that it's
>> available to all by default and doesn't cause build errors for
>> architectures that rely on the generic implementation.
>>
>> Signed-off-by: Jonas Bonn <jonas.bonn@gmail.com>
>> ---
>>  include/asm-generic/kdebug.h |    1 +
>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>   
>
> This will obsolete my other patch. (the one making the nmi handler weak)
>
> Acked-by: Steven Rostedt <srostedt@redhat.com>
>
> -- Steve

ok - i've queued up the patch below in tip/tracing/urgent, thanks 
guys.

	Ingo

>From 5209f08dc8e5f520ca81b87fa9a7142f58a109f4 Mon Sep 17 00:00:00 2001
From: Jonas Bonn <jonas.bonn@gmail.com>
Date: Sat, 25 Oct 2008 11:49:20 +0200
Subject: [PATCH] asm-generic: define DIE_OOPS in asm-generic

Impact: build fix

DIE_OOPS is now used in the generic trace handling code so it needs to
be defined for all architectures.  Define it in asm-generic so that it's
available to all by default and doesn't cause build errors for
architectures that rely on the generic implementation.

Signed-off-by: Jonas Bonn <jonas.bonn@gmail.com>
Acked-by: Steven Rostedt <srostedt@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/asm-generic/kdebug.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/asm-generic/kdebug.h b/include/asm-generic/kdebug.h
index 2b799c9..11e57b6 100644
--- a/include/asm-generic/kdebug.h
+++ b/include/asm-generic/kdebug.h
@@ -3,6 +3,7 @@
 
 enum die_val {
 	DIE_UNUSED,
+	DIE_OOPS=1
 };
 
 #endif /* _ASM_GENERIC_KDEBUG_H */
