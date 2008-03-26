Return-Path: <linux-kernel-owner+w=401wt.eu-S1756168AbYCZEme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168AbYCZEme (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 00:42:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752044AbYCZEm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 00:42:26 -0400
Received: from mga06.intel.com ([134.134.136.21]:49862 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751959AbYCZEmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 00:42:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,555,1199692800"; 
   d="scan'208";a="265026879"
Message-ID: <47E9D42F.5080506@linux.intel.com>
Date: Tue, 25 Mar 2008 21:42:23 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, bugme-daemon@bugzilla.kernel.org,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       venkatesh.pallipadi@intel.com, bug-track@fisher-privat.net
Subject: Re: [Bug 10328] New: [regression] performance drop for glx
References: <bug-10328-27@http.bugzilla.kernel.org/> <20080325152809.e2b07251.akpm@linux-foundation.org> <20080326003912.GB3313@linux-os.sc.intel.com>
In-Reply-To: <20080326003912.GB3313@linux-os.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Siddha wrote:
> On Tue, Mar 25, 2008 at 03:28:09PM -0700, Andrew Morton wrote:
>> (switched to email.  Please respond via emailed reply-to-all, not via the
>> bugzilla web interface).
>>
>> On Tue, 25 Mar 2008 15:11:15 -0700 (PDT)
>> bugme-daemon@bugzilla.kernel.org wrote:
>>
>>> http://bugzilla.kernel.org/show_bug.cgi?id=10328
>>>
>>>            Summary: [regression] performance drop for glx
>>>
>>> after commit 4138cc3418f5eaa7524ff8e927102863f1ba0ea5 i expirience some grafik
>>> related perfomance issues.
>>>
>>> I used glxgears for test.
>>> before this patch: 1281.005 FPS
>>> and after: 765.000 FPS
>> It nearly halved.
>>
>>> latest tested commit a4083c9271e0a697278e089f2c0b9a95363ada0a
>>> still hase bad performance.
>>>
>>> I use Pentium D with 2GB RAM, Grafick: i945G, ICH7
>>>
>> That's 
>>
>> : commit 4138cc3418f5eaa7524ff8e927102863f1ba0ea5
>> : Author: Siddha, Suresh B <suresh.b.siddha@intel.com>
>> : Date:   Wed Jan 30 13:33:43 2008 +0100
>> : 
>> :     x86: set strong uncacheable where UC is really desired
>> :     
>> :     Also use _PAGE_PWT for all the mappings which need uncache mapping.
>> :     Instead of existing PAT2 which is UC- (and can be overwritten by MTRRs),
>> :     we now use PAT3 which is strong uncacheable.
>> :     
>> :     This makes it consistent with pgprot_noncached()
> 
> Alexey, Can you please try the appended patch?
> 
> Andrew, can you please push the appended patch for 2.6.25? Thanks.
> ---
> 
> fb drivers are using ioremap()/ioremap_nocache(), followed by mtrr_add with
> WC attribute. Recent changes in page attribute code made both
> ioremap()/ioremap_nocache() mappings as UC (instead of previous UC-). This
> breaks the graphics performance, as the effective memory type is UC instead
> of expected WC.
> 
> The correct way to fix this is to add ioremap_wc() (which uses UC- in the
> absence of PAT kernel support and WC with PAT) and change all the
> fb drivers to use this new ioremap_wc() API.
> 
> We can take this correct and longer route for post 2.6.25. For now,
> revert back to the UC- behavior for ioremap/ioremap_nocache.

I would still like to add an ioremap_wc() even in 2.6.25; even if it's for now
identical to ioremap_nocache(). Better get the right API in place as soon as possible

