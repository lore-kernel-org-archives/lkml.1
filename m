Return-Path: <linux-kernel-owner+w=401wt.eu-S1757370AbZCJWDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370AbZCJWDV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 18:03:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755080AbZCJWDC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 18:03:02 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51958 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754422AbZCJWDB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 18:03:01 -0400
Date: Tue, 10 Mar 2009 23:02:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Renzo Davoli <renzo@cs.unibo.it>
Cc: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       linux-kernel@vger.kernel.org, Jeff Dike <jdike@addtoit.com>,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH 2/2] ptrace_vm: ptrace for syscall emulation virtual
	machines
Message-ID: <20090310220241.GC30475@elte.hu>
References: <20090204080256.GC17452@cs.unibo.it> <20090310214456.GE5213@cs.unibo.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090310214456.GE5213@cs.unibo.it>
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


* Renzo Davoli <renzo@cs.unibo.it> wrote:

> +/* test thread code. This thread is started only to test 
> + * which features are provided by the linux kernel */
> +static int sysptvm_child(void *arg)
> +{
> +	int *featurep=arg;
> +	int p[2]={-1,-1};
> +	pid_t pid=os_getpid();
> +	if(ptrace(PTRACE_TRACEME, 0, 0, 0) < 0){
> +		perror("ptrace test_ptracemulti");
> +		kill(pid, SIGKILL);
> +	}
> +	kill(pid, SIGSTOP);
> +	*featurep=0;
> +	os_getpid();
> +	/* if it reaches this point in 1 stop it means that
> +	 * PTRACE_SYSCALL_SKIPEXIT works */
> +	*featurep=PTRACE_SYSCALL_SKIPEXIT;
> +	pipe(p);
> +	/* if after a PTRACE_SYSCALL_SKIPCALL p[0] is already <0 
> +	 * pipe has been really skipped */
> +	if (p[0] < 0)
> +		*featurep=PTRACE_SYSCALL_SKIPCALL;
> +	else { /* clean up everything */
> +		close(p[0]);
> +		close(p[1]);
> +	}
> +	return 0;

Please check Documentation/CodingStyle. Every second line above 
violates it. scripts/checkpatch.pl can help out with the more 
obvious ones.

	Ingo
