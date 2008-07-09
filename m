Return-Path: <linux-kernel-owner+w=401wt.eu-S1752640AbYGIHAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640AbYGIHAw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 03:00:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755710AbYGIHAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 03:00:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44167 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753309AbYGIHAG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 03:00:06 -0400
Date: Wed, 9 Jul 2008 08:59:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Glauber Costa <gcosta@redhat.com>
Cc: tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org,
       x86@kernel.org
Subject: Re: [GIT PULL] Userlib integration patches
Message-ID: <20080709065948.GA17054@elte.hu>
References: <200807011846.m61IkHWF014954@pobox-2.corp.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807011846.m61IkHWF014954@pobox-2.corp.redhat.com>
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


* Glauber Costa <gcosta@redhat.com> wrote:

> Ingo, please pull the latest master git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/glommer/linux-2.6-x86-integration.git master
> 
> It is based on your tip/master tree, and contains an update to the 
> userlib integration according to the mailing list discussions. You 
> should be able to wipe out the previous branch, and put this one on 
> instead.

i've applied these changes to tip/x86/unify-lib:

Glauber Costa (42):
      x86: don't use size specifiers.
      x86: provide delay loop for x86_64.
      x86: use rdtscll in read_current_timer for i386.
      x86: explicitly use edx in const delay function.
      x86: integrate delay functions.
      x86: don't clobber r8 nor use rcx.
      x86: don't use word-size specifiers.
      x86: adapt x86_64 getuser functions.
      x86: rename threadinfo to TI.
      x86: don't use word-size specifiers on getuser_64.
      x86: introduce __ASM_REG macro.
      x86: use _ASM_PTR instead of explicit word-size pointers.
      x86: merge getuser asm functions.
      x86: don't save ebx in putuser_32.S.
      x86: user put_user_x instead of all variants.
      x86: clobber rbx in putuser_64.S.
      x86: pass argument to putuser_64 functions in ax register.
      x86: change testing logic in putuser_64.S.
      x86: replace function headers by macros.
      x86: don't use word-size specifiers in putuser files.
      x86: use macros from asm.h.
      x86: merge putuser asm functions.
      x86: commonize __range_not_ok.
      x86: change asm constraint.
      x86: introduce likely in macro.
      x86: use long instead of int.
      x86: use something common for both architectures.
      x86: merge common parts of uaccess.
      x86: merge getuser.
      x86: move __addr_ok to uaccess.h.
      x86: use k modifier for 4-byte access.
      x86: mark x86_64 as having a working WP.
      x86: don't always use EFAULT on __put_user_size.
      x86: merge __put_user_asm and its user.
      x86: don't always use EFAULT on __get_user_size.
      x86: merge __get_user_asm and its users.
      x86: be more explicit in __put_user_x.
      x86: turn __put_user_check directly into put_user.
      x86: merge put_user.
      x86: move __get_user and __put_user into uaccess.h.
      x86: put movsl_mask into uaccess.h.
      x86: define architectural characteristics in uaccess.h.

thanks Glauber, the finegrained splitup looks really nice!

I had to rebase the series because it interacted with some other patches 
(such as the unification of tsc_[32|64].c => tsc.c). It's being tested 
right now, will push it out into tip/master later today if everything 
goes fine.
	
	Ingo
