Return-Path: <linux-kernel-owner+w=401wt.eu-S1754531Ab0AURNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531Ab0AURNT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 12:13:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753801Ab0AURNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 12:13:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2072 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752631Ab0AURNR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 12:13:17 -0500
Message-ID: <4B588B29.2050100@redhat.com>
Date: Thu, 21 Jan 2010 19:13:13 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: "Michael S. Tsirkin" <mst@redhat.com>, mtosatti@redhat.com,
       kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 1/3] eventfd: allow atomic read and waitqueue remove
References: <20100121162648.GA16458@redhat.com> <alpine.DEB.2.00.1001210857310.8548@makko.or.mcafeemobile.com>
In-Reply-To: <alpine.DEB.2.00.1001210857310.8548@makko.or.mcafeemobile.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2010 06:58 PM, Davide Libenzi wrote:
> On Thu, 21 Jan 2010, Michael S. Tsirkin wrote:
>
>    
>> This is a backport of commit: 03db343a6320f780937078433fa7d8da955e6fce
>> modified in a way that introduces some code duplication on the one hand,
>> but reduces the risk of regressing existing eventfd users on the other
>> hand.
>>
>> KVM needs a wait to atomically remove themselves from the eventfd
>> ->poll() wait queue head, in order to handle correctly their IRQfd
>> deassign operation.
>>
>> This patch introduces such API, plus a way to read an eventfd from its
>> context.
>>
>> Signed-off-by: Michael S. Tsirkin<mst@redhat.com>
>> ---
>>
>> Avi, Davidel, how about only including the following part for -stable
>> then?  Reason is, I still would like to be able to use irqfd there, and
>> getting spurious interrupts 100% of times unmask is done isn't a very
>> good idea IMO ...
>>      
> It's the same thing. Unless there are *real* problems in KVM due to the
> spurious ints, I still think this is .33 material.
>    

I agree.

But I think we can solve this in another way in .32: we can clear the 
eventfd from irqfd->inject work, which is in process context.  The new 
stuff is only needed for lockless clearing, no?

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

