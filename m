Return-Path: <linux-kernel-owner+w=401wt.eu-S1758307AbXHUHpy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758307AbXHUHpy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 03:45:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751987AbXHUHpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 03:45:44 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:53426 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964AbXHUHpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 03:45:43 -0400
Message-ID: <46CA97FE.90505@ah.jp.nec.com>
Date: Tue, 21 Aug 2007 16:45:02 +0900
From: Takenori Nagano <t-nagano@ah.jp.nec.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: vgoyal@in.ibm.com
CC: Keith Owens <kaos@ocs.com.au>, "Eric W. Biederman" <ebiederm@xmission.com>,
       k-miyoshi@cb.jp.nec.com, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Bernhard Walle <bwalle@suse.de>
Subject: Re: [patch] add kdump_after_notifier
References: <20070802112852.GA7054@in.ibm.com> <31687.1186113947@kao2.melbourne.sgi.com> <20070805110746.GA12540@in.ibm.com> <46C1691E.7090708@ah.jp.nec.com> <20070814083710.GA14538@suse.de> <20070814132454.GA8293@in.ibm.com> <46C4184B.5030303@ah.jp.nec.com> <20070817105630.GA18167@in.ibm.com>
In-Reply-To: <20070817105630.GA18167@in.ibm.com>
Content-Type: text/plain; charset=ISO-2022-JP
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

I think die_val (notify_die() argument) values are arch independent.
They are defined in include/asm-<arch>/kdebug.h.

Your idea is good, but I think it has very large impact. It is very hard to fix
them at the same time. So, how about putting off merging two lists?

 > I think Bernhard's suggestion looks better here. I noticed that
> /sys/kernel/debug is already present. So how about following.
> 
> /sys/kernel/debug/kdump/priority
> /sys/kernel/debug/kdb/priority
> /sys/kernel/debug/IPMI/priority

Good.

> 
> I think at some point of time we shall have to create another file say
> description.
> 
> /sys/kernel/debug/IPMI/description
> 
> Which can tell what does this tool do? Other a user might not have any
> clue how to prioritize various things.

Good idea. :-)

Thanks
