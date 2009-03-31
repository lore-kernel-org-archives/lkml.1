Return-Path: <linux-kernel-owner+w=401wt.eu-S1761977AbZCaU7B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761977AbZCaU7B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 16:59:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754008AbZCaU6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 16:58:47 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46287 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753094AbZCaU6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 16:58:45 -0400
Message-ID: <49D28421.4020308@redhat.com>
Date: Tue, 31 Mar 2009 23:59:13 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: linux-kernel@vger.kernel.org, agraf@suse.de, pmullaney@novell.com,
       pmorreale@novell.com, anthony@codemonkey.ws, rusty@rustcorp.com.au,
       netdev@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 15/17] kvm: add dynamic IRQ support
References: <20090331184057.28333.77287.stgit@dev.haskins.net> <20090331184405.28333.59205.stgit@dev.haskins.net> <49D26CFE.1060700@redhat.com> <49D2718F.9070203@novell.com> <49D27950.9020801@redhat.com> <49D27DD3.5080609@novell.com>
In-Reply-To: <49D27DD3.5080609@novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
>> Won't this have scaling issues?  One IRQ means one target vcpu. 
>> Whereas I'd like virtio devices to span multiple queues, each queue
>> with its own MSI IRQ.
>>     
> Hmm..you know I hadnt really thought of it that way, but you have a
> point.  To clarify, my design actually uses one IRQ per "eventq", where
> we can have an arbitrary number of eventq's defined (note: today I only
> define one eventq, however).  An eventq is actually a shm-ring construct
> where I can pass events up to the host like "device added" or "ring X
> signaled".  Each individual device based virtio-ring would then
> aggregates "signal" events onto this eventq mechanism to actually inject
> events to the host.  Only the eventq itself injects an actual IRQ to the
> assigned vcpu.
>   

You will get get cachelines bounced around when events from different 
devices are added to the queue.  On the plus side, a single injection 
can contain interrupts for multiple devices.

I'm not sure how useful this coalescing is; certainly you will never see 
it on microbenchmarks, but that doesn't mean it's not useful.


-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

