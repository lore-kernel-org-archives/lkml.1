Return-Path: <linux-kernel-owner+w=401wt.eu-S1761475AbXLMNEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761475AbXLMNEu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 08:04:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752262AbXLMNEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 08:04:43 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37403 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752041AbXLMNEm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 08:04:42 -0500
Date: Thu, 13 Dec 2007 14:04:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Linux Containers <containers@lists.osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Mark timer_stats as incompatible with multiple pid
	namespaces
Message-ID: <20071213130423.GB28340@elte.hu>
References: <m13au7tsov.fsf@ebiederm.dsl.xmission.com> <20071213090102.GB1926@elte.hu> <m1r6hqstat.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1r6hqstat.fsf@ebiederm.dsl.xmission.com>
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

> > What the heck??? Please solve this properly instead of hiding it. 
> > /proc/timer_stats is damn useful and it's a must-have for powertop 
> > to work.
> 
> Hmm.  Perhaps the dependency conflict should go in the other direction 
> then.
> 
> My goal is to document the issue while a proper fix is being written. 
> I have known about this for all of about 1 day now.  It was added 
> since last time I went through the kernel and made a thorough sweep of 
> pid users.
> 
> What the proper fix is isn't even obvious at this point. Possibly it 
> is making /proc/timer_stats disappear in child pid namespaces.
>   Which we don't currently have the infrastructure fore.
>
> Possibly it is reworking the stats collection so we store a struct pid 
> * instead of a pid_t value.  So we would know if the reader of the 
> value can even see processes you have collected stats for.

the problem is, this interface stores historic PIDs too - i.e. PIDs of 
tasks that might have exited already.

the proper way would be to also store the namespace address, and to 
filter out non-matching entries. (If leakage of this data across 
namespace creation is of any concern then flush out existing namespace 
data when a namespace is destroyed)

	Ingo
