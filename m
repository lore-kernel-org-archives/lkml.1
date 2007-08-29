Return-Path: <linux-kernel-owner+w=401wt.eu-S1760664AbXH2WEa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760664AbXH2WEa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 18:04:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751681AbXH2WEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 18:04:20 -0400
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:49411 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414AbXH2WEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 18:04:20 -0400
Message-ID: <46D5ED5C.9030405@linux.vnet.ibm.com>
Date: Thu, 30 Aug 2007 03:34:12 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Dave Hansen <haveblue@us.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux MM Mailing List <linux-mm@kvack.org>,
       David Rientjes <rientjes@google.com>,
       Linux Containers <containers@lists.osdl.org>,
       Paul Menage <menage@google.com>
Subject: Re: [-mm PATCH]  Memory controller improve user interface
References: <20070829111030.9987.8104.sendpatchset@balbir-laptop> <1188413148.28903.113.camel@localhost>
In-Reply-To: <1188413148.28903.113.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> On Wed, 2007-08-29 at 16:40 +0530, Balbir Singh wrote:
>>
>> @@ -352,7 +353,7 @@ int mem_container_charge(struct page *pa
>>                 kfree(pc);
>>                 pc = race_pc;
>>                 atomic_inc(&pc->ref_cnt);
>> -               res_counter_uncharge(&mem->res, 1);
>> +               res_counter_uncharge(&mem->res, MEM_CONTAINER_CHARGE_KB);
>>                 css_put(&mem->css);
>>                 goto done;
>>         } 
> 
> Do these changes really need to happen anywhere besides the
> user<->kernel boundary?  Why can't internal tracking be in pages?

I've thought about this before. The problem is that a user could
set his limit to 10000 bytes, but would then see the usage and
limit round to the closest page boundary. This can be confusing
to a user.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
