Return-Path: <linux-kernel-owner+w=401wt.eu-S1764108AbZDAMYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764108AbZDAMYt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 08:24:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762957AbZDAMYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 08:24:25 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43347 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763146AbZDAMYY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 08:24:24 -0400
Message-ID: <49D35D12.6080209@redhat.com>
Date: Wed, 01 Apr 2009 15:24:50 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: linux-kernel@vger.kernel.org, agraf@suse.de, pmullaney@novell.com,
       pmorreale@novell.com, anthony@codemonkey.ws, rusty@rustcorp.com.au,
       netdev@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 01/17] shm-signal: shared-memory signals
References: <20090331184057.28333.77287.stgit@dev.haskins.net> <20090331184252.28333.70623.stgit@dev.haskins.net> <49D280C0.8010802@redhat.com> <49D283F7.7030508@novell.com> <49D285AE.7030604@redhat.com> <49D35A2B.10907@novell.com>
In-Reply-To: <49D35A2B.10907@novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
> Note that this is exactly what I do (though it is device specific). 
> venet-tap has a ioq_notifier registered on its "rx" ring (which is the
> tx-ring for the guest) that simply calls ioq_notify_disable() (which
> calls shm_signal_disable() under the covers) and it wakes its
> rx-thread.  This all happens in the context of the hypercall, which then
> returns and allows the vcpu to re-enter guest mode immediately.
>   
I think this is suboptimal.  The ring is likely to be cache hot on the 
current cpu, waking a thread will introduce scheduling latency + IPI 
+cache-to-cache transfers.

On a benchmark setup, host resources are likely to exceed guest 
requirements, so you can throw cpu at the problem and no one notices.  
But I think the bits/cycle figure will decrease, even if bits/sec increases.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

