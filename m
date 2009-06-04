Return-Path: <linux-kernel-owner+w=401wt.eu-S1753685AbZFDNuJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685AbZFDNuJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 09:50:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750893AbZFDNt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 09:49:56 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50230 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750787AbZFDNtz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 09:49:55 -0400
Message-ID: <4A27D0FE.5000609@redhat.com>
Date: Thu, 04 Jun 2009 16:49:50 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: ying.huang@intel.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [2/2] KVM: Add VT-x machine check support
References: <20090604112.650907584@firstfloor.org> <20090604111205.C47C31D0282@basil.firstfloor.org> <4A27B481.5020003@redhat.com> <20090604125123.GY1065@one.firstfloor.org> <4A27C2BF.3090108@redhat.com> <20090604130107.GA1065@one.firstfloor.org> <4A27C7B6.6030709@redhat.com> <20090604132023.GC1065@one.firstfloor.org>
In-Reply-To: <20090604132023.GC1065@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> There's no good place as it breaks the nice exit handler table.  You 
>> could put it in vmx_complete_interrupts() next to NMI handling.
>>     
>
> I think I came up with a easy cheesy but not too bad solution now that should 
> work. It simply remembers the CPU in the vcpu structure and schedules back to 
> it. That's fine for this purpose. 
>   

We might be able schedule back in a timely manner.  Why not hack 
vmx_complete_interrupts()?  You're still in the critical section so 
you're guaranteed no delays or surprises.

-- 
error compiling committee.c: too many arguments to function

