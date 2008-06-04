Return-Path: <linux-kernel-owner+w=401wt.eu-S1758881AbYFDLQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758881AbYFDLQr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 07:16:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756970AbYFDLQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 07:16:29 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:40576
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757174AbYFDLQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 07:16:28 -0400
Message-ID: <4846798F.2030002@qumranet.com>
Date: Wed, 04 Jun 2008 14:16:31 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Thomas Gleixner <tglx@linutronix.de>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org
Subject: Re: BUG: using smp_processor_id() in preemptible [00000000] code:
 pm-suspend/17334
References: <c4e36d110806030142j379f5a63xfba7c3bbb9df602a@mail.gmail.com>  <Pine.LNX.4.64.0806031350330.1716@twin.jikos.cz> <c4e36d110806030501g46363beev7126c8312aadd12e@mail.gmail.com> <Pine.LNX.4.64.0806031402450.6718@jikos.suse.cz> <alpine.LFD.1.10.0806041252540.3235@apollo.tec.linutronix.de> <Pine.LNX.4.64.0806041312070.10085@jikos.suse.cz>
In-Reply-To: <Pine.LNX.4.64.0806041312070.10085@jikos.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (firebolt.argo.co.il [0.0.0.0]); Wed, 04 Jun 2008 14:16:31 +0300 (IDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> On Wed, 4 Jun 2008, Thomas Gleixner wrote:
>
>   
>>> OK, so it looks like KVM could be wrongly enabling IRQs/preemption on 
>>> the resume path. The original bug-report is on 
>>> http://lkml.org/lkml/2008/4/7/130
>>>       
>> sysdev_resume() is supposed to run with interrupts disabled, at least
>> it was that way when the timekeeping_resume code was written.
>>     
>
> True. However in Zdenek's case, interrupts/preemption gets enabled 
> somewhere during the resume, which correctly triggers the warning.
>
>   

We might add a check to the generic resume controller, to check after 
each ->resume() method and warn in case of interrupts enabled.  That 
will pinpoint the offending driver immediately.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

