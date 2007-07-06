Return-Path: <linux-kernel-owner+w=401wt.eu-S1764087AbXGFVHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764087AbXGFVHl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 17:07:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761037AbXGFVHe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 17:07:34 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:54859 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760067AbXGFVHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 17:07:33 -0400
Message-ID: <468EAF07.8000902@linux.vnet.ibm.com>
Date: Fri, 06 Jul 2007 14:07:19 -0700
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Dave Hansen <haveblue@us.ibm.com>
CC: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelianov <xemul@openvz.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux MM Mailing List <linux-mm@kvack.org>,
       Eric W Biederman <ebiederm@xmission.com>,
       Linux Containers <containers@lists.osdl.org>,
       Paul Menage <menage@google.com>
Subject: Re: [-mm PATCH 2/8] Memory controller containers setup (v2)
References: <20070706052029.11677.16964.sendpatchset@balbir-laptop> <20070706052103.11677.4158.sendpatchset@balbir-laptop> <1183743009.10287.157.camel@localhost>
In-Reply-To: <1183743009.10287.157.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> On Thu, 2007-07-05 at 22:21 -0700, Balbir Singh wrote:
>> +struct mem_container {
>> +	struct container_subsys_state css;
>> +	/*
>> +	 * the counter to account for memory usage
>> +	 */
>> +	struct res_counter res;
>> +};
> 
> How about we call it "memory_usage"?  That would kill two birds with one
> stone: get rid of the comment, and keep people from needing to refer to
> the comment to figure out what "res" *IS*. 
> 

Hmm.. res is the closest to resource counter. res_cnt is confusing.
res is a generic resource definition to indicate that we are dealing
with generic resource counters.

>> +/*
>> + * A meta page is associated with every page descriptor. The meta page
>> + * helps us identify information about the container
>> + */
>> +struct meta_page {
>> +	struct list_head list;		/* per container LRU list */
>> +	struct page *page;
>> +	struct mem_container *mem_container;
>> +};
> 
> Why not just rename "list" to "lru_list" or "container_lru"?
> 

I think just lru might be fine, meta_page->lru == container LRU.

>> +
>> +static inline struct mem_container *mem_container_from_cont(struct container
>> +								*cnt)
> 
> I'd probably break that line up differently:
> 
> static inline
> struct mem_container *mem_container_from_cont(struct container *cnt)
> 

Yes, that's better.

> BTW, do I see "cnt" meaning "container" now instead of "cnt"?  ;)
> 

Nope, I'll fix it to be cont

> Is somebody's favorite dog named "cnt" and you're just trying to remind
> yourself of them as often as possible?
> 

It's an easy shorthands to use, like i or ref, num.

> -- Dave
> 


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
