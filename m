Return-Path: <linux-kernel-owner+w=401wt.eu-S1755774AbYJGRNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774AbYJGRNX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 13:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753092AbYJGRNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 13:13:16 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48153 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752961AbYJGRNP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 13:13:15 -0400
Message-ID: <48EB93CC.3070504@redhat.com>
Date: Tue, 07 Oct 2008 18:52:28 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: prasad@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
       Roland McGrath <roland@redhat.com>, akpm@linux-foundation.org,
       mingo@elte.hu, jason.wessel@windriver.com, richardj_moore@uk.ibm.com
Subject: Re: [RFC Patch 0/9] Hardware Breakpoint interfaces
References: <20081007113815.GA23523@in.ibm.com> <48EB5611.9090005@redhat.com> <20081007143217.GA3774@in.ibm.com> <48EB7406.1010509@redhat.com> <20081007164535.GA4130@in.ibm.com>
In-Reply-To: <20081007164535.GA4130@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

K.Prasad wrote:
>>
>>> Presently I find plenty of set_debugreg() calls from kvm/ which will
>>> modify the registers directly and break the breakpoint register
>>> management brought-in through the patch.
>>>   
>>>       
>> If kvm restores the registers, should there be any problem?
>>
>>     
> No, it should be fine although I don't understand how the exception
> handler is invoked in KVM without the use of notifier or a hook in
> die_debug (or have they replaced code at a layer much below that?).
>
>   

kvm debug traps don't work by raising a debug exception; instead, the 
guest #VMEXITs into the host.  The kernel debug handler will not be invoked.

> Apart from the doubt I've stated above, if they operate by replacing
> the breakpoint register contents before a context switch from KVM to
> other processes, they might in fact help maximise its utilisation.
>   

Yes.  As I mentioned, right now we avoid swapping the debug registers if 
we aren't going to context switch or exit to userspace, but if you give 
us a predicate that tells us whether you are interested in the debug 
registers, we can swap them eagerly rather than lazily.

-- 
error compiling committee.c: too many arguments to function

