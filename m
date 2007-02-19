Return-Path: <linux-kernel-owner+w=401wt.eu-S932065AbXBSKxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932065AbXBSKxb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 05:53:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932067AbXBSKxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 05:53:31 -0500
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:60697 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932065AbXBSKxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 05:53:30 -0500
Message-ID: <45D98173.6060107@in.ibm.com>
Date: Mon, 19 Feb 2007 16:22:35 +0530
From: Balbir Singh <balbir@in.ibm.com>
Reply-To: balbir@in.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.9 (X11/20070103)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: linux-kernel@vger.kernel.org, vatsa@in.ibm.com,
       ckrm-tech@lists.sourceforge.net, xemul@sw.ru, linux-mm@kvack.org,
       menage@google.com, svaidy@linux.vnet.ibm.com, devel@openvz.org
Subject: Re: [RFC][PATCH][3/4] Add reclaim support
References: <20070219065019.3626.33947.sendpatchset@balbir-laptop> <20070219065042.3626.95544.sendpatchset@balbir-laptop> <20070219184839.db9f3bc1.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070219184839.db9f3bc1.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Mon, 19 Feb 2007 12:20:42 +0530
> Balbir Singh <balbir@in.ibm.com> wrote:
> 
>> +int memctlr_mm_overlimit(struct mm_struct *mm, void *sc_cont)
>> +{
>> +	struct container *cont;
>> +	struct memctlr *mem;
>> +	long usage, limit;
>> +	int ret = 1;
>> +
>> +	if (!sc_cont)
>> +		goto out;
>> +
>> +	read_lock(&mm->container_lock);
>> +	cont = mm->container;
> 
>> +out:
>> +	read_unlock(&mm->container_lock);
>> +	return ret;
>> +}
>> +
> 
> should be
> ==
> out_and_unlock:
> 	read_unlock(&mm->container_lock);
> out_:
> 	return ret;
> 


Thanks, that's a much convention!

> 
> -Kame
> 


-- 
	Warm Regards,
	Balbir Singh
