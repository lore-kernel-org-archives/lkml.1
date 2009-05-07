Return-Path: <linux-kernel-owner+w=401wt.eu-S1761542AbZEGMaM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761542AbZEGMaM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 08:30:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755007AbZEGM34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 08:29:56 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47496 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752606AbZEGM3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 08:29:55 -0400
Message-ID: <4A02D40D.7060307@redhat.com>
Date: Thu, 07 May 2009 15:29:01 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: Chris Wright <chrisw@sous-sol.org>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] generic hypercall support
References: <20090505132005.19891.78436.stgit@dev.haskins.net> <4A0040C0.1080102@redhat.com> <4A0041BA.6060106@novell.com> <4A004676.4050604@redhat.com> <4A0049CD.3080003@gmail.com> <20090505231718.GT3036@sequoia.sous-sol.org> <4A010927.6020207@novell.com> <20090506072212.GV3036@sequoia.sous-sol.org> <4A018DF2.6010301@novell.com>
In-Reply-To: <4A018DF2.6010301@novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
> Chris Wright wrote:
>   
>> * Gregory Haskins (ghaskins@novell.com) wrote:
>>   
>>     
>>> Chris Wright wrote:
>>>     
>>>       
>>>> But a free-form hypercall(unsigned long nr, unsigned long *args, size_t count)
>>>> means hypercall number and arg list must be the same in order for code
>>>> to call hypercall() in a hypervisor agnostic way.
>>>>       
>>>>         
>>> Yes, and that is exactly the intention.  I think its perhaps the point
>>> you are missing.
>>>     
>>>       
>> Yes, I was reading this as purely any hypercall, but it seems a bit
>> more like:
>>  pv_io_ops->iomap()
>>  pv_io_ops->ioread()
>>  pv_io_ops->iowrite()
>>   
>>     
>
> Right.
>   

Hmm, reminds me of something I thought of a while back.

We could implement an 'mmio hypercall' that does mmio reads/writes via a 
hypercall instead of an mmio operation.  That will speed up mmio for 
emulated devices (say, e1000).  It's easy to hook into Linux 
(readl/writel), is pci-friendly, non-x86 friendly, etc.

It also makes the device work when hypercall support is not available 
(qemu/tcg); you simply fall back on mmio.

-- 
error compiling committee.c: too many arguments to function

