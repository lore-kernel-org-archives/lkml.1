Return-Path: <linux-kernel-owner+w=401wt.eu-S932959AbYB2Pw7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932959AbYB2Pw7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 10:52:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756370AbYB2Pwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 10:52:51 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58013 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753435AbYB2Pwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 10:52:50 -0500
Date: Fri, 29 Feb 2008 16:52:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_64 ia32 syscall restart fix
Message-ID: <20080229155207.GC27248@elte.hu>
References: <20080229035707.EAE862700FD@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080229035707.EAE862700FD@magilla.localdomain>
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


* Roland McGrath <roland@redhat.com> wrote:

> The code to restart syscalls after signals depends on checking for a 
> negative orig_ax, and for particular negative -ERESTART* values in ax. 
> These fields are 64 bits and for a 32-bit task they get zero-extended. 
> The syscall restart behavior is lost, a regression from a native 
> 32-bit kernel and from 64-bit tasks' behavior.  This patch fixes the 
> problem by doing sign-extension where it matters.  For orig_ax, the 
> only time the value should be -1 but winds up as 0x0ffffffff is via a 
> 32-bit ptrace call.  So the patch changes ptrace to sign-extend the 
> 32-bit orig_eax value when it's stored; it doesn't change the checks 
> on orig_ax, though it uses the new current_syscall() inline to better 
> document the subtle importance of the used of signedness there.  The 
> ax value is stored a lot of ways and it seems hard to get them all 
> sign-extended at their origins.  So for that, we use the 
> current_syscall_ret() to sign-extend it only for 32-bit tasks at the 
> time of the -ERESTART* comparisons.

thanks, applied.

	Ingo
