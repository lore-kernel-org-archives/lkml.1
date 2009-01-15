Return-Path: <linux-kernel-owner+w=401wt.eu-S1757909AbZAOQo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757909AbZAOQo3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 11:44:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751792AbZAOQoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 11:44:17 -0500
Received: from relay2.sgi.com ([192.48.179.30]:54932 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750852AbZAOQoP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 11:44:15 -0500
Message-ID: <496F67D8.4060507@sgi.com>
Date: Thu, 15 Jan 2009 08:44:08 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Rusty Russell <rusty@rustcorp.com.au>, Yinghai Lu <yinghai@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Tony Luck <tony.luck@intel.com>, IA64 <linux-ia64@vger.kernel.org>,
       Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
       David Howells <dhowells@redhat.com>,
       Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
       linux-am33-list@redhat.com, "David S. Miller" <davem@davemloft.net>,
       SPARC <sparclinux@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: crash: IP: [<ffffffff80478092>] __bitmap_intersects+0x48/0x73
 [PATCH supplied]
References: <496BF6D5.9030403@sgi.com> <20090113130048.GB31147@elte.hu> <496CAF5A.3010304@sgi.com> <496D0F46.2010907@sgi.com> <496D2172.6030608@sgi.com> <20090114165431.GA18826@elte.hu> <20090114165524.GA21742@elte.hu> <20090114175126.GA21078@elte.hu> <496E78BA.5040609@sgi.com> <20090115101428.GG5833@elte.hu>
In-Reply-To: <20090115101428.GG5833@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Mike Travis <travis@sgi.com> wrote:
> 
>> Ingo Molnar wrote:
>>> also, with latest tip/master the ia64 cross-build still fails:
>>>
>>> /home/mingo/tip/arch/ia64/kernel/irq_ia64.c: In function `ia64_handle_irq':
>>> /home/mingo/tip/arch/ia64/kernel/irq_ia64.c:498: error: structure has no member named `irqs'
>>> /home/mingo/tip/arch/ia64/kernel/irq_ia64.c:500: error: structure has no member named `irqs'
>>> /home/mingo/tip/arch/ia64/kernel/irq_ia64.c: In function `ia64_process_pending_intr':
>>> /home/mingo/tip/arch/ia64/kernel/irq_ia64.c:556: error: structure has no member named `irqs'
>>> /home/mingo/tip/arch/ia64/kernel/irq_ia64.c:558: error: structure has no member named `irqs'
>>> make[2]: *** [arch/ia64/kernel/irq_ia64.o] Error 1
>>> make[2]: *** Waiting for unfinished jobs....
>>>
>>> and so does the MIPS build:
>>>
>>> /home/mingo/tip/arch/mips/sgi-ip22/ip22-int.c: In function 'indy_buserror_irq':
>>> /home/mingo/tip/arch/mips/sgi-ip22/ip22-int.c:158: error: 'struct kernel_stat' has no member named 'irqs'
>>> make[2]: *** [arch/mips/sgi-ip22/ip22-int.o] Error 1
>>> make[2]: *** Waiting for unfinished jobs....
>>> /home/mingo/tip/arch/mips/sgi-ip22/ip22-time.c: In function 'indy_8254timer_irq':
>>> /home/mingo/tip/arch/mips/sgi-ip22/ip22-time.c:125: error: 'struct kernel_stat' has no member named 'irqs'
>>> make[2]: *** [arch/mips/sgi-ip22/ip22-time.o] Error 1
>>> make[1]: *** [arch/mips/sgi-ip22] Error 2
>>> make[1]: *** Waiting for unfinished jobs....
>>>
>>> 	Ingo
>> Hi Ingo,
>>
>> This appears to be a fallout of the sparse irqs changes.  Here is a 
>> suggested patch.
>>
>> Btw, my ia64 build fails under tip/cpus4096 because this commit is not 
>> present:
>>
>> commit e65e49d0f3714f4a6a42f6f6a19926ba33fcda75
>> Author: Mike Travis <travis@sgi.com>
>> Date:   Mon Jan 12 15:27:13 2009 -0800
>>
>>     irq: update all arches for new irq_desc
> 
> it is present:
> 
>  [mingo@hera tip]$ git log cpus4096 | grep e65e49d
>  commit e65e49d0f3714f4a6a42f6f6a19926ba33fcda75
> 
> 	Ingo

Hmm, the exact same command on my work tree produces nothing.  If I generate
a whole new tip/cpus4096 tree, it's then there.  Once again a victim of 
git remote updating - not!  There must be something that I'm doing wrong:

Non-working tree:

 21> git-describe
v2.6.29-rc1-19-g92296c6

 22> git-status
# On branch cpus4096
# Your branch is behind 'tip/cpus4096' by 233 commits, and can be fast-forwarded.

 23> git-remote update
Updating linus
Updating tip

 24> git-status
# On branch cpus4096
# Your branch is behind 'tip/cpus4096' by 233 commits, and can be fast-forwarded.

 25> git-describe
v2.6.29-rc1-19-g92296c6

New (working) tree:

 2> git-describe
v2.6.29-rc1-252-g5cd7376

???

Thanks,
Mike


