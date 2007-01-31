Return-Path: <linux-kernel-owner+w=401wt.eu-S932422AbXAaJHH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932422AbXAaJHH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 04:07:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932437AbXAaJHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 04:07:06 -0500
Received: from il.qumranet.com ([62.219.232.206]:51911 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932422AbXAaJHF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 04:07:05 -0500
Message-ID: <45C05C35.9040107@qumranet.com>
Date: Wed, 31 Jan 2007 11:07:01 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: nigel@nigel.suspend2.net, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, akpm@osdl.org, mingo@elte.hu
Subject: Re: [PATCH 5/5] KVM: Host suspend/resume support
References: <45BF5B96.1070007@qumranet.com> <20070130145717.00D1BA0014@il.qumranet.com> <1170192049.4308.16.camel@nigel.suspend2.net> <200701302319.10369.rjw@sisk.pl>
In-Reply-To: <200701302319.10369.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Tuesday, 30 January 2007 22:20, Nigel Cunningham wrote:
>   
>> Hi.
>>
>> On Tue, 2007-01-30 at 14:57 +0000, Avi Kivity wrote:
>>     
>>> Add the necessary callbacks to suspend and resume a host running kvm.  This
>>> is just a repeat of the cpu hotplug/unplug work.
>>>
>>> Signed-off-by: Avi Kivity <avi@qumranet.com>
>>>       
>> Maybe it's just a lack of understanding, but I'm wondering if this patch
>> is necessary - we already hot-unplug secondary cpus prior to suspending
>> devices.
>>     
>
>   

The on_each_cpu() in the patch really means on_this_cpu().


> Not with the reoredering patches that are in -mm, though.  With these patches,
> the nonboot CPUs are disabled after "regular" devices.
>   


After that, it means on_each_cpu() again, and the hotplug patch becomes 
unnecessary (except to support hotplug, of course).

Assuming I understand things correctly, which if not at all certain.


-- 
error compiling committee.c: too many arguments to function

