Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781Ab0BGKxG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 05:53:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53100 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754141Ab0BGKxC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 05:53:02 -0500
Message-ID: <4B6E9B7C.3030805@redhat.com>
Date: Sun, 07 Feb 2010 12:52:44 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: Joerg Roedel <joerg.roedel@amd.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org,
       iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/11] iommu-api: Add iommu_map and iommu_unmap	functions
References: <1264678682-30655-1-git-send-email-joerg.roedel@amd.com> <1264678682-30655-3-git-send-email-joerg.roedel@amd.com> <4B6E8A16.8050109@redhat.com> <20100207105007.GC17809@8bytes.org>
In-Reply-To: <20100207105007.GC17809@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2010 12:50 PM, Joerg Roedel wrote:
> On Sun, Feb 07, 2010 at 11:38:30AM +0200, Avi Kivity wrote:
>    
>> On 01/28/2010 01:37 PM, Joerg Roedel wrote:
>>      
>>> These two functions provide support for mapping and
>>> unmapping physical addresses to io virtual addresses. The
>>> difference to the iommu_(un)map_range() is that the new
>>> functions take a gfp_order parameter instead of a size. This
>>> allows the IOMMU backend implementations to detect easier if
>>> a given range can be mapped by larger page sizes.
>>> These new functions should replace the old ones in the long
>>> term.
>>>
>>>        
>> These seem to be less flexible in the long term.  Sure, it is easier for
>> the backend to map to multiple page sizes if your iommu supports
>> arbitrary power-of-two page sizes, but we should make the APIs easier
>> for the callers, not the backend.
>>      
> These functions are as flexible as the old ones which just tok a size.
> The benefit of the new interface is that is makes the ability of the
> IOMMU to map the area with a large page (an get the benefit of fewer
> hardware tlb walks) visible to the caller. With the old interface the
> caller is tempted to just map ist whole area using 4kb page sizes.
> It gives a bit more complexity to the caller, thats right. But given
> that the page allocator in Linux always returns pages which are aligned
> to its size takes a lot of that complexity away.
>
>    

You are right - I was thinking of the kvm use case which is range 
oriented, but the ordinary kernel interfaces are gfp_order oriented.

-- 
error compiling committee.c: too many arguments to function

