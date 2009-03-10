Return-Path: <linux-kernel-owner+w=401wt.eu-S1753775AbZCJIiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775AbZCJIiQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 04:38:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752539AbZCJIiA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 04:38:00 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47871 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752031AbZCJIh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 04:37:59 -0400
Date: Tue, 10 Mar 2009 09:37:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Stoyan Gaydarov <stoyboyker@gmail.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, x86@kernel.org
Subject: Re: [PATCH 07/25] [x86] BUG to BUG_ON changes
Message-ID: <20090310083735.GA3097@elte.hu>
References: <1236661850-8237-1-git-send-email-stoyboyker@gmail.com> <1236661850-8237-2-git-send-email-stoyboyker@gmail.com> <1236661850-8237-3-git-send-email-stoyboyker@gmail.com> <1236661850-8237-4-git-send-email-stoyboyker@gmail.com> <1236661850-8237-5-git-send-email-stoyboyker@gmail.com> <1236661850-8237-6-git-send-email-stoyboyker@gmail.com> <1236661850-8237-7-git-send-email-stoyboyker@gmail.com> <1236661850-8237-8-git-send-email-stoyboyker@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236661850-8237-8-git-send-email-stoyboyker@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stoyan Gaydarov <stoyboyker@gmail.com> wrote:

> Signed-off-by: Stoyan Gaydarov <stoyboyker@gmail.com>
> ---
>  arch/x86/kernel/cpu/common.c        |    6 ++----
>  arch/x86/kernel/quirks.c            |    3 +--
>  arch/x86/mach-voyager/voyager_smp.c |    6 ++----
>  3 files changed, 5 insertions(+), 10 deletions(-)

applied, thanks.

To find candidates i suspect you used something like this:

 grep -r -B 1 'BUG()' arch/x86/ | grep -E '\<if\>[^(]*\([^{(]*$' -A 1

right? It gives the output below - exactly the sites you 
touched.

	Ingo

arch/x86/kernel/cpu/common.c-	if (me->mm)
arch/x86/kernel/cpu/common.c:		BUG();
--
arch/x86/kernel/cpu/common.c-	if (curr->mm)
arch/x86/kernel/cpu/common.c:		BUG();
--
arch/x86/kernel/quirks.c-	if (rcba_base == NULL)
arch/x86/kernel/quirks.c:		BUG();
