Return-Path: <linux-kernel-owner+w=401wt.eu-S1756598AbZCFSWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598AbZCFSWg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 13:22:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751828AbZCFSW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 13:22:27 -0500
Received: from hera.kernel.org ([140.211.167.34]:40225 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750880AbZCFSW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 13:22:26 -0500
Message-ID: <49B1697D.60602@kernel.org>
Date: Fri, 06 Mar 2009 10:20:45 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: introduce bootmem_state
References: <1236257708-27269-7-git-send-email-penberg@cs.helsinki.fi> <49B02498.9080300@kernel.org> <49B02C68.1030203@cs.helsinki.fi> <49B0640A.5080607@kernel.org> <20090306145928.GE21907@elte.hu>
In-Reply-To: <20090306145928.GE21907@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Yinghai Lu <yinghai@kernel.org> wrote:
> 
>> Impact: cleanup
>>
>> extend after_bootmem and after_init_bootmem to bootmem_state 
>> and will have BEFORE_BOOTMEM, DURING_BOOTMEM, AFTER_BOOTMEM
> 
> Ok, that indeed makes all these bootstrap initialization details 
> cleaner and more transparent.
> 
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>
>> ---
>>  arch/x86/kernel/setup.c |    1 +
>>  arch/x86/mm/init.c      |   13 +++++++------
>>  arch/x86/mm/init_32.c   |   28 ++++++++++++++++++++--------
>>  arch/x86/mm/init_64.c   |   33 +++++++++++++++++++--------------
>>  include/linux/mm.h      |    8 ++++++++
>>  5 files changed, 55 insertions(+), 28 deletions(-)
> 
> Note: "git grep after_bootmem" will show you another affected 
> architecture as well.

that is sh, will send patch to them later if needed.

> 
>> +++ linux-2.6/include/linux/mm.h
>> @@ -1067,6 +1067,14 @@ extern void __init mmap_init(void);
>>  extern void show_mem(void);
>>  extern void si_meminfo(struct sysinfo * val);
>>  extern void si_meminfo_node(struct sysinfo *val, int nid);
>> +
>> +enum bootmem_state_t {
>> +	BEFORE_BOOTMEM = 0,
> 
> (nit: =0 is not required. )
some other enum, has it too...
> 
>> +	DURING_BOOTMEM,
>> +	AFTER_BOOTMEM
>> +};
>> +extern enum bootmem_state_t bootmem_state;
> 
> (nit: we put newlines after enum definitions)

ok

YH
