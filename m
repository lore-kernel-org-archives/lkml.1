Return-Path: <linux-kernel-owner+w=401wt.eu-S1760131AbZEOISi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760131AbZEOISi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 04:18:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755475AbZEOISU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 04:18:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:46720 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756680AbZEOIST (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 04:18:19 -0400
Message-ID: <4A0D253A.1070705@kernel.org>
Date: Fri, 15 May 2009 17:18:02 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: mingo@elte.hu, andi@firstfloor.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [PATCH 3/5] x86: fix pageattr handling for remap percpu	 allocator
References: <1242361739-21186-1-git-send-email-tj@kernel.org> <1242361739-21186-4-git-send-email-tj@kernel.org> <4A0D3CC6020000780000108F@vpn.id2.novell.com>
In-Reply-To: <4A0D3CC6020000780000108F@vpn.id2.novell.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 15 May 2009 08:18:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Jan Beulich wrote:
>>>> Tejun Heo <tj@kernel.org> 15.05.09 06:28 >>>
>> @@ -742,6 +744,27 @@ static int cpa_process_alias(struct cpa_data *cpa)
>> 	}
>> #endif
>>
>> +	/*
>> +	 * If the PMD page was partially used for per-cpu remapping,
>> +	 * the remapped area needs to be split and modified.  Note
>> +	 * that the partial recycling only happens at the tail of a
>> +	 * partially used PMD page, so touching single PMD page is
>> +	 * always enough.
>> +	 */
>> +	remapped = pcpu_pmd_remapped((void *)vaddr);
> 
> vaddr here is the passed-in address, but in order for the lookup to
> be positive it needs to be the canonical address (i.e. the one
> pointing into the 1:1 mapping), i.e. __va(cpa->pfn << PAGE_SHIFT),
> just like temp_cpa_vaddr gets calculated earlier in the same
> function.

Hmmm... There's no need to match percpu map -> linear addr.  Okay,
right, if the recycled part has been aliased to different vmalloc
mapping than the pfn should be matched.

Thanks for spotting it.  Will posted updated patch.

-- 
tejun
