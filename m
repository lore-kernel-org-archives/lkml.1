Return-Path: <linux-kernel-owner+w=401wt.eu-S1753036AbYLCJMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036AbYLCJMx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 04:12:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751503AbYLCJMh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 04:12:37 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57434 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486AbYLCJMg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 04:12:36 -0500
Date: Wed, 3 Dec 2008 10:12:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] check_hung_task(): unsigned sysctl_hung_task_warnings
	cannot be less than 0
Message-ID: <20081203091230.GG5668@elte.hu>
References: <4935AEDA.5020504@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4935AEDA.5020504@gmail.com>
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


* Roel Kluin <roel.kluin@gmail.com> wrote:

> unsigned sysctl_hung_task_warnings cannot be less than 0
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> in kernel/softlockup.c
> 
> unsigned long __read_mostly sysctl_hung_task_warnings = 10;
> ...
> static void check_hung_task()
> {
> ...
>         if (sysctl_hung_task_warnings < 0)
> 		return
>         sysctl_hung_task_warnings--;

applied to tip/core/urgent, thanks Roel!

Note, i changed the check to !0 instead - see below.

	Ingo

-------------->
>From 201955463a5c1a70d3f70d1598b27e4c2c402642 Mon Sep 17 00:00:00 2001
From: Roel Kluin <roel.kluin@gmail.com>
Date: Tue, 2 Dec 2008 22:55:38 +0100
Subject: [PATCH] check_hung_task(): unsigned sysctl_hung_task_warnings cannot be less than 0

Impact: fix warnings-limit cutoff check for debug feature

unsigned sysctl_hung_task_warnings cannot be less than 0

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/softlockup.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/softlockup.c b/kernel/softlockup.c
index 3953e4a..dc0b3be 100644
--- a/kernel/softlockup.c
+++ b/kernel/softlockup.c
@@ -188,7 +188,7 @@ static void check_hung_task(struct task_struct *t, unsigned long now)
 	if ((long)(now - t->last_switch_timestamp) <
 					sysctl_hung_task_timeout_secs)
 		return;
-	if (sysctl_hung_task_warnings < 0)
+	if (!sysctl_hung_task_warnings)
 		return;
 	sysctl_hung_task_warnings--;
 

