Return-Path: <linux-kernel-owner+w=401wt.eu-S1753763AbZCTJ6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763AbZCTJ6k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 05:58:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752238AbZCTJ6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 05:58:30 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:41047 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731AbZCTJ63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 05:58:29 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>, Jan Beulich <jbeulich@novell.com>,
       tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org
References: <49B91A7E.76E4.0078.0@novell.com>
	<tip-6a09dfa870ba0ed21b1124539968a36b42660661@git.kernel.org>
	<1236934491.5188.209.camel@laptop> <49BA33BE.76E4.0078.0@novell.com>
	<1236937423.22914.3698.camel@twins> <20090313103828.GB31094@elte.hu>
	<m1d4cd9n4k.fsf@fess.ebiederm.org> <20090320085205.GB16021@elte.hu>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 20 Mar 2009 02:58:19 -0700
In-Reply-To: <20090320085205.GB16021@elte.hu> (Ingo Molnar's message of "Fri\, 20 Mar 2009 09\:52\:05 +0100")
Message-ID: <m14oxo8qis.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: mingo@elte.hu, linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, jbeulich@novell.com, peterz@infradead.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Ingo Molnar <mingo@elte.hu>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [tip:core/ipi] generic-ipi: eliminate spurious pointlessWARN_ON()s
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> * Eric W. Biederman <ebiederm@xmission.com> wrote:
>
>> Ingo Molnar <mingo@elte.hu> writes:
>> 
>> > I also changed all of panic() to be covered by oops_in_progress 
>> > - see the other commit. Eric: that should make kexec [a tiny 
>> > bit] more robust too, agreed?
>> 
>> A tad.  We shouldn't have any printk's on that path.  But if we do 
>> it will keep us from wedging and getting ourselves into trouble.
>
> Ok. Baby steps are what got us from Linux 0.12 to where we are now 
> so i'm content with making a tad of progress with each commit ;-)

Our biggest todo item for kexec on panic is to initialize the local
apics early enough in boot so we never need to run in compatibility mode.
Once we get that code working we can remove 50%+ of the kexec on panic
code.

I expect one of these days the apic code will be clean enough to handle
that.

Now back to my regularly scheduled hotunplug challenges starting with
getting lockdep to warn about the dead locks.

Eric
