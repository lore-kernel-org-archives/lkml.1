Return-Path: <linux-kernel-owner+w=401wt.eu-S1759647AbZE0DJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759647AbZE0DJy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 23:09:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758248AbZE0DJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 23:09:45 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42818 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757792AbZE0DJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 23:09:44 -0400
Message-ID: <4A1CAF44.7000002@redhat.com>
Date: Wed, 27 May 2009 11:11:00 +0800
From: Amerigo Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090319)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, jdike@addtoit.com, mingo@elte.hu,
       sparclinux@vger.kernel.org, linux-ia64@vger.kernel.org
Subject: Re: [Patch 4/4] module: trim exception table in module_free()
References: <20090526083717.5050.32719.sendpatchset@localhost.localdomain> <20090526083751.5050.60959.sendpatchset@localhost.localdomain> <200905271151.28045.rusty@rustcorp.com.au>
In-Reply-To: <200905271151.28045.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Tue, 26 May 2009 06:05:39 pm Amerigo Wang wrote:
>   
>>  void module_free(struct module *mod, void *module_region)
>>  {
>>  	vfree(module_region);
>> -	/* FIXME: If module_region == mod->init_region, trim exception
>> -	   table entries. */
>> +	if (module_region == mod->module_init)
>> +		mod->num_exentries = 0;
>>  }
>>     
>
> Hi Amerigo,
>
>    This looks wrong.  The extable covers both init and core exception entries.   
> We want to remove the ones in the module_init section.  The good news is that 
> it's sorted, so they're either at the start or the end (except sparc 32).
>   

Hi, Rusty.

Yes? The extable of a module is in '__ex_table' section, and during the 
section transfer, one
section will be either in module_init or module_core, so its entries are 
only in one of them,
not both, right?

Thank you.




