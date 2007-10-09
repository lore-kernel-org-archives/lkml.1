Return-Path: <linux-kernel-owner+w=401wt.eu-S1754238AbXJIHmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238AbXJIHmv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 03:42:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752988AbXJIHmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 03:42:42 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:61016 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743AbXJIHml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 03:42:41 -0400
Message-ID: <470B3008.9040003@ah.jp.nec.com>
Date: Tue, 09 Oct 2007 16:38:48 +0900
From: Takenori Nagano <t-nagano@ah.jp.nec.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: linux-kernel@vger.kernel.org, vgoyal@in.ibm.com, k-miyoshi@cb.jp.nec.com,
       kexec@lists.infradead.org, Bernhard Walle <bwalle@suse.de>,
       Keith Owens <kaos@ocs.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, kdb@oss.sgi.com
Subject: Re: [PATCH 0/2] add new notifier function
References: <4704D09D.6080503@ah.jp.nec.com> <m1641llnqa.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1641llnqa.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Takenori Nagano <t-nagano@ah.jp.nec.com> writes:
> 
>> Hi,
>>
>> These patches add new notifier function and implement it to panic_notifier_list.
>> We used the hardcoded notifier chain so far, but it was not flexible. New
>> notifier is very flexible, because user can change a list of order by debugfs.
> 
> How is the lack of flexibility a problem?
> Specifics please.

Please read this again.
http://www.gossamer-threads.com/lists/linux/kernel/797220?do=post_view_threaded#797220

Keith Owen said,

> My stance is that _all_ the RAS tools (kdb, kgdb, nlkd, netdump, lkcd,
> crash, kdump etc.) should be using a common interface that safely puts
> the entire system in a stopped state and saves the state of each cpu.
> Then each tool can do what it likes, instead of every RAS tool doing
> its own thing and they all conflict with each other, which is why this
> thread started.
> 
> It is not the kernel's job to decide which RAS tool runs first, second
> etc., it is the user's decision to set that policy. Different sites
> will want different orders, some will say "go straight to kdump", other
> sites will want to invoke a debugger first. Sites must be able to
> define that policy, but we hard code the policy into the kernel. 

I agreed with him and I made new notifier function.

> 
> My impression is that the purpose of this patchset is to build
> infrastructure to sort out a conflict between kdb and the kexec code,
> which it does not do, and it can not do if it does not own up to
> it's real purpose.

My motivation does not change. But I don't think kdump have to use notifer.
I want to resolve this adopting the way which satisfy all users.

Thanks,

Takenori Nagano <t-nagano@ah.jp.nec.com>
