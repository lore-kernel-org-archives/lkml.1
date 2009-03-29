Return-Path: <linux-kernel-owner+w=401wt.eu-S1756757AbZC2Mt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757AbZC2Mt2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 08:49:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755182AbZC2MtR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 08:49:17 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50629 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753525AbZC2MtQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 08:49:16 -0400
Message-ID: <49CF6E47.3050402@redhat.com>
Date: Sun, 29 Mar 2009 15:49:11 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: Joerg Roedel <joerg.roedel@amd.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] kvm x86: report 1GB page support to userspace
References: <1238164319-16092-1-git-send-email-joerg.roedel@amd.com> <1238164319-16092-8-git-send-email-joerg.roedel@amd.com> <49CF6177.9010907@redhat.com> <20090329124548.GG31080@8bytes.org>
In-Reply-To: <20090329124548.GG31080@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel wrote:
>>>  	int (*set_tss_addr)(struct kvm *kvm, unsigned int addr);
>>>  	int (*get_tdp_level)(void);
>>>  	int (*get_mt_mask_shift)(void);
>>> +
>>> +	bool (*gb_page_enable)(void);
>>>  };
>>>   
>>>       
>> Should enable unconditionally.  Of course we need to find the shadow bug  
>> first, may be the has_wrprotected thingy.
>>     
>
> This was the original plan. But how about VMX with EPT enabled? I am not
> sure but I think this configuration will not support gbpages?
>
> 	

You're right.  Let's have a ->max_host_page_level() to handle that.  
It's 0.5T pages ready, too.

-- 
error compiling committee.c: too many arguments to function

