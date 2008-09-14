Return-Path: <linux-kernel-owner+w=401wt.eu-S1754740AbYINOSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740AbYINOSS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 10:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754249AbYINOSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 10:18:09 -0400
Received: from gw.goop.org ([64.81.55.164]:46041 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753519AbYINOSI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 10:18:08 -0400
Message-ID: <48CD1D1E.1050906@goop.org>
Date: Sun, 14 Sep 2008 07:18:06 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>, arjan@linux.intel.com,
       tglx@linutronix.de, hpa@zytor.com, andi@firstfloor.org,
       linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [patch 1/2] x86: track memtype for RAM in page struct
References: <20080913000003.732756000@linux-os.sc.intel.com> <20080913000051.819383000@linux-os.sc.intel.com> <48CBF25B.5030107@goop.org> <20080914132952.GC554@elte.hu>
In-Reply-To: <20080914132952.GC554@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> Venkatesh Pallipadi wrote:
>>     
>>> From: Suresh Siddha <suresh.b.siddha@intel.com>
>>> Subject: [patch 1/2] x86: track memtype for RAM in page struct
>>>
>>> Track the memtype for RAM pages in page struct instead of using the memtype
>>> list. This avoids the explosion in the number of entries in memtype list
>>> (of the order of 20,000 with AGP) and makes the PAT tracking simpler. We are
>>> using PG_arch_1 bit in page->flags.
>>>   
>>>       
>> Please define PG_arch_1 a proper name so that its easy to tell its 
>> being used just by looking at page-flags.h.
>>     
>
> it should be defined in include/asm-x86/page.h though, not in 
> page-flags.h - other architectures are using this flag for other 
> purposes.
>   

No, other shared-use flags are all defined in page-flags.h:

enum pageflags {
[...]
	__NR_PAGEFLAGS,

	/* Filesystems */
	PG_checked = PG_owner_priv_1,

	/* XEN */
	PG_pinned = PG_owner_priv_1,
	PG_savepinned = PG_dirty,

	/* SLOB */
	PG_slob_page = PG_active,
	PG_slob_free = PG_private,

	/* SLUB */
	PG_slub_frozen = PG_active,
	PG_slub_debug = PG_error,
};


We could #ifdef CONFIG_X86 just to make it clear we're talking about a
specific X86 usage.  But page-flags.h does seem to have become the
central authority on all struct page flags usage.

    J
