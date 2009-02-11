Return-Path: <linux-kernel-owner+w=401wt.eu-S1757344AbZBKP7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757344AbZBKP7t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 10:59:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753143AbZBKP7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 10:59:40 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34834 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752831AbZBKP7k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 10:59:40 -0500
Date: Wed, 11 Feb 2009 16:59:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <htejun@gmail.com>
Cc: Brian Gerst <brgerst@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] x86: Pass in pt_regs pointer for syscalls that
	need it
Message-ID: <20090211155926.GA26194@elte.hu>
References: <1234277507-4987-1-git-send-email-brgerst@gmail.com> <1234277507-4987-3-git-send-email-brgerst@gmail.com> <4992812B.1050800@kernel.org> <73c1f2160902110631j68e58202h3e49288cfe613d66@mail.gmail.com> <4992E396.6000205@kernel.org> <4992E551.4060901@gmail.com> <73c1f2160902110659i776e1d89qc23d89363881572e@mail.gmail.com> <4992E92C.5000000@gmail.com> <73c1f2160902110710u77a563bftf09c460fab6f9136@mail.gmail.com> <4992EB62.3000501@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4992EB62.3000501@gmail.com>
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


* Tejun Heo <htejun@gmail.com> wrote:

> Brian Gerst wrote:
> > x86-64 doesn't have the tail-call problem because it doesn't use the
> > pt_regs on stack trick for syscall args.  All the args are passed in
> > registers.
> 
> Yeah, I was saying that we can do about the same thing on x86_32 by
> passing in pointer to pt_regs and defining proper syscall wrappers.
> It will cost a bit of performance by increasing register pressure tho.

Do you mean converting:

ptregscall int sys_execve(struct pt_regs *regs, char __user *u_filename,
                          char __user * __user *argv,
                          char __user * __user *envp)

to:

ptregscall int sys_execve(struct pt_regs *regs)
{
	char __user *u_filename		= syscall_arg1(regs);
	char __user * __user *argv	= syscall_arg2(regs);
	char __user * __user *envp	= syscall_arg3(regs);

etc.?

	Ingo
