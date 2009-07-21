Return-Path: <linux-kernel-owner+w=401wt.eu-S1754751AbZGUG4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751AbZGUG4c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 02:56:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754541AbZGUG4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 02:56:30 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:59502 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754424AbZGUG43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 02:56:29 -0400
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Neil Horman <nhorman@tuxdriver.com>, Vivek Goyal <vgoyal@redhat.com>,
       Brayan Arraes <brayan@yack.com.br>, LKML <linux-kernel@vger.kernel.org>
References: <4A64672E.8020005@cn.fujitsu.com>
	<m1d47vnoq6.fsf@fess.ebiederm.org> <4A65598D.7020808@cn.fujitsu.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 20 Jul 2009 23:56:22 -0700
In-Reply-To: <4A65598D.7020808@cn.fujitsu.com> (Lai Jiangshan's message of "Tue\, 21 Jul 2009 14\:00\:45 +0800")
Message-ID: <m1vdlmmsmh.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: laijs@cn.fujitsu.com, linux-kernel@vger.kernel.org, brayan@yack.com.br, vgoyal@redhat.com, nhorman@tuxdriver.com, akpm@linux-foundation.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Lai Jiangshan <laijs@cn.fujitsu.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH] sysrq, kdump: fix regression, revert "simplify sysrq-c handler"
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lai Jiangshan <laijs@cn.fujitsu.com> writes:

> Eric W. Biederman wrote:
>> Lai Jiangshan <laijs@cn.fujitsu.com> writes:
>> 
>>> 1) This fix breaks our tools.
>>>       This fix changes the ABI. panic_on_oops is default 0,
>>>    and a lots system do not specify the boot option "panic",
>>>    thus, Sysrq-c will not cause CrashDump(Kdump) as expected.
>> 
>> How does it break your tools?
>
> Sysrq-c is known for causing a CrashDump.
> This fix make Sysrq-c just causing an oops.
> An oops in process context just kills current task and
> does nothing. (panic_on_oops=0)
>
> Why we let a cleanup patch changes the kernel behavior so much?

Because it seemed reasonable to be able to test the oops path
as well.

>>> 2) When CONFIG_KEXEC=n, Sysrq-c should become an invalid
>>>    command like Sysrq-D(CONFIG_LOCKDEP, show-all-locks).
>>>    But this fix makes it a valid command and let it do a
>>>    hazard thing: cause a page fault(NULL dereference) in kernel.
>>>
>>> So, we revert this fix.
>> 
>> The idea was to extend sysrq-d to also be a way of testing NULL
>> pointer dereferences.  How is that a bad idea?
>> 
>
> When CONFIG_KEXEC=n, Crashdump is not available,
> Sysrq-c should become an invalid command.

Why should sysrq-c become an invalid command?

What problem does this cause for you?

Eric

