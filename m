Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964802Ab0BZN7r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 08:59:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28188 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936288Ab0BZN7q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 08:59:46 -0500
Message-ID: <4B87D3BA.4070507@redhat.com>
Date: Fri, 26 Feb 2010 15:59:22 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Alexander Graf <agraf@suse.de>, Marcelo Tosatti <mtosatti@redhat.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] KVM: SVM: Optimize nested svm msrpm merging
References: <1267118149-15737-1-git-send-email-joerg.roedel@amd.com> <1267118149-15737-3-git-send-email-joerg.roedel@amd.com> <4B87A248.1050300@redhat.com> <20100226122502.GC12689@amd.com> <4E7D93ED-E5FC-4A64-B9B0-E2F644CD2B68@suse.de> <20100226130401.GD12689@amd.com> <4B87C835.4080409@redhat.com> <20100226132118.GF12689@amd.com> <5E91C233-4FE1-43DB-A155-03F14FCEF919@suse.de> <20100226133049.GG12689@amd.com>
In-Reply-To: <20100226133049.GG12689@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26/2010 03:30 PM, Joerg Roedel wrote:
>
>> So the msrpm bitmap changes dynamically for each vcpu? Great, make it
>> fully dynamic then, changing the vcpu->arch.msrpm only from within its
>> vcpu context. No need for atomic ops.
>>      
> The msrpm_offsets table is global. But I think I will follow Avis
> suggestions and create a static direct_access_msrs list and generate the
> msrpm_offsets at module_init. This solves the problem of two independent
> lists too.
>
>    

But with LBR virt, maybe a fully dynamic approach is better.  Just have 
static lists for updating the msrpm and offset table dynamically.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

