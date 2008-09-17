Return-Path: <linux-kernel-owner+w=401wt.eu-S1754981AbYIQPjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981AbYIQPjm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 11:39:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754256AbYIQPjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 11:39:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43713 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754239AbYIQPjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 11:39:32 -0400
Message-ID: <48D12490.5010003@zytor.com>
Date: Wed, 17 Sep 2008 08:38:56 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Yan Li <elliot.li.tech@gmail.com>, linux-kernel@vger.kernel.org,
       joerg.roedel@amd.com, rjmaomao@gmail.com,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, nancydreaming@gmail.com
Subject: Re: [PATCH 1/2] VMware detection support for x86 and x86-64
References: <20080221115452.GB13948@elte.hu> <20080907234510.GA24133@yantp.cn.ibm.com> <20080908140423.GG11993@elte.hu> <20080909002055.GA8573@yantp.cn.ibm.com> <48C5C47F.5040004@zytor.com> <20080916133239.GA17456@yantp.cn.ibm.com> <20080917105238.GF18764@elte.hu> <20080917140357.GA23523@yantp.cn.ibm.com> <20080917141030.GC20510@elte.hu>
In-Reply-To: <20080917141030.GC20510@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> that still leaves the CPUID/MSR method for the virtualizer to announce 
> itself.
> 

FWIW, it's getting pretty clear with the recent bout of Virtual PC bugs 
that we need virtualizer detection, and that a lot of VMs are doing 
various idiotic things.

Again, with Virtual PC, it seems that DMI is the preferred detection 
method, as disgusting as it is, simply because the alternatives are the 
moral equivalent of ad hoc probing for ISA cards (a random I/O port for 
VMWare, a random "hopefully unused" opcode for VPC.)

>> I feel It's also unfit to touch the whole PCI or DMI thing before CPU 
>> registers and memory are settled.  A simple solution here is to only 
>> issue a KERN_INFO when we detected mtrr is empty and later, when we 
>> can be sure that the OS is not running as a VM, issue a warning. The 
>> later part can be done in early_quirks().
> 
> ok, we can move the MTRR message further back, to after the early quirks 
> phase.

Makes sense to me.

	-hpa

