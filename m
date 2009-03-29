Return-Path: <linux-kernel-owner+w=401wt.eu-S1755527AbZC2MzH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527AbZC2MzH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 08:55:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756883AbZC2Myx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 08:54:53 -0400
Received: from 8bytes.org ([88.198.83.132]:59750 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755408AbZC2Myw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 08:54:52 -0400
Date: Sun, 29 Mar 2009 14:54:47 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Avi Kivity <avi@redhat.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] kvm x86: report 1GB page support to userspace
Message-ID: <20090329125447.GJ31080@8bytes.org>
References: <1238164319-16092-1-git-send-email-joerg.roedel@amd.com> <1238164319-16092-8-git-send-email-joerg.roedel@amd.com> <49CF6177.9010907@redhat.com> <20090329124548.GG31080@8bytes.org> <49CF6E47.3050402@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49CF6E47.3050402@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 29, 2009 at 03:49:11PM +0300, Avi Kivity wrote:
> Joerg Roedel wrote:
>>>>  	int (*set_tss_addr)(struct kvm *kvm, unsigned int addr);
>>>>  	int (*get_tdp_level)(void);
>>>>  	int (*get_mt_mask_shift)(void);
>>>> +
>>>> +	bool (*gb_page_enable)(void);
>>>>  };
>>>>         
>>> Should enable unconditionally.  Of course we need to find the shadow 
>>> bug  first, may be the has_wrprotected thingy.
>>>     
>>
>> This was the original plan. But how about VMX with EPT enabled? I am not
>> sure but I think this configuration will not support gbpages?
>>
>> 	
>
> You're right.  Let's have a ->max_host_page_level() to handle that.   
> It's 0.5T pages ready, too.

Ok I will change that together with the page_size -> page_level
chhanges. But I doubt that there will ever be 0.5T pages ;)

	Joerg
