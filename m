Return-Path: <linux-kernel-owner+w=401wt.eu-S1756584AbZF1Niu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756584AbZF1Niu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 09:38:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755939AbZF1Nil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 09:38:41 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37450 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753328AbZF1Nik (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 09:38:40 -0400
Message-ID: <4A4772B5.5030008@redhat.com>
Date: Sun, 28 Jun 2009 16:40:05 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mst@redhat.com,
       paulmck@linux.vnet.ibm.com, davidel@xmailserver.org,
       rusty@rustcorp.com.au
Subject: Re: [KVM PATCH v5 0/4] irqfd fixes and enhancements
References: <20090625132441.26748.641.stgit@dev.haskins.net> <4A4382AE.8000508@novell.com> <4A474E04.3070608@redhat.com> <4A476927.4010900@novell.com>
In-Reply-To: <4A476927.4010900@novell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2009 03:59 PM, Gregory Haskins wrote:
>> I agree that we want POLLHUP support, it's better than holding on to
>> the eventfd.  But I think we can make it even cleaner by merging it
>> with deassign.  Basically, when we get POLLHUP, we launch a slow_work
>> (or something) that does a regular deassign.  That slow_work can grab
>> a ref to the vm, so we don't race with the VM disappearing.
>>
>> But given that the current slow_work does almost nothing, I'm not sure
>> it's worth it.
>>      
>
> Yeah, and also note that the algorithm to unhook each side is not quite
> symmetrical.  I think I've captured all the common parts (in things like
> irqfd_deactivate(), etc).  A minor change in kvm_irqfd_release() could
> technically use a deferred job to release instead of doing it inline,
> but I do not think it buys us very much to do so (as you pointed out,
> the defered part is actually fairly simple).  The important parts of the
> protocol lie outside of the work we can do in the work-item anyway.
>    

Is the case of deassign vs POLLHUP covered?

Reusing deassign in POLLHUP at least makes it easy to verify that it is.

-- 
error compiling committee.c: too many arguments to function

