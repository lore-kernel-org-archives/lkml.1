Return-Path: <linux-kernel-owner+w=401wt.eu-S932997AbXBVKi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932997AbXBVKi3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 05:38:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933005AbXBVKi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 05:38:29 -0500
Received: from il.qumranet.com ([82.166.9.18]:46387 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932997AbXBVKi2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 05:38:28 -0500
Message-ID: <45DD7271.6000503@qumranet.com>
Date: Thu, 22 Feb 2007 12:37:37 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Dor Laor <dor.laor@qumranet.com>, Pavel Machek <pavel@ucw.cz>,
       kvm-devel@lists.sourceforge.net, akpm@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [PATCH 10/13] KVM: Wire up hypercall handlers to
 a central arch-independent location
References: <45DD6CF0.3010509@qumranet.com> <64F9B87B6B770947A9F8391472E032160A91BAF3@ehost011-8.exch011.intermedia.net> <20070222102228.GC12801@amd.com>
In-Reply-To: <20070222102228.GC12801@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel wrote:
> On Thu, Feb 22, 2007 at 02:17:54AM -0800, Dor Laor wrote:
>   
>> I have Ingo's network PV hypercalls to commit in my piplien.
>> Till then we can just add the test hypercall:
>> 	case __NR_hypercall_test:
>> 		printk(KERN_DEBUG "%s __NR_hypercall_test\n",
>> __FUNCTION__);
>> 		ret = 0x5a5a;
>> 		break;
>> 	default:
>> 		BUG();
>>     
>
> Is it a good idea to call BUG() on an undefined hypercall? I assume its
> better to inform the guest that is has issued an illegal call...
>
>   

The code returns -KVM_EINVAL if the hypercall is not handled (and BUG() 
on the host as a response to something controlled by a guest is not a 
good idea).


-- 
error compiling committee.c: too many arguments to function

