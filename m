Return-Path: <linux-kernel-owner+w=401wt.eu-S1756742AbYHYNf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742AbYHYNf7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 09:35:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754524AbYHYNfu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 09:35:50 -0400
Received: from il.qumranet.com ([212.179.150.194]:11822 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754511AbYHYNft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 09:35:49 -0400
Message-ID: <48B2B533.9070509@qumranet.com>
Date: Mon, 25 Aug 2008 16:35:47 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org
Subject: Re: [PATCH] Fix emergency_restart (sysrq-b) with kvm loaded on Intel
 hosts
References: <1219655506-27418-1-git-send-email-avi@qumranet.com>	<20080825091508.GC9114@elte.hu> <m1y72lnsqj.fsf@frodo.ebiederm.org>
In-Reply-To: <m1y72lnsqj.fsf@frodo.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Ingo Molnar <mingo@elte.hu> writes:
>
>   
>> * Avi Kivity <avi@qumranet.com> wrote:
>>
>>     
>>> Enabling Intel VT has the curious side effect whereby the INIT signal 
>>> is blocked.  Rather than comment on the wisdom of this side effect, 
>>> this patch adds an emergency restart reboot notifier, and modifies the 
>>> kvm reboot notifier to disable VT on emergency reboot.
>>>       
>
> Please no notifiers in emergency_restart.
>
> First emergency_restart is not supposed to work reliably it is a best effort tickle
> the hardware thing.
>
> Second and more importantly whenever someone adds a notifier instead of a proper hook
> to one a code path like this it seems like avoiding building a proper interface so
> and I believe keeps us from getting all of the logic and the heuristics right.
>
> Why not just add a disable intel_vt if it is enabled call?
>
>   

We need to do it across all cpus.

However, a reliable (and simpler) fix has emerged: reset via ACPI.  That 
causes a true reset which VT does not block.


-- 
error compiling committee.c: too many arguments to function

