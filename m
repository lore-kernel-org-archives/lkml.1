Return-Path: <linux-kernel-owner+w=401wt.eu-S1753146AbZD0IkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146AbZD0IkA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 04:40:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752440AbZD0Ijv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 04:39:51 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42303 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752400AbZD0Iju (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 04:39:50 -0400
Date: Mon, 27 Apr 2009 10:39:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dave Airlie <airlied@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: kms in defconfig
Message-ID: <20090427083935.GA20941@elte.hu>
References: <21d7e9970904270121s1c58365bqc8933f8a3ffc5f1a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21d7e9970904270121s1c58365bqc8933f8a3ffc5f1a@mail.gmail.com>
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


* Dave Airlie <airlied@gmail.com> wrote:

> Hi guys,
> 
> I just noticed CONFIG_DRM_I915_KMS is enabled for x86-64.
> 
> This should never be the case, as anyone who built defconfig 
> kernels before, will now get KMS enabled when really they need to 
> have done userspace upgrades.

I've yet to see such a bugreport.

But i dont have particularly strong feelings about defconfigs: less 
than 1% of all kernel developers use them - which transforms into 
less than 0.01% of all Linux users.

KMS is off by default in 'make oldconfig', right? That's all that 
matters really.

defconfigs _do_ change and there was never a compatibility rule for 
defconfigs. Arch defconfig is more of a signal towards what the 
architecture maintainers consider sane and supportable (or 
desirable) defaults - and it is also what developers working on 
arch/x86 should consider as the main thrust of features.

> KMS should default to n in the upstream kernel, for at least 4-5 
> years.

That's an extremely long period of migration. I also think it's 
unreasonable: we dont want to draw out the migration from 
DRI1+user-space-mode-setting to DRI2+KMS that long. KMS should have 
been implemented and made the default 4-5 years _ago_ i think.

KMS is the sane design for graphics and i'd go as far as to consider 
user-space mode setting an outright _bug_. It look a long time to 
fix but now lets look forward and fix all the bugs in KMS, ASAP ...

	Ingo
