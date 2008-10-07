Return-Path: <linux-kernel-owner+w=401wt.eu-S1755829AbYJGQqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755829AbYJGQqW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 12:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753423AbYJGQqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 12:46:14 -0400
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:54549 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014AbYJGQqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 12:46:13 -0400
Date: Tue, 7 Oct 2008 22:15:35 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Avi Kivity <avi@redhat.com>
Cc: linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
       Roland McGrath <roland@redhat.com>, akpm@linux-foundation.org,
       mingo@elte.hu, jason.wessel@windriver.com, richardj_moore@uk.ibm.com
Subject: Re: [RFC Patch 0/9] Hardware Breakpoint interfaces
Message-ID: <20081007164535.GA4130@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20081007113815.GA23523@in.ibm.com> <48EB5611.9090005@redhat.com> <20081007143217.GA3774@in.ibm.com> <48EB7406.1010509@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48EB7406.1010509@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2008 at 04:36:54PM +0200, Avi Kivity wrote:
> K.Prasad wrote:
>> On Tue, Oct 07, 2008 at 02:29:05PM +0200, Avi Kivity wrote:
>>   
>>> K.Prasad wrote:
>>>     
>>>> - Enable KGDB and KVM to use the register_kernel_hw_breakpoint()
>>>>   interface for their HW Breakpoint usage, in the absence of which
>>>>   they will be broken during simultaneous use.
>>>>         
>>> KVM conceptually isn't a kernel use of the debug registers.  KVM   
>>> modifies the debug registers while the guest is running, and restores 
>>>  them after the guest returns.
>>>
>>> Right now, as an optimization, KVM defers restoring the debug 
>>> registers  until after the next context switch out of the kvm task, 
>>> or until the  next exit to userspace (whichever comes earlier); we 
>>> should change this  to avoid the deferral if kernel breakpoints are 
>>> in effect.  This will  allow simultaneous use of KVM breakpoints and 
>>> kernel breakpoints.
>>>
>>>     
>> The patch posted provides interface for using HW breakpoints on both
>> user- and kernel-space breakpoints. KVM's user-space address breakpoint
>> requirements, after code-modification, should be made to use
>> register_user_hw_breakpoint() interface (presently un-exported but will
>> be changed subsequently) to help maintain a system-wide consistent view on the
>> availability of HW Breakpoint registers.
>>
>>   
>
> Correcting myself, actually kvm breakpoints are in a third namespace.   
> You could have kernel breakpoints, user breakpoints, and guest  
> breakpoints coexisting.
>
>> Presently I find plenty of set_debugreg() calls from kvm/ which will
>> modify the registers directly and break the breakpoint register
>> management brought-in through the patch.
>>   
>
> If kvm restores the registers, should there be any problem?
>
No, it should be fine although I don't understand how the exception
handler is invoked in KVM without the use of notifier or a hook in
die_debug (or have they replaced code at a layer much below that?).

Apart from the doubt I've stated above, if they operate by replacing
the breakpoint register contents before a context switch from KVM to
other processes, they might in fact help maximise its utilisation.

Thanks for the clarification!

Thanks,
K.Prasad

