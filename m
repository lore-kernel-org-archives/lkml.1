Return-Path: <linux-kernel-owner+w=401wt.eu-S1754960AbZBCVjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960AbZBCVjk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 16:39:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751584AbZBCVj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 16:39:28 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:54842 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbZBCVj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 16:39:27 -0500
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <srostedt@redhat.com>,
       linux-kernel@vger.kernel.org
References: <20090203193904.GA23695@redhat.com>
	<20090203194214.GA23703@redhat.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 03 Feb 2009 13:39:44 -0800
In-Reply-To: <20090203194214.GA23703@redhat.com> (Oleg Nesterov's message of "Tue\, 3 Feb 2009 20\:42\:14 +0100")
Message-ID: <m1fxivw673.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=67.180.49.163;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.180.49.163
X-SA-Exim-Rcpt-To: oleg@redhat.com, linux-kernel@vger.kernel.org, srostedt@redhat.com, mingo@elte.hu
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Oleg Nesterov <oleg@redhat.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH] ftrace: do_each_pid_task() needs rcu lock
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> On 02/03, Oleg Nesterov wrote:
>>
>> "ftrace: use struct pid" commit 978f3a45d9499c7a447ca7615455cefb63d44165
>> converted ftrace_pid_trace to "struct pid*". But we can't use
>> do_each_pid_task() without rcu_read_lock() even if we know the pid
>> itself can't go away (it was pinned in ftrace_pid_write). The exiting
>> task can detach itself from this pid at any moment.
>
> Q: why do we use do_each_pid_task(PIDTYPE_PID) ? We can never have more
> than 1 task in the loop. Perhaps,

That is a bug in do_each_pid_task(PIDTYPE_PID).
For ftrace we really want to grab all tasks with a given pid even
in the crazy exec case.

Eric
