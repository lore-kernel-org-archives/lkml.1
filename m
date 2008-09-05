Return-Path: <linux-kernel-owner+w=401wt.eu-S1754038AbYIEHqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038AbYIEHqh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 03:46:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751042AbYIEHq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 03:46:28 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53710 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750741AbYIEHq1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 03:46:27 -0400
Date: Fri, 5 Sep 2008 09:46:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/16] x86: use common.c for 64 bit
Message-ID: <20080905074604.GA5790@elte.hu>
References: <1220584154-32497-1-git-send-email-yhlu.kernel@gmail.com> <1220584154-32497-16-git-send-email-yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1220584154-32497-16-git-send-email-yhlu.kernel@gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> and remove common_64.c
> 
> Signed-off-by: Yinghai <yhlu.kernel@gmail.com>
> ---
>  arch/x86/kernel/cpu/Makefile    |    6 +-
>  arch/x86/kernel/cpu/common_64.c | 1201 ---------------------------------------
>  2 files changed, 3 insertions(+), 1204 deletions(-)
>  delete mode 100644 arch/x86/kernel/cpu/common_64.c

very nice patchset!

I've created a new topic for this: tip/x86/unify-cpu-detect, with these 
commits:

f5017cf: x86: use cpu/common.c on 64 bit
143b604: x86: cpu/common*.c, merge whitespaces
102bbe3: x86: cpu/common*.c, merge identify_cpu()
b89d3b3: x86: cpu/common*.c, merge generic_identify()
56f0d03: x86: cpu/common*.c: merge print_cpu_info()
6627d24: x86: cpu/common*.c, merge early_identify_cpu()
5122c89: x86: cpu/common.c: merge get_cpu_cap()
1cd7877: x86: cpu/common*.c, merge detect_ht()
140fc72: x86: cpu/common*.c, merge display_cacheinfo()
b9e67f0: x86: cpu/common.c, merge default_init()
fab334c: x86: cpu/common*.c, merge switch_to_new_gdt()
1ba7658: x86: cpu/common*.c have same cpu_init(), with copying and #ifdef
d5494d4: x86: cpu/common*.c, make 32-bit have 64-bit only functions
ba51dce: x86: cpu/common.c, let 64-bit code have 32-bit only functions
950ad7f: x86: same gdt_page with macro
f0fc4af: x86: make header file the same in arch/x86/kernel/cpu/common_xx.c
97e4db7: x86: make detect_ht depend on CONFIG_X86_HT

One small detail: i've added commit 143b604 before the final commit with 
the whitespace deltas, to make the final commit a pure, mechanic 
file-delete. The end result is still the same.

btw., the total effect of the unification is:

 4 files changed, 433 insertions(+), 861 deletions(-)

which is nice!

	Ingo
