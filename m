Return-Path: <linux-kernel-owner+w=401wt.eu-S1753957AbXHBIOf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957AbXHBIOf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 04:14:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752831AbXHBIOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 04:14:18 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:57499 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753400AbXHBIOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 04:14:15 -0400
Message-ID: <46B19195.8010207@ah.jp.nec.com>
Date: Thu, 02 Aug 2007 17:11:01 +0900
From: Takenori Nagano <t-nagano@ah.jp.nec.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: vgoyal@in.ibm.com, k-miyoshi@cb.jp.nec.com,
       Bernhard Walle <bwalle@suse.de>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       kaos@sgi.com
Subject: Re: [patch] add kdump_after_notifier
References: <469F55D0.4050203@ah.jp.nec.com> <20070726140702.GA8949@suse.de>	<20070726153240.GA15969@in.ibm.com> <20070726153440.GA19095@suse.de>	<20070726154415.GB15969@in.ibm.com> <20070726154718.GA25561@suse.de>	<20070726155444.GC15969@in.ibm.com> <46A92E30.8070703@ah.jp.nec.com>	<20070730091624.GB6071@in.ibm.com>	<m16442vwgs.fsf@ebiederm.dsl.xmission.com>	<46AECEE0.3000307@ah.jp.nec.com>	<m1fy35t665.fsf@ebiederm.dsl.xmission.com>	<46B051B5.6020207@ah.jp.nec.com> <m18x8vpoa7.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m18x8vpoa7.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Takenori Nagano <t-nagano@ah.jp.nec.com> writes:
>> Then I gave up to merge my patch to kdb, and I tried to send another patch to
>> kexec community. I can understand his opinion, but it is very difficult to
>> modify that kdump is called from panic_notifier. Because it has a reason why
>> kdump don't use panic_notifier. So, I made this patch.
>>
>> Please do something about this problem.
> 
> Hmm.  Tricky.  These appear to be two code bases with a completely different
> philosophy on what errors are being avoided.
> 
> The kexec on panic assumption is that the kernel is broken and we better not
> touch it something horrible has gone wrong.  And this is the reason why
> kexec on panic is replacing lkcd.  Because the strong assumption results
> in more errors getting captured with less likely hood of messing up your
> system.
> 
> The kdb assumption appears to be that the kernel is mostly ok, and that there
> are just some specific thing that is wrong.

Yes, kdump and kdb have a completely different philosophy. But it's natural,
because their duties are different.

I think kdb is a supplementary debug means. kdump is not perfect, because
hardware sometimes breaks down. The probability that hardware (HDD, HBA, memory,
etc...) breaks down is very low, but it is not zero. If kdump fails taking a
dump, kdb data (process status, backtrace, log buffer, etc...) is very useful to
analyze the panic reason. kdb data is very poor in comparison with kdump, but
better than nothing.

So I request a favor of you again, please do something about this problem.

> The easiest way I can think to resolve this is for kdb to simply set
> a break point at the entry point of panic() when it initializes.  Then
> it wouldn't even need to be on the panic_list.  That approach would probably
> even give better debug information because you would not have the effects
> of bust_spinlocks to undo.
> 
> Is there some reason why kdb doesn't want to hook panic with a some
> kind of break point?

I think there is no technical reason. But panic code will be dirty if every
kernel developers adds their own hook. I think this is a reason why kdb uses
panic_notifier.

Thanks,
