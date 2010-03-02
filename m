Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123Ab0CBBnj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 20:43:39 -0500
Received: from claw.goop.org ([74.207.240.146]:53967 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751603Ab0CBBni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 20:43:38 -0500
Message-ID: <4B8C6D49.6000606@goop.org>
Date: Mon, 01 Mar 2010 17:43:37 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Sheng Yang <sheng@linux.intel.com>
CC: Keir Fraser <keir.fraser@eu.citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Ian Pratt <Ian.Pratt@eu.citrix.com>,
       xen-devel <xen-devel@lists.xensource.com>,
       Ian Campbell <Ian.Campbell@citrix.com>,
       Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
       "Yaozu (Eddie) Dong" <eddie.dong@intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH 3/7] xen/hvm: Xen PV extension of  HVM initialization
References: <1267436315-24486-1-git-send-email-sheng@linux.intel.com> <1267436315-24486-4-git-send-email-sheng@linux.intel.com> <4B8C63B0.2090507@goop.org> <201003020938.53630.sheng@linux.intel.com>
In-Reply-To: <201003020938.53630.sheng@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/2010 05:38 PM, Sheng Yang wrote:
>> Why use this?  Why not just set the domain type to HVM, and leave the
>> "status" field as a bitset of available paravirtualizations?
>>      
> A annoy thing in pv drivers is that it would test if the domain type is _NOT_
> XEN_NATIVE. So set the domain to XEN_HVM_DOMAIN would result in PV driver
> initialization then probably panic. Maybe we can do something to PV drivers,
> as patch 6 and a part of patch 7.
>    

In that case, change them to specifically test for PV until they're 
ready to deal with an HVM environment.

>
> Part of pv_ops are overlapped. I would try if a new file would bring much
> duplicate.
>    

It shouldn't do; un-static things if necessary.

>>> +	.align PAGE_SIZE_asm
>>> +ENTRY(shared_info_page)
>>> +	.skip PAGE_SIZE_asm
>>> +.popsection
>>>        
>> Why does this need to be defined in asm?  Can't it be either allocated
>> or defined in C?
>>      
> I think we need a aligned page, as hypercall page.
>    

That can be declared in C with the __page_aligned_bss annotation.  And 
couldn't you dynamically allocate it with the bootmem allocator?

>> I think "status" is a misnomer here.  Isn't it specifically a set of PV
>> features which are active?
>>      
> Could you give a suggestion of the name? I am not a native English speaker...
>    

xen_hvm_pv_features.

     J
