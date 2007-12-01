Return-Path: <linux-kernel-owner+w=401wt.eu-S1760198AbXLACwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760198AbXLACwx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 21:52:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756151AbXLACwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 21:52:43 -0500
Received: from rtr.ca ([76.10.145.34]:1221 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755257AbXLACwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 21:52:42 -0500
Message-ID: <4750CC78.9070105@rtr.ca>
Date: Fri, 30 Nov 2007 21:52:40 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, abelay@novell.com,
       lenb@kernel.org, mlord@pobox.com, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: + restore-missing-sysfs-max_cstate-attr.patch added to -mm tree
References: <200711302153.lAULrZ7n026255@imap1.linux-foundation.org><924EFEDD5F540B4284297C4DC59F3DEE2FAE6A@orsmsx423.amr.corp.intel.com> <20071130142058.816d1693.akpm@linux-foundation.org> <924EFEDD5F540B4284297C4DC59F3DEE2FAEAF@orsmsx423.amr.corp.intel.com>
In-Reply-To: <924EFEDD5F540B4284297C4DC59F3DEE2FAEAF@orsmsx423.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pallipadi, Venkatesh wrote:
>  
> 
>> On Fri, 30 Nov 2007 14:06:55 -0800
>> "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com> wrote:
>>
>> Please dont go off-list like this.  I put Mark's original 
>> mailing list cc's
>> back.
> 
> Sorry for missing some cc's earlier. I blindly did a reply-all to the
> mm-commits mail I got.
> 
>>> I will have to Nack this. The reason max_cstate was initentionally
>>> removed due to couple of reasons:
>> It broke userspace without any warning or migration period, afaict.
> 
> Yes. That's true. I will have to take the blame for that. It has been
> known for a while during cpuidle development. But, it was never
> documented as deprecating.
>  
>>> 1) All in kernel users of max_cstate should rather be using
>>> pm_qos/latency interfaces. All such max_cstate usages must already be
>>> migrated.
>> That code isn't merged.
> 
> All kernel part is already merged. I mean, there are do drivers that
> depend on max_cstate. They use latency_notifier thing today and their
> migration to pm_qos part is not merged yet.
> 
>>> 2) Supporting max_cstate as a dynamic parameter cleanly is no longer
>>> possible in acpi/processor_idle.c as the C-state policy has moved to
>>> cpuidle instead. It can be done if it is needed. But, just 
>> below patch
>>> will not really work with cpuidle.
>>>
>>> Selecting max_cstate at boot time as a debug option still 
>> works without
>>> this patch.
>>>
>>> So, just this patch will not get back the functionality with cpuidle.
>>> Infact changing it at run time will have no effect. Question 
>> however is:
>>> Is there a real need to revive this parameter so that user can change
>>> max_cstate at run time?
>> It is not known whether Mark is actually writing to this 
>> thing.  Perhaps
>> read-only permissions would be a suitable fix?
>>
> 
> Exporting it as read only should be OK. We also need to know if there
> are hard user space dependency on writing to this from userspace.
..

Well, actually..  my scripts have a firm need to write "1" to it,
and then later restore the original value.

This is needed to *greatly* speed up an otherwise sluggish binary I use,
as well as whenever I want to semi-accurately benchmark I/O.

Is there another way to achieve exactly the same behaviour?

Thanks
