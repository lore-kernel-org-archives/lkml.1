Return-Path: <linux-kernel-owner+w=401wt.eu-S1752947AbZLABC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947AbZLABC7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 20:02:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752503AbZLABC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 20:02:58 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:37846 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793AbZLABC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 20:02:57 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4B146B2D.9040700@jp.fujitsu.com>
Date: Tue, 01 Dec 2009 10:02:37 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Spencer Candland <spencer@bluehost.com>,
       =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
       Oleg Nesterov <oleg@redhat.com>, Balbir Singh <balbir@in.ibm.com>
Subject: Re: [PATCH 2/2] cputime: introduce thread_group_times()
References: <1258038038.4039.467.camel@laptop> <20091112154050.GC6218@dhcp-lab-161.englab.brq.redhat.com> <4B01A8DB.6090002@bluehost.com> <20091117130851.GA3842@dhcp-lab-161.englab.brq.redhat.com> <1258464288.7816.305.camel@laptop> <20091119181744.GA3743@dhcp-lab-161.englab.brq.redhat.com> <4B05F835.10401@jp.fujitsu.com> <20091123100925.GB25978@dhcp-lab-161.englab.brq.redhat.com> <20091123101612.GC25978@dhcp-lab-161.englab.brq.redhat.com> <4B138EA0.90007@jp.fujitsu.com> <20091130145442.GA2326@dhcp-lab-161.englab.brq.redhat.com>
In-Reply-To: <20091130145442.GA2326@dhcp-lab-161.englab.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanislaw Gruszka wrote:
> Idea is very good IMHO.

Thank you very much!

>>  #ifndef CONFIG_VIRT_CPU_ACCOUNTING
>> -	cputime_t prev_utime, prev_stime;
>> +	cputime_t prev_utime, prev_stime, prev_tgutime, prev_tgstime;
>>  #endif
> 
> I think the new values should be part of struct_signal (see below)

Good point.  I'll update patch to do so.

>>  /*
>> + * Must be called with siglock held.
>> + */
>> +void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
>> +{
>> +	struct task_cputime cputime;
>> +
>> +	__thread_group_times(p, &cputime);
>> +
>> +	if (ut)
>> +		*ut = cputime.utime;
>> +	if (st)
>> +		*st = cputime.stime;
> 
> No thread_group_times() nor task_times() is called with NULL arguments, we
> can get rid of "if ({u,s}t)" checks. Perhaps thread_group_times() should
> have "struct task_cputime" argument as it is wrapper for
> thread_group_cputime();

Removing "if ({u,s}t)" is OK with me.
I expect all thread_group_times() user should have no interest in members
of struct task_cputime other than {u,s}time, so I'd like to keep the
argument as is.


Thanks,
H.Seto

