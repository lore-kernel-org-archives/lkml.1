Return-Path: <linux-kernel-owner+w=401wt.eu-S1754636AbZD0LYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636AbZD0LYT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 07:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753361AbZD0LYD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 07:24:03 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37144 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753147AbZD0LYC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 07:24:02 -0400
Message-ID: <49F595C9.3080907@redhat.com>
Date: Mon, 27 Apr 2009 14:23:53 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, davidel@xmailserver.org
Subject: Re: [KVM PATCH v2 2/2] kvm: add support for irqfd via	eventfd-notification
 interface
References: <20090424042142.1796.60756.stgit@dev.haskins.net> <20090424042518.1796.65593.stgit@dev.haskins.net> <49F572EF.4010909@redhat.com> <49F58A8C.7090808@novell.com> <49F58FD6.907@novell.com>
In-Reply-To: <49F58FD6.907@novell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
> Something else to consider:  eventfd supports calling eventfd_signal()
> from interrupt context, so
> even if the callback were not invoked from a preempt/irq off CS due to
> the wqh->lock, the context may still be a CS anyway.  Now, userspace and
> vbus based injection do not need to worry about this, but I wonder if
> this is a  desirable attribute for some other source (device-assignment
> perhaps)?
>   

I'm no networking expert, but device assignment certainly wants to queue 
an interrupt from an interrupt (basically it forwards the interrupt from 
host to guest).  Block is also simple enough to trigger the interrupt 
from the completion context.

For networking, we'd eventually want to do the host->guest copy using a 
dma engine, and we'd want to inject the interrupt from the dma engine's 
completion handler.


> If so, is there a way to design the lockless-injection code such that
> its still friendly to irq-context, or is this a mode that we would never
> want to support anyway?  I think this would be a good thing to have at
> least to maintain compatibility with the existing eventfd interface,
> which has its own advantages.
>   

This has RCU painted all over it in a 1200-point font.

-- 
error compiling committee.c: too many arguments to function

