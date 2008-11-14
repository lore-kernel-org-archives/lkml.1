Return-Path: <linux-kernel-owner+w=401wt.eu-S1754908AbYKNEHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908AbYKNEHZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 23:07:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751662AbYKNEG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 23:06:56 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53819 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755087AbYKNEGz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 23:06:55 -0500
Message-ID: <491CF8E6.6030608@redhat.com>
Date: Thu, 13 Nov 2008 23:04:54 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: ananth@in.ibm.com, jkenisto@us.ibm.com, davem@davemloft.net,
       linux-kernel@vger.kernel.org, systemtap@sources.redhat.com,
       rusty@rustcorp.com.au
Subject: Re: [PATCH 2/7] kprobes: Add kprobe_insn_mutex and cleanup arch_remove_kprobe()
References: <4919F175.2050009@redhat.com> <20081113162128.28e508ca.akpm@linux-foundation.org>
In-Reply-To: <20081113162128.28e508ca.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Andrew Morton wrote:
> On Tue, 11 Nov 2008 15:56:21 -0500
> Masami Hiramatsu <mhiramat@redhat.com> wrote:
> 
>> Add kprobe_insn_mutex for protecting kprobe_insn_pages hlist, and remove
>> kprobe_mutex from architecture dependent code.
>>
>> This allows us to call arch_remove_kprobe() (and free_insn_slot) while holding
>> kprobe_mutex.
>>
>> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
>> ---
>>  arch/arm/kernel/kprobes.c     |    2 --
>>  arch/ia64/kernel/kprobes.c    |    8 +++++---
>>  arch/powerpc/kernel/kprobes.c |    7 ++++---
>>  arch/s390/kernel/kprobes.c    |    7 ++++---
>>  arch/x86/kernel/kprobes.c     |    7 ++++---
>>  include/linux/kprobes.h       |    1 -
>>  kernel/kprobes.c              |   25 +++++++++++++++++++++----
> 
> For some reasons sparc64 never had this mutex.  You've checked that
> sparc64 will be OK after this change?

I think it's OK for those archs.

Actually, this mutex is protecting insn_slot which stores copied
instructions into executable memory. Some architectures which
doesn't need that special memory have its own buffer in the
arch_specific_insn and they don't use insn_slot. On those arch,
kprobe_insn_mutex is not used (not defined).

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

