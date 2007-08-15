Return-Path: <linux-kernel-owner+w=401wt.eu-S1761512AbXHOKFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761512AbXHOKFc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 06:05:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755202AbXHOKFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 06:05:16 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:41520 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081AbXHOKFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 06:05:14 -0400
Message-ID: <46C2CF36.7020308@linux.vnet.ibm.com>
Date: Wed, 15 Aug 2007 15:32:30 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
CC: svaidy@linux.vnet.ibm.com, a.p.zijlstra@chello.nl,
       dhaval@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, ebiederm@xmission.com, containers@lists.osdl.org,
       akpm@linux-foundation.org, xemul@openvz.org, menage@google.com
Subject: Re: [-mm PATCH 4/9] Memory controller memory accounting (v4)
References: <46AF2EAA.2080703@linux.vnet.ibm.com> <20070815084454.09B061BF982@siro.lan>
In-Reply-To: <20070815084454.09B061BF982@siro.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

YAMAMOTO Takashi wrote:
>> YAMAMOTO Takashi wrote:
>>>> +	lock_meta_page(page);
>>>> +	/*
>>>> +	 * Check if somebody else beat us to allocating the meta_page
>>>> +	 */
>>>> +	race_mp = page_get_meta_page(page);
>>>> +	if (race_mp) {
>>>> +		kfree(mp);
>>>> +		mp = race_mp;
>>>> +		atomic_inc(&mp->ref_cnt);
>>>> +		res_counter_uncharge(&mem->res, 1);
>>>> +		goto done;
>>>> +	}
>>> i think you need css_put here.
>> Thats correct. We do need css_put in this path.
>>
>> Thanks,
>> Vaidy
> 
> v5 still seems to have the problem.
> 
> YAMAMOTO Takashi
> 

Hi, 

I've got the fix in v6 now, thanks for spotting it.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
