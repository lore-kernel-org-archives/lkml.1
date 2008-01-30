Return-Path: <linux-kernel-owner+w=401wt.eu-S1756695AbYA3V5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695AbYA3V5s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 16:57:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752821AbYA3V5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 16:57:39 -0500
Received: from relay1.sgi.com ([192.48.171.29]:60517 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752770AbYA3V5h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 16:57:37 -0500
Message-ID: <47A0F2CB.3070204@sgi.com>
Date: Wed, 30 Jan 2008 13:57:31 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Andi Kleen <ak@suse.de>,
       Tony Luck <tony.luck@intel.com>, David Miller <davem@davemloft.net>,
       Sam Ravnborg <sam@ravnborg.org>, Rusty Russell <rusty@rustcorp.com.au>,
       linuxppc-dev@ozlabs.org, linux-ia64@vger.kernel.org
Subject: Re: [PATCH 2/6] percpu: Change Kconfig to HAVE_SETUP_PER_CPU_AREA
 linux-2.6.git
References: <20080130180940.022172000@sgi.com> <20080130180940.369732000@sgi.com> <20080130215015.GA28242@elte.hu>
In-Reply-To: <20080130215015.GA28242@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * travis@sgi.com <travis@sgi.com> wrote:
> 
>> Change:
>> 	config ARCH_SETS_UP_PER_CPU_AREA
>> to:
>> 	config HAVE_SETUP_PER_CPU_AREA
> 
> undocumented change:
> 
>>  config ARCH_NO_VIRT_TO_BUS
>> --- a/init/main.c
>> +++ b/init/main.c
>> @@ -380,6 +380,8 @@ static void __init setup_per_cpu_areas(v
>>  
>>  	/* Copy section for each CPU (we discard the original) */
>>  	size = ALIGN(PERCPU_ENOUGH_ROOM, PAGE_SIZE);
>> +	printk(KERN_INFO
>> +	    "PERCPU: Allocating %lu bytes of per cpu data (main)\n", size);
>>  	ptr = alloc_bootmem_pages(size * nr_possible_cpus);
> 
> but looks fine to me.
> 
> 	Ingo

Sorry, I should have noted this.  The primary reason I put this in, is
that if the HAVE_SETUP_PER_CPU_AREA is not set when it should be, then
the incorrect (generic) setup_per_cpu_areas() is used and weird things
happen later on.  The above line documents that PERCPU has been allocated
by init/main.c version of this function in the startup messages.
(Since it's a static function, there is no "duplicate label" error in
the linker.)

Thanks,
Mike
