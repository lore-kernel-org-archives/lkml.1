Return-Path: <linux-kernel-owner+w=401wt.eu-S1756398AbYAVVFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756398AbYAVVFT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 16:05:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753344AbYAVVFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 16:05:06 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55331 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752498AbYAVVFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 16:05:04 -0500
Date: Tue, 22 Jan 2008 22:04:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ian Campbell <ijc@hellion.org.uk>,
       Mika =?iso-8859-1?Q?Penttil=E4?= <mika.penttila@kolumbus.fi>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] x86: make nx_enabled conditional on CONFIG_X86_PAE
Message-ID: <20080122210442.GH12892@elte.hu>
References: <1200950633.15491.21.camel@cthulhu.hellion.org.uk> <479510CE.7010706@zytor.com> <1200951996.15491.28.camel@cthulhu.hellion.org.uk> <479551FD.5040801@zytor.com> <1201023401.5643.52.camel@localhost.localdomain> <479634A9.1090908@zytor.com> <1201031325.15491.66.camel@cthulhu.hellion.org.uk> <47964B7B.9000905@zytor.com> <20080122203611.GA12892@elte.hu> <1201035611.16972.61.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201035611.16972.61.camel@brick>
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


* Harvey Harrison <harvey.harrison@gmail.com> wrote:

> nx_enabled can only be set to non-zero when CONFIG_X86_PAE is set.  
> The only use not currently inside a CONFIG_X86_PAE block is the 
> definition, the declaration and a conditional unlikely test in 
> fault_32.c (is_prefetch).
> 
> When !CONFIG_X86_PAE, is_prefetch always returns 0 immediately as 
> nx_enabled is always 0.
> 
> When CONFIG_X86_PAE, the test is preserved, but the test against the 
> cpu model and stepping is deleted, this may not be correct.

thanks, applied.

> Ingo, further to your nx vs !nx comment, had this lying around, needs 
> testing, only affects the CONFIG_X86_PAE case.

will keep an eye on it.

How far away are you from unifying fault_32.c and fault_64.c? You 
already managed to line up their sizes:

$ wc -l arch/x86/mm/fault_*.c
  742 arch/x86/mm/fault_32.c
  734 arch/x86/mm/fault_64.c

;-)

and the raw diff between them doesnt look that bad either:

 1 file changed, 127 insertions(+), 135 deletions(-)

so we might as well take a shot at that?

	Ingo
