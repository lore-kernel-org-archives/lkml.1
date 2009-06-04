Return-Path: <linux-kernel-owner+w=401wt.eu-S1753691AbZFDNKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691AbZFDNKl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 09:10:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754147AbZFDNKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 09:10:19 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42710 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753691AbZFDNKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 09:10:17 -0400
Message-ID: <4A27C7B6.6030709@redhat.com>
Date: Thu, 04 Jun 2009 16:10:14 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: ying.huang@intel.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [2/2] KVM: Add VT-x machine check support
References: <20090604112.650907584@firstfloor.org> <20090604111205.C47C31D0282@basil.firstfloor.org> <4A27B481.5020003@redhat.com> <20090604125123.GY1065@one.firstfloor.org> <4A27C2BF.3090108@redhat.com> <20090604130107.GA1065@one.firstfloor.org>
In-Reply-To: <20090604130107.GA1065@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> vmcs access work because we have a preempt notifier called when we are 
>> scheduled in, and will execute vmclear/vmptrld as necessary.  Look at 
>> kvm_preempt_ops in virt/kvm_main.c.
>>     
>
> I see. So we need to move that check earlier. Do you have a preference
> where it should be?
>   

There's no good place as it breaks the nice exit handler table.  You 
could put it in vmx_complete_interrupts() next to NMI handling.

-- 
error compiling committee.c: too many arguments to function

