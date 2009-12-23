Return-Path: <linux-kernel-owner+w=401wt.eu-S1755941AbZLWXEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941AbZLWXEf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 18:04:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754693AbZLWXEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 18:04:34 -0500
Received: from mail.windriver.com ([147.11.1.11]:57633 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754264AbZLWXEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 18:04:34 -0500
Message-ID: <4B32A1EB.2020805@windriver.com>
Date: Wed, 23 Dec 2009 17:04:11 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       kdb@oss.sgi.com, mingo@elte.hu
Subject: Re: [PATCH 07/37] kgdb,sparc: Add in kgdb_arch_set_pc for sparc
References: <1261603190-5036-6-git-send-email-jason.wessel@windriver.com><1261603190-5036-7-git-send-email-jason.wessel@windriver.com><1261603190-5036-8-git-send-email-jason.wessel@windriver.com> <20091223.134837.189694575.davem@davemloft.net>
In-Reply-To: <20091223.134837.189694575.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Dec 2009 23:04:10.0763 (UTC) FILETIME=[3CD2FDB0:01CA8424]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


David Miller wrote:
> From: Jason Wessel <jason.wessel@windriver.com>
> Date: Wed, 23 Dec 2009 15:19:20 -0600
>
>   
>> +void kgdb_arch_set_pc(struct pt_regs *regs, unsigned long ip)
>> +{
>> +       regs->pc = regs->npc;
>> +       regs->npc = ip;
>> +}
>> +
>>     
>
> Is this right?
>
> It should probably be something like:
>
>   
Just because it didn't crash doesn't mean it is right :-)

I'll go with your implementation which according to the instruction
manual is the right way.  This particular function doesn't really get
exercised with out the arch specific hardware or software single
stepping code, which is not a part of this series at the moment.

This fix and the other fix you asked about are both in kgdb-next which
feeds into linux-next, if you are ultimately ok with the changes, I'll
add an ack from you as well.

Hopefully there is enough time to get the kdb shape for the next kernel
merge window.

http://git.kernel.org/?p=linux/kernel/git/jwessel/linux-2.6-kgdb.git;a=commitdiff;h=ed088ec6e6e7e245c060d068d333648eff06dd4b
and
http://git.kernel.org/?p=linux/kernel/git/jwessel/linux-2.6-kgdb.git;a=commitdiff;h=c5dc61eb8d1c347ff3eadc1bccae07437d85779a

Thanks,
Jason.

