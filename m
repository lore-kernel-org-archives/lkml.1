Return-Path: <linux-kernel-owner+w=401wt.eu-S1754889AbZCPSd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889AbZCPSd0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 14:33:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760834AbZCPScv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 14:32:51 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47763 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760804AbZCPScu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 14:32:50 -0400
Message-ID: <49BE9B4A.5040106@redhat.com>
Date: Mon, 16 Mar 2009 20:32:42 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Joerg Roedel <joerg.roedel@amd.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm/x86: check KVM_REQ_TLB_FLUSH with irqs disabled
References: <1237208625-2657-1-git-send-email-joerg.roedel@amd.com> <49BE5054.6040707@redhat.com> <20090316183000.GC3783@amt.cnet>
In-Reply-To: <20090316183000.GC3783@amt.cnet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marcelo Tosatti wrote:
> BTW, I've wondered if the local_irq_enable in svm_vcpu_run is safe:
>
>         clgi();
>
>         local_irq_enable();
>
> There is no way that an interrupt can be handled there without an exit, 
> right?
>   

clgi trumps sti, so all interrupts will be deferred until the guest is 
entered (which will cause an immediate vmexit).

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

