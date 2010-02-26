Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936162Ab0BZNKY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 08:10:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6498 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936066Ab0BZNKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 08:10:22 -0500
Message-ID: <4B87C835.4080409@redhat.com>
Date: Fri, 26 Feb 2010 15:10:13 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Alexander Graf <agraf@suse.de>, Marcelo Tosatti <mtosatti@redhat.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] KVM: SVM: Optimize nested svm msrpm merging
References: <1267118149-15737-1-git-send-email-joerg.roedel@amd.com> <1267118149-15737-3-git-send-email-joerg.roedel@amd.com> <4B87A248.1050300@redhat.com> <20100226122502.GC12689@amd.com> <4E7D93ED-E5FC-4A64-B9B0-E2F644CD2B68@suse.de> <20100226130401.GD12689@amd.com>
In-Reply-To: <20100226130401.GD12689@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26/2010 03:04 PM, Joerg Roedel wrote:
>
>> I'm still not convinced on this way of doing things. If it's static,
>> make it static. If it's dynamic, make it dynamic. Dynamically
>> generating a static list just sounds plain wrong to me.
>>      
> Stop. I had a static list in the first version of the patch. This list
> was fine except the fact that a developer needs to remember to update
> this list if the list of non-intercepted msrs is expanded. The whole
> reason for a dynamically built list is to take the task of maintaining
> the list away from the developer and remove a possible source of hard to
> find bugs. This is what the current approach does.
>    

The problem was the two lists.  If you had a

static struct svm_direct_access_msrs = {
     u32 index;
     bool longmode_only;
} direct_access_msrs = {
    ...
};

You could generate

static unsigned *msrpm_offsets_longmode, *msrpm_offsets_legacy;

as well as the original bitmaps at module init, no?

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

