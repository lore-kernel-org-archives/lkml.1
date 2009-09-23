Return-Path: <linux-kernel-owner+w=401wt.eu-S1753527AbZIWQTH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527AbZIWQTH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 12:19:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752195AbZIWQTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 12:19:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56317 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752101AbZIWQTE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 12:19:04 -0400
Date: Wed, 23 Sep 2009 18:18:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@linux.intel.com>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
       tglx@linutronix.de, Yinghai Lu <yinghai@kernel.org>,
       Huang Ying <ying.huang@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-tip-commits@vger.kernel.org
Subject: Re: [boot crash] Re: [tip:x86/mce3] x86, mce: use 64bit machine
	check code on 32bit
Message-ID: <20090923161826.GD6105@elte.hu>
References: <tip-4efc0670baf4b14bc95502e54a83ccf639146125@git.kernel.org> <20090812113652.GA19632@elte.hu> <4A88E3E4.40506@jp.fujitsu.com> <20090817083544.GC15390@elte.hu> <4A891E17.1090901@jp.fujitsu.com> <20090817092047.GB21269@elte.hu> <4A893A14.1070103@linux.intel.com> <20090922154157.GA17497@elte.hu> <4ABA3D31.8020507@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ABA3D31.8020507@linux.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <ak@linux.intel.com> wrote:

> Ingo Molnar wrote:
>
>> Your sloppiness of not fixing mce_rdmsrl() as i requested brought us 
>> this new boot crash regression in 2.6.31, in mce_rdmsrl():
>
> Ingo, that's because the MSRs already have capability bits. If the 
> capability bits don't work we have to find out why, not hack around 
> without understanding it it by using rdmsrl_safe(). Most likely 
> something more is wrong then and it has to be fixed properly.

It is _entirely_ irrelevant whether, according to your opinion, this 
code 'should not crash' because there's MCE capability bits declaring 
that those MSRs should work.

Fact of life is that naked MSR reads are *dangerous*, _especially_ in 
those cases where we use a piece of functionality on a wide category of 
x86 CPUs - like in this case. They result in needless crashes when we 
have much better options, such as to print warning messages. We have 
rdmsrl_safe() for a reason and we use it in a number of critical places.

This is a very simple concept and you simply messed up on multiple 
levels here and fail to even admit to that. I even warned you about that 
very function and you ignored that. Anyway, your opinion doesnt matter 
much here, i fixed this misfeature of the MCE code already. Now we 
should get a nice warn-once boot warning (that can be picked up by 
kerneloops.org, etc.) instead of a nasty boot crash.

	Ingo
