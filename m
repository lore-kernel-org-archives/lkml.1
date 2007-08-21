Return-Path: <linux-kernel-owner+w=401wt.eu-S1760161AbXHUNOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760161AbXHUNOX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 09:14:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756562AbXHUNOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 09:14:12 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:44259 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757253AbXHUNOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 09:14:11 -0400
Message-ID: <46CAE627.7070908@sgi.com>
Date: Tue, 21 Aug 2007 06:18:31 -0700
From: Jay Lan <jlan@sgi.com>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: vgoyal@in.ibm.com
CC: Takenori Nagano <t-nagano@ah.jp.nec.com>, k-miyoshi@cb.jp.nec.com,
       Bernhard Walle <bwalle@suse.de>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Keith Owens <kaos@ocs.com.au>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] add kdump_after_notifier
References: <20070802112852.GA7054@in.ibm.com>	<31687.1186113947@kao2.melbourne.sgi.com>	<20070805110746.GA12540@in.ibm.com>	<46C1691E.7090708@ah.jp.nec.com> <20070814083710.GA14538@suse.de>	<20070814132454.GA8293@in.ibm.com> <46C4184B.5030303@ah.jp.nec.com> <20070817105630.GA18167@in.ibm.com>
In-Reply-To: <20070817105630.GA18167@in.ibm.com>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> On Thu, Aug 16, 2007 at 06:26:35PM +0900, Takenori Nagano wrote:
>> Vivek Goyal wrote:
>>  > So for the time being I think we can put RAS tools on die notifier list
>>> and if it runs into issues we can always think of creating a separate list.
>>>
>>> Few things come to mind.
>>>
>>> - Why there is a separate panic_notifier_list? Can't it be merged with
>>>   die_chain? die_val already got one of the event type as PANIC. If there
>>>   are no specific reasons then we should merge the two lists. Registering
>>>   RAS tools on a single list is easier.
>> I think it is difficult, because die_chain is defined by each architecture.
>>
> 
> I think die_chain is arch independent definition (kernel/die_notifier.c)? 
> But anyway, to begin with it can be done only for panic_notifier.
> 
>>> - Modify Kdump to register on die_chain list. 
>>> - Modify Kdb to register on die_chain list.
>>> - Export all the registered members of die_chain through sysfs along with
>>>   their priorities. Priorities should be modifiable. Most likely one 
>>>   shall have to introduce additional field in struct notifier_block. This
>>>   field will be a string as an identifier of the user registerd. e.g
>>>   "Kdump", "Kdb" etc.
>>>
>>> Now user will be able to view all the die_chain users through sysfs and
>>> be able to modify the order in which these should run by modifying their
>>> priority. Hence all the RAS tools can co-exist.
>> This is my image of your proposal.
>>
>> - Print current order
>>
>> # cat /sys/class/misc/debug/panic_notifier_list
>> priority   name
>> 1          IPMI
>> 2          watchdog
>> 3          Kdb
>> 4          Kdump
>>
> 
> I think Bernhard's suggestion looks better here. I noticed that 
> /sys/kernel/debug is already present. So how about following.
> 
> /sys/kernel/debug/kdump/priority
> /sys/kernel/debug/kdb/priority
> /sys/kernel/debug/IPMI/priority

Why separate priority files is better than a central file?
At least i think you get a grand picture of priority being
defined for all parties with a central file?

What do we decide priority if more than one component has
the same priority value?

Thanks,
 - jay

> 
> I think at some point of time we shall have to create another file say
> description.
> 
> /sys/kernel/debug/IPMI/description
> 
> Which can tell what does this tool do? Other a user might not have any
> clue how to prioritize various things.
> 
> Thanks
> Vivek
> 

