Return-Path: <linux-kernel-owner+w=401wt.eu-S1756883AbZC2Mr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883AbZC2Mr7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 08:47:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756398AbZC2Mri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 08:47:38 -0400
Received: from 8bytes.org ([88.198.83.132]:55392 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756746AbZC2Mrh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 08:47:37 -0400
Date: Sun, 29 Mar 2009 14:47:35 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Joerg Roedel <joerg.roedel@amd.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] Support for GB pages in KVM
Message-ID: <20090329124735.GH31080@8bytes.org>
References: <1238164319-16092-1-git-send-email-joerg.roedel@amd.com> <20090328214008.GB4694@amt.cnet> <20090328214900.GE31080@8bytes.org> <49CF6390.1020009@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49CF6390.1020009@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 29, 2009 at 03:03:28PM +0300, Avi Kivity wrote:
> Joerg Roedel wrote:
>> On Sat, Mar 28, 2009 at 06:40:08PM -0300, Marcelo Tosatti wrote:
>>   
>>> On Fri, Mar 27, 2009 at 03:31:52PM +0100, Joerg Roedel wrote:
>>>     
>>>> Hi,
>>>>
>>>> this patchset extends the KVM MMU implementation to support 1GB pages as
>>>> supported by AMD family 16 processors. These patches enable support for
>>>> 1 GB pages with Nested Paging. Support for these pages in the shadow
>>>> paging code was also developed but does not run stable yet. The patch
>>>> for shadow-paging support is not included in this series and will be
>>>> sent out seperatly.
>>>>       
>>> Looks generally sane. I'm not sure its even worthwhile to support
>>> GBpages with softmmu, because the chance of finding an area without
>>> shadowed (write protected) pages is much smaller than with 2MB pages.
>>>     
>>
>> Thanks for your review.
>>
>> The idea behind GB pages in softmmu code was to provide GB pages to the
>> guest even if hardware does not support it. This would work better with
>> live migration (Only case where we wouldn't have gbpages then would be
>> vmx with ept enabled).
>>
>>   
>>> Have any numbers to share?
>>>     
>>
>> No numbers I fully trust by now. I measured a 32% improvement in
>> kernbench using nested pages backed with gb pages. I will do some more
>> measurements and share some more solid numbers.
>>
>>   
>
> Compared to 2M pages?  But we're already close to native here.

Yes, thats why I don't trust those numbers. I'll find out what went
wrong and provide more solid numbers.

	Joerg

