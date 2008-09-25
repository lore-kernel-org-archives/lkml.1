Return-Path: <linux-kernel-owner+w=401wt.eu-S1753410AbYIYIEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410AbYIYIEq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 04:04:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752105AbYIYIEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 04:04:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48001 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751097AbYIYIE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 04:04:28 -0400
Date: Thu, 25 Sep 2008 10:04:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: v2.6.27-rc7: x86: #GP on panic?
Message-ID: <20080925080417.GB27048@elte.hu>
References: <19f34abd0809241209l3a69d607v153549ee43e085e9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0809241209l3a69d607v153549ee43e085e9@mail.gmail.com>
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


* Vegard Nossum <vegard.nossum@gmail.com> wrote:

> Hi,
> 
> With 2.6.27-rc7 on qemu-x86_64, it seems that panic will trigger a 
> General Protection Fault. I haven't seen it before.

> [    4.523641] Code: eb fd 55 48 89 e5 53 51 83 3d 25 e8 78 00 00 75
> 1a 31 d2 31 f6 48 c7 c7 e1 9c 01 81 e8 f7 a4 03 00 9c 5b fa e8 94 09
> 00 00 53 9d <5a> 5b c9 c3 55 31 c0 48 89 e5 89 04 25 b0 c0 5f ff 65 83
> 04 25

hm, 0x5a is a simple pop %rdx. A #GP there means the stack segment is 
bust?

hm:

> ffffffff8101a6b9 <disable_local_APIC>
> ffffffff81019d25:       53                      push   %rbx
> ffffffff81019d26:       9d                      popfq
> ffffffff81019d27:       5a                      pop    %rdx

so it's preceded by a popfq and on the next instruction we #GP.

but the stack and flags state looks good:

  [    4.523641] RSP: 0018:ffff880007867d70  EFLAGS: 00000286

weird.

	Ingo
