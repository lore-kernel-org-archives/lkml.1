Return-Path: <linux-kernel-owner+w=401wt.eu-S1756128AbYCULI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128AbYCULI2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 07:08:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754553AbYCULIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 07:08:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54942 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754008AbYCULIU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 07:08:20 -0400
Date: Fri, 21 Mar 2008 12:08:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yakov Lerner <iler.ml@gmail.com>
Cc: prasanna@in.ibm.com, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com,
       davem@davemloft.net, linux-kernel@vger.kernel.org,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH] Subject: kprobes-x86: correct post-eip value in
	post_hander()
Message-ID: <20080321110804.GY20420@elte.hu>
References: <E1Jao7N-0005OC-Fe@io.site5.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Jao7N-0005OC-Fe@io.site5.com>
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


* Yakov Lerner <iler.ml@gmail.com> wrote:

> I was trying to get the address of instruction to be executed next 
> after the kprobed instruction.  But regs->eip in post_handler() 
> contains value which is useless to the user. It's pre-corrected value. 
> This value is difficult to use without access to resume_execution(), 
> which is not exported anyway. I moved the invocation of post_handler() 
> to *after* resume_execution(). Now regs->eip contains meaningful value 
> in post_handler().
> 
> I do not think this change breaks any backward-compatibility. To make 
> meaning of the old value, post_handler() would need access to 
> resume_execution() which is not exported.  I have difficulty to 
> believe that previous, uncorrected, regs->eip can be meaningfully used 
> in post_handler().

thanks, i've added your patch to the .26 bucket of x86.git, but it would 
be nice to get an Ack/Nack from a kprobes person as well.

	Ingo
