Return-Path: <linux-kernel-owner+w=401wt.eu-S1762889AbXHAJ1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762889AbXHAJ1S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 05:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758831AbXHAJ1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 05:27:10 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:36914 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756966AbXHAJ1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 05:27:08 -0400
Message-ID: <46B051B5.6020207@ah.jp.nec.com>
Date: Wed, 01 Aug 2007 18:26:13 +0900
From: Takenori Nagano <t-nagano@ah.jp.nec.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: vgoyal@in.ibm.com, k-miyoshi@cb.jp.nec.com,
       Bernhard Walle <bwalle@suse.de>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] add kdump_after_notifier
References: <469F55D0.4050203@ah.jp.nec.com> <20070726140702.GA8949@suse.de>	<20070726153240.GA15969@in.ibm.com> <20070726153440.GA19095@suse.de>	<20070726154415.GB15969@in.ibm.com> <20070726154718.GA25561@suse.de>	<20070726155444.GC15969@in.ibm.com> <46A92E30.8070703@ah.jp.nec.com>	<20070730091624.GB6071@in.ibm.com>	<m16442vwgs.fsf@ebiederm.dsl.xmission.com>	<46AECEE0.3000307@ah.jp.nec.com> <m1fy35t665.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1fy35t665.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Takenori Nagano <t-nagano@ah.jp.nec.com> writes:
>> Hi all,
>>
>> IMHO, most users don't use kdump, kdump users are only kernel developers and
>> enterprise users. 
> 
> Not at all.  So far the only kdump related bug report I have seen has
> been from fedora Core.

Sorry, I thought general users push reset button when the machine is
panicked. :-(

> No.  The problem with your patch is that it doesn't have a code
> impact.  We need to see who is using this and why.

My motivation is very simple. I want to use both kdb and kdump, but I think it
is too weak to satisfy kexec guys. Then I brought up the example enterprise
software. But it isn't a lie. I know some drivers which use panic_notifier.
IMHO, they use only major distribution, and they has the workaround or they
don't notice this problem yet. I think they will be in trouble if all
distributions choose only kdump.

BTW, I use kdb and lkcd now, but I want to use kdb and kdump. I sent a patch to
kdb community but it was rejected. kdb maintainer Keith Owens said,

> Both KDB and crash_kexec should be using the panic_notifier_chain, with
> KDB having a higher priority than crash_exec.  The whole point of
> notifier chains is to handle cases like this, so we should not be
> adding more code to the panic routine.
> 
> The real problem here is the way that the crash_exec code is hard coded
> into various places instead of using notifier chains.  The same issue
> exists in arch/ia64/kernel/mca.c because of bad coding practices from
> kexec.

Then I gave up to merge my patch to kdb, and I tried to send another patch to
kexec community. I can understand his opinion, but it is very difficult to
modify that kdump is called from panic_notifier. Because it has a reason why
kdump don't use panic_notifier. So, I made this patch.

Please do something about this problem.

Thanks,
