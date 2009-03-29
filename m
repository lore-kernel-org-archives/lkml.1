Return-Path: <linux-kernel-owner+w=401wt.eu-S1757223AbZC2MDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757223AbZC2MDq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 08:03:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757136AbZC2MDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 08:03:35 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39621 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756877AbZC2MDe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 08:03:34 -0400
Message-ID: <49CF6390.1020009@redhat.com>
Date: Sun, 29 Mar 2009 15:03:28 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Joerg Roedel <joerg.roedel@amd.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] Support for GB pages in KVM
References: <1238164319-16092-1-git-send-email-joerg.roedel@amd.com> <20090328214008.GB4694@amt.cnet> <20090328214900.GE31080@8bytes.org>
In-Reply-To: <20090328214900.GE31080@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel wrote:
> On Sat, Mar 28, 2009 at 06:40:08PM -0300, Marcelo Tosatti wrote:
>   
>> On Fri, Mar 27, 2009 at 03:31:52PM +0100, Joerg Roedel wrote:
>>     
>>> Hi,
>>>
>>> this patchset extends the KVM MMU implementation to support 1GB pages as
>>> supported by AMD family 16 processors. These patches enable support for
>>> 1 GB pages with Nested Paging. Support for these pages in the shadow
>>> paging code was also developed but does not run stable yet. The patch
>>> for shadow-paging support is not included in this series and will be
>>> sent out seperatly.
>>>       
>> Looks generally sane. I'm not sure its even worthwhile to support
>> GBpages with softmmu, because the chance of finding an area without
>> shadowed (write protected) pages is much smaller than with 2MB pages.
>>     
>
> Thanks for your review.
>
> The idea behind GB pages in softmmu code was to provide GB pages to the
> guest even if hardware does not support it. This would work better with
> live migration (Only case where we wouldn't have gbpages then would be
> vmx with ept enabled).
>
>   
>> Have any numbers to share?
>>     
>
> No numbers I fully trust by now. I measured a 32% improvement in
> kernbench using nested pages backed with gb pages. I will do some more
> measurements and share some more solid numbers.
>
>   

Compared to 2M pages?  But we're already close to native here.


-- 
error compiling committee.c: too many arguments to function

