Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646Ab0CHJlv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 04:41:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27082 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753230Ab0CHJlq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 04:41:46 -0500
Message-ID: <4B94C655.6000504@redhat.com>
Date: Mon, 08 Mar 2010 11:41:41 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Alexander Graf <agraf@suse.de>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/18][RFC] Nested Paging support for Nested SVM (aka NPT-Virtualization)
References: <1267643541-451-1-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1267643541-451-1-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2010 09:12 PM, Joerg Roedel wrote:
> Hi,
>
> here are the patches that implement nested paging support for nested
> svm. They are somewhat intrusive to the soft-mmu so I post them as RFC
> in the first round to get feedback about the general direction of the
> changes.  Nevertheless I am proud to report that with these patches the
> famous kernel-compile benchmark runs only 4% slower in the l2 guest as
> in the l1 guest when l2 is single-processor. With SMP guests the
> situation is very different. The more vcpus the guest has the more is
> the performance drop from l1 to l2.
> Anyway, this post is to get feedback about the overall concept of these
> patches.  Please review and give feedback :-)
>
> Thanks,
>
> 	Joerg
>
> Diffstat:
>
>   arch/x86/include/asm/kvm_host.h |   21 ++++++
>   arch/x86/kvm/mmu.c              |  152 ++++++++++++++++++++++++++++++---------
>   arch/x86/kvm/mmu.h              |    2 +
>   arch/x86/kvm/paging_tmpl.h      |   81 ++++++++++++++++++---
>   arch/x86/kvm/svm.c              |  126 +++++++++++++++++++++++++++-----
>   arch/x86/kvm/vmx.c              |    9 +++
>   arch/x86/kvm/x86.c              |   19 +++++-
>   include/linux/kvm.h             |    1 +
>   include/linux/kvm_host.h        |    5 ++
>   9 files changed, 354 insertions(+), 62 deletions(-)
>    

Okay, this looks excellent overall, it's nice to see how well this fits 
with the existing mmu infrastructure (only ~300 lines added).  The 
performance results are impressive.

-- 
error compiling committee.c: too many arguments to function

