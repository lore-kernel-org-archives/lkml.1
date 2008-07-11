Return-Path: <linux-kernel-owner+w=401wt.eu-S1758909AbYGKUlm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758909AbYGKUlm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 16:41:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754198AbYGKUle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 16:41:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46331 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752172AbYGKUle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 16:41:34 -0400
Date: Fri, 11 Jul 2008 22:41:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [patch] x86, xen, vdso: fix build error, add sysctl_vsyscall32
Message-ID: <20080711204118.GA1864@elte.hu>
References: <20080711203435.GA29286@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080711203435.GA29286@elte.hu>
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

> +int sysctl_vsyscall32;
> +

ah, the trick is:

#ifdef CONFIG_X86_64
#define vdso_enabled                    sysctl_vsyscall32
#define arch_setup_additional_pages     syscall32_setup_pages
#endif

so disregard my patch. The real fix is the one below, for tip/xen-64bit.

	Ingo
