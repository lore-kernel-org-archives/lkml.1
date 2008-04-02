Return-Path: <linux-kernel-owner+w=401wt.eu-S1760181AbYDBGpr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760181AbYDBGpr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 02:45:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754773AbYDBGpj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 02:45:39 -0400
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:36253 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235AbYDBGpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 02:45:38 -0400
Message-ID: <47F32A6B.1070709@linux.vnet.ibm.com>
Date: Wed, 02 Apr 2008 12:10:43 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Paul Menage <menage@google.com>, Pavel Emelianov <xemul@openvz.org>,
       Hugh Dickins <hugh@veritas.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][-mm] Add an owner to the mm_struct (v4)
References: <20080401124312.23664.64616.sendpatchset@localhost.localdomain> <20080402093157.e445acfb.kamezawa.hiroyu@jp.fujitsu.com> <47F2FCAE.7070401@linux.vnet.ibm.com> <20080402135357.04c3e79f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080402135357.04c3e79f.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Wed, 02 Apr 2008 08:55:34 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
>>>> +	/*
>>>> +	 * Search through everything else. We should not get
>>>> +	 * here often
>>>> +	 */
>>>> +	do_each_thread(g, c) {
>>>> +		if (c->mm == mm)
>>>> +			goto assign_new_owner;
>>>> +	} while_each_thread(g, c);
>>> Doing above in synchronized manner seems too heavy.
>>> When this happen ? or Can this be done in lazy "on-demand" manner ?
>>>
>> Do you mean under task_lock()?
>>
> No, scanning itself. 
> How rarely this scan happens under a server which has 10000- threads ?
> 

This routine will be called every time a thread exits, but will quickly exit
after checking mm_need_new_owner()


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
