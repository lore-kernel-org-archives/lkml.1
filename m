Return-Path: <linux-kernel-owner+w=401wt.eu-S1765218AbXLMU0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765218AbXLMU0u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 15:26:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755770AbXLMU0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 15:26:41 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51166 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752826AbXLMU0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 15:26:40 -0500
Date: Thu, 13 Dec 2007 21:26:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Linux Containers <containers@lists.osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Mark timer_stats as incompatible with multiple pid
	namespaces
Message-ID: <20071213202621.GC25130@elte.hu>
References: <m13au7tsov.fsf@ebiederm.dsl.xmission.com> <20071213090102.GB1926@elte.hu> <m1r6hqstat.fsf@ebiederm.dsl.xmission.com> <20071213130423.GB28340@elte.hu> <m1ir32sejc.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1ir32sejc.fsf@ebiederm.dsl.xmission.com>
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


* Eric W. Biederman <ebiederm@xmission.com> wrote:

> > the problem is, this interface stores historic PIDs too - i.e. PIDs 
> > of tasks that might have exited already.
> 
> Well struct pid * works in that case if you grab the reference to it.

but the display of the stats might happen much later. The point of this 
API is to save pid+comm, which gives users a good idea about what caused 
the events in the past - without having to pin any resource of that 
task.

>  {
>  	timer->start_site = NULL;
> +	pit_pid(timer->start_pid);
> +	timer->start_pid = NULL;

s/pit/put, right?

	Ingo
