Return-Path: <linux-kernel-owner+w=401wt.eu-S1753413AbYC1EUt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413AbYC1EUt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 00:20:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750830AbYC1EUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 00:20:38 -0400
Received: from gw.goop.org ([64.81.55.164]:48921 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822AbYC1EUi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 00:20:38 -0400
Message-ID: <47EC7202.3040009@goop.org>
Date: Thu, 27 Mar 2008 21:20:18 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Yasunori Goto <y-goto@jp.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Lameter <clameter@sgi.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2 of 4] hotplug-memory: adding non-section-aligned memory
 is bad
References: <e0b16cc8349b38a5f3f9.1206664118@localhost>	<20080328102719.3ab9162b.kamezawa.hiroyu@jp.fujitsu.com>	<20080328102342.B0BF.E1E9C6FF@jp.fujitsu.com>	<20080328105406.5dc61c6c.kamezawa.hiroyu@jp.fujitsu.com>	<47EC5440.5020107@goop.org>	<20080328113312.65cca8b5.kamezawa.hiroyu@jp.fujitsu.com>	<47EC5D2E.8060001@goop.org> <20080328121758.7f355925.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080328121758.7f355925.kamezawa.hiroyu@jp.fujitsu.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Thu, 27 Mar 2008 19:51:26 -0700
> Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>>> (I wrote online_page() in above, but online_pages() is maybe better.
>>>  It does all what you want.)
>>>   
>>>       
>> No, for my use-case the pages must be onlined one by one as they get 
>> some physical memory assigned to them.  At the time I do add_memory(), 
>> I'm just allocating page structures, but there's no memory backing that 
>> range.
>>
>>     
> yes, I see.
>
>   
>> That's why I need to disable the sysfs onlining interface, because it 
>> bulk onlines the pages before there's anything behind them.
>>
>>     
>
> My point is. online_pages() does following things.
>
> - call notifier
> - update information , total_pages etc...
> - re-configure zonelist if necessary...
>
> But online_page() not. Hmm...
>
> How about capturing online_page() by balloon ?
>   

You're saying that using online_page() on each page on its own is not 
sufficient?

> ex.)
> ==
> call add_memory() to create mem_map
> call online_pages() against the whole section. <=== call this without sysfs.
>      online_pages() do misc. jobs
>         call online_page() one by one (arch dependent) called by walk_memory_resource.
>             online_page() will finally call free_page(page).
>             <=========== Xen capture here.
>             Don't free onlined page and swallow them into baloon driver.
> ==
>   

I'm not sure what you mean by "capture" here.  Do you mean a hook?  I'd 
rather not have to put some Xen-specific hook in here.

What would happen if I did online_pages(pfn, 1) on each page as I 
populate it?

    J
