Return-Path: <linux-kernel-owner+w=401wt.eu-S1753775AbYJGOjs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775AbYJGOjs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 10:39:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751373AbYJGOji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 10:39:38 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34811 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752304AbYJGOjh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 10:39:37 -0400
Message-ID: <48EB7406.1010509@redhat.com>
Date: Tue, 07 Oct 2008 16:36:54 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: prasad@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
       Roland McGrath <roland@redhat.com>, akpm@linux-foundation.org,
       mingo@elte.hu, jason.wessel@windriver.com, richardj_moore@uk.ibm.com
Subject: Re: [RFC Patch 0/9] Hardware Breakpoint interfaces
References: <20081007113815.GA23523@in.ibm.com> <48EB5611.9090005@redhat.com> <20081007143217.GA3774@in.ibm.com>
In-Reply-To: <20081007143217.GA3774@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

K.Prasad wrote:
> On Tue, Oct 07, 2008 at 02:29:05PM +0200, Avi Kivity wrote:
>   
>> K.Prasad wrote:
>>     
>>> - Enable KGDB and KVM to use the register_kernel_hw_breakpoint()
>>>   interface for their HW Breakpoint usage, in the absence of which
>>>   they will be broken during simultaneous use.
>>>   
>>>       
>> KVM conceptually isn't a kernel use of the debug registers.  KVM  
>> modifies the debug registers while the guest is running, and restores  
>> them after the guest returns.
>>
>> Right now, as an optimization, KVM defers restoring the debug registers  
>> until after the next context switch out of the kvm task, or until the  
>> next exit to userspace (whichever comes earlier); we should change this  
>> to avoid the deferral if kernel breakpoints are in effect.  This will  
>> allow simultaneous use of KVM breakpoints and kernel breakpoints.
>>
>>     
> The patch posted provides interface for using HW breakpoints on both
> user- and kernel-space breakpoints. KVM's user-space address breakpoint
> requirements, after code-modification, should be made to use
> register_user_hw_breakpoint() interface (presently un-exported but will
> be changed subsequently) to help maintain a system-wide consistent view on the
> availability of HW Breakpoint registers.
>
>   

Correcting myself, actually kvm breakpoints are in a third namespace.  
You could have kernel breakpoints, user breakpoints, and guest 
breakpoints coexisting.

> Presently I find plenty of set_debugreg() calls from kvm/ which will
> modify the registers directly and break the breakpoint register
> management brought-in through the patch.
>   

If kvm restores the registers, should there be any problem?

-- 
error compiling committee.c: too many arguments to function

