Return-Path: <linux-kernel-owner+w=401wt.eu-S1755936AbYC1Qwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936AbYC1Qwn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 12:52:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753344AbYC1Qwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 12:52:35 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:38236 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284AbYC1Qwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 12:52:34 -0400
Message-ID: <47ED2249.3070602@us.ibm.com>
Date: Fri, 28 Mar 2008 09:52:25 -0700
From: Badari Pulavarty <pbadari@us.ibm.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Kumar Gala <galak@kernel.crashing.org>
CC: lkml <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       Andrew Morton <akpm@linux-foundation.org>, paulus@samba.org,
       Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: Re: [PATCH 4/5] [PPC] update lmb for hotplug memory add/remove
References: <1206664406.19368.2.camel@dyn9047017100.beaverton.ibm.com> <1206664759.19368.11.camel@dyn9047017100.beaverton.ibm.com> <EA08C942-E156-410D-8ADA-7A4812B20221@kernel.crashing.org>
In-Reply-To: <EA08C942-E156-410D-8ADA-7A4812B20221@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kumar Gala wrote:
>
> On Mar 27, 2008, at 7:39 PM, Badari Pulavarty wrote:
>> ppc kernel maintains information about logical memory blocks in
>> lmb.memory structure at the boot time. Its not updated for
>> hotplug memory add/remove. hotplug memory notifier for memory
>> add/remove now updates lmb.memory.
>>
>> This information is useful for eHEA driver to find out the memory
>> layout and holes.
>>
>> NOTE: No special locking is needed for lmb_add() and lmb_remove().
>> Calls to these are serialized by caller. (pSeries_reconfig_chain).
>>
>> Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
>> ---
>> arch/powerpc/platforms/pseries/hotplug-memory.c |   43 +++++++++++++++
>> include/linux/lmb.h                             |    3 -
>> lib/lmb.c                                       |   66 
>> ++++++++++++++++++++----
>> 3 files changed, 102 insertions(+), 10 deletions(-)
>
> How is lmb_remove different than lmb_alloc?
>
> - k
lmb_remove() can be used to punch a hole in to the existing memory block.
lmb_alloc() tries to allocate for a given alignment, I don't think it can
adjust the current entries. Isn't it ?

Thanks,
Badari

