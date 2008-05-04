Return-Path: <linux-kernel-owner+w=401wt.eu-S1755399AbYEDJlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399AbYEDJlW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 05:41:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753568AbYEDJlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 05:41:15 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59223 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752447AbYEDJlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 05:41:14 -0400
Date: Sun, 4 May 2008 11:40:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_32: move do_nmi() to nmi_32.c
Message-ID: <20080504094058.GA17566@elte.hu>
References: <481BA78F.50202@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <481BA78F.50202@ct.jp.nec.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:

> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> 
> on x86_64 do_nmi() is in nmi_64.c.

this patch caused build failure on x86.git+sched-devel.git:

arch/x86/kernel/built-in.o: In function `nmi_stack_correct':
arch/x86/kernel/entry_32.S:(.kprobes.text+0x117): undefined reference to `do_nmi'
arch/x86/kernel/built-in.o: In function `nmi_espfix_stack':
arch/x86/kernel/entry_32.S:(.kprobes.text+0x1c3): undefined reference to `do_nmi'
arch/x86/kernel/built-in.o: In function `alternative_instructions':
: undefined reference to `stop_nmi'
arch/x86/kernel/built-in.o: In function `alternative_instructions':
: undefined reference to `restart_nmi'

with this config:

 http://redhat.com/~mingo/misc/config-Sun_May__4_11_25_21_CEST_2008.bad

	Ingo
