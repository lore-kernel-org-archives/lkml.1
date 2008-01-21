Return-Path: <linux-kernel-owner+w=401wt.eu-S1759950AbYAUVjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759950AbYAUVjX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 16:39:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752525AbYAUVjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 16:39:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37204 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366AbYAUVjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 16:39:14 -0500
Message-ID: <479510CE.7010706@zytor.com>
Date: Mon, 21 Jan 2008 13:38:22 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ian Campbell <ijc@hellion.org.uk>
CC: =?UTF-8?B?TWlrYSBQZW50dGlsw6Q=?= <mika.penttila@kolumbus.fi>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] x86: Construct 32 bit boot time page tables in native
 format.
References: <1200758937-22386-1-git-send-email-ijc@hellion.org.uk>	 <1200758937-22386-2-git-send-email-ijc@hellion.org.uk>	 <47939363.8040603@kolumbus.fi> <1200950633.15491.21.camel@cthulhu.hellion.org.uk>
In-Reply-To: <1200950633.15491.21.camel@cthulhu.hellion.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Campbell wrote:
> On Sun, 2008-01-20 at 20:30 +0200, Mika Penttilä wrote:
>>>   
>> You have dropped the requirement to map all of low memory (the boot 
>> allocator is used for instance to construct physical mem mapping). 
>> Either you should fix your INIT_MAP_BEYOND_END or make a big comment 
>> telling us why it isn't necessary anymore to map low mem.
> 
> I think you are right. The patch ensures that all the initial page
> tables themselves have mappings but won't map the additional pages
> needed for mapping the rest of lowmem.
> 
> However, I think it is no longer necessary to map a whole new 4G worth
> of page table pages because the code in kernel_physical_mapping_init now
> extends the initial mappings rather than replacing them (see changes to
> native_pagetable_setup_start). So now we only need to map 4G worth of
> page tables including the initial page tables. That means we only need
> to map a fixed set of extra pages rather than the sliding limit
> currently used in the patch.
> 

We still need to be able to construct those page tables, which is what 
that stuff is about...


> I'm not convinced by the additional 16MB for CONFIG_DEBUG_PAGEALLOC --
> we map enough pages for page tables for 4G of lowmem -- adding space for
> an extra 16M seems pointless.

If so, adjusting the limit should be a separate patch.

Either way, I'm increasingly thinking that setting up the initial page 
tables via an assembly loop instead of worrying about the C accessors is 
actually cleaner (I prototyped it yesterday, although I still need the 
rest of the machinery.)


