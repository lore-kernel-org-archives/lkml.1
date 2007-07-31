Return-Path: <linux-kernel-owner+w=401wt.eu-S1759863AbXGaMoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759863AbXGaMoo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 08:44:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756511AbXGaMoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 08:44:37 -0400
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:42355 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018AbXGaMog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 08:44:36 -0400
Message-ID: <46AF2EAA.2080703@linux.vnet.ibm.com>
Date: Tue, 31 Jul 2007 18:14:26 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
CC: balbir@linux.vnet.ibm.com, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, ebiederm@xmission.com,
       containers@lists.osdl.org, akpm@linux-foundation.org, xemul@openvz.org,
       menage@google.com, dhaval@linux.vnet.ibm.com
Subject: Re: [-mm PATCH 4/9] Memory controller memory accounting (v4)
References: <20070727201018.31565.42132.sendpatchset@balbir-laptop> <20070731033832.9E8B41BF6B4@siro.lan>
In-Reply-To: <20070731033832.9E8B41BF6B4@siro.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



YAMAMOTO Takashi wrote:
>> +	lock_meta_page(page);
>> +	/*
>> +	 * Check if somebody else beat us to allocating the meta_page
>> +	 */
>> +	race_mp = page_get_meta_page(page);
>> +	if (race_mp) {
>> +		kfree(mp);
>> +		mp = race_mp;
>> +		atomic_inc(&mp->ref_cnt);
>> +		res_counter_uncharge(&mem->res, 1);
>> +		goto done;
>> +	}
> 
> i think you need css_put here.

Thats correct. We do need css_put in this path.

Thanks,
Vaidy

> YAMAMOTO Takashi
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/containers
> 
