Return-Path: <linux-kernel-owner+w=401wt.eu-S1753127AbYIWIzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127AbYIWIzi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 04:55:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751592AbYIWIzb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 04:55:31 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57662 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751528AbYIWIza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 04:55:30 -0400
Date: Tue, 23 Sep 2008 10:55:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH -tip 0/4] x86: signal handler improvement
Message-ID: <20080923085518.GA29703@elte.hu>
References: <48D84A2A.2030009@ct.jp.nec.com> <20080923085027.GA25698@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080923085027.GA25698@elte.hu>
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

> could we perhaps first finish unifying them into signal.c, and then 
> introduce __put_user_cerr() in signal_32/64.c?

i've got an API suggestion as well. Instead of:

-               err |= __put_user(UC_FP_XSTATE, &frame->uc.uc_flags);
+               __put_user_cerr(UC_FP_XSTATE, &frame->uc.uc_flags, err);

could you instead please make it:

+               __put_user_cerr(UC_FP_XSTATE, &frame->uc.uc_flags, &err);

i.e. pass in 'err' as a reference. This makes it clear to the casual 
reader, in a C calling convention sense, that there's a side-effect to 
'err'. [ There should be no change to the resulting code as 
__put_user_cerr() is a macro. ]

	Ingo
