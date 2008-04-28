Return-Path: <linux-kernel-owner+w=401wt.eu-S936314AbYD1QKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936314AbYD1QKk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 12:10:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934092AbYD1QKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 12:10:31 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:34252
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933630AbYD1QKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 12:10:30 -0400
Message-ID: <4815F6F4.2080806@qumranet.com>
Date: Mon, 28 Apr 2008 19:10:28 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Izik Eidus <izike@qumranet.com>
CC: Harvey Harrison <harvey.harrison@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       kvm-devel <kvm-devel@lists.sourceforge.net>
Subject: Re: kvm: how big is type?
References: <1209323919.14173.73.camel@brick> <4815B88B.3010909@qumranet.com> <4815EC08.9000206@qumranet.com>
In-Reply-To: <4815EC08.9000206@qumranet.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Izik Eidus wrote:
> Avi Kivity wrote:
>   
>> Harvey Harrison wrote:
>>     
>>> arch/x86/kvm/x86.c:3484:25: warning: cast truncates bits from constant
>>> value (100 becomes 0)
>>> arch/x86/kvm/x86.c:3510:24: warning: cast truncates bits from constant
>>> value (100 becomes 0)
>>>
>>> The problem:
>>>         cseg_desc.type &= ~(1 << 8); //clear the B flag
>>>         nseg_desc.type |= (1 << 8);
>>>
>>> type is a 4-bit bitfield on x86....please look into this.
>>>
>>>   
>>>       
>> I think it ought to be (1 << 1), not (1 << 8), as it refers to the
>> "busy" bit of the task type.  Izik?
>>
>>
>>     
> From cf6e76c69a38a983df0c84a3dcc2336042eb3436 Mon Sep 17 00:00:00 2001
> From: Izik Eidus <izike@qumranet.com>
> Date: Mon, 28 Apr 2008 18:16:08 +0300
> Subject: [PATCH] KVM: x86: task switch: fix wrong bit setting for the busy flag.
>  the busy bit is in offset of 1 inside type and not in 8.
>   

Applied, thanks.


-- 
error compiling committee.c: too many arguments to function

