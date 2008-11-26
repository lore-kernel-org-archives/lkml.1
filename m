Return-Path: <linux-kernel-owner+w=401wt.eu-S1753905AbYKZONq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905AbYKZONq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 09:13:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752629AbYKZONh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 09:13:37 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35909 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752447AbYKZONh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 09:13:37 -0500
Date: Wed, 26 Nov 2008 15:13:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: eranian@googlemail.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, x86@kernel.org,
       andi@firstfloor.org, eranian@gmail.com, sfr@canb.auug.org.au
Subject: Re: [patch 20/24] perfmon: system calls interface
Message-ID: <20081126141318.GG6562@elte.hu>
References: <492d0c0b.170e660a.15ba.ffffdabf@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <492d0c0b.170e660a.15ba.ffffdabf@mx.google.com>
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


another thing:

+static inline int pfm_ctx_permissions(u32 ctx_flags)
+{
+       if (pfm_controls.task_group != PFM_GROUP_PERM_ANY
+                  && !in_group_p(pfm_controls.task_group)) {
+               PFM_DBG("user group not allowed to create a task context");
+               return -EPERM;
+       }
+       return 0;
+}

ctx_flags is unused here. If flags used used later on _then_ should it 
be added to these functions. Right now it just obscures review and 
slows down the code.

	Ingo
