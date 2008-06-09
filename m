Return-Path: <linux-kernel-owner+w=401wt.eu-S1754840AbYFITJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840AbYFITJi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 15:09:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752757AbYFITJ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 15:09:28 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49226 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752441AbYFITJ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 15:09:27 -0400
Date: Mon, 9 Jun 2008 21:09:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: update mptable v7 - fix
Message-ID: <20080609190911.GA20997@elte.hu>
References: <200805041823.57198.yhlu.kernel@gmail.com> <200805251600.26325.yhlu.kernel@gmail.com> <200806011317.38622.yhlu.kernel@gmail.com> <200806081953.26877.yhlu.kernel@gmail.com> <20080609101318.GA23873@elte.hu> <86802c440806091051j30ac4480oe6be0a7b288f772c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440806091051j30ac4480oe6be0a7b288f772c@mail.gmail.com>
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

> thanks. So X86_MPPARSE is not needed when SMP is not enabled?

here's the condition:

config X86_MPPARSE
        def_bool y
        depends on (X86_32 && (X86_LOCAL_APIC && !X86_VISWS)) || X86_64

64-bit has it unconditionally, 32-bit has it on SMP, UP-IOAPIC or 
UP-local-APIC mode. [ (and VISWS is an ugly complication we should try 
to eradicate similarly to NUMAQ, if possible :-) ]

	Ingo
