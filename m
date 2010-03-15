Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934967Ab0COHg7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 03:36:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48050 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754222Ab0COHg6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 03:36:58 -0400
Message-ID: <4B9DE394.2080401@redhat.com>
Date: Mon, 15 Mar 2010 09:36:52 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Alexander Graf <agraf@suse.de>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/18] KVM: MMU: Propagate the right fault back to the
 guest after gva_to_gpa
References: <1267643541-451-1-git-send-email-joerg.roedel@amd.com> <1267643541-451-16-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1267643541-451-16-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2010 09:12 PM, Joerg Roedel wrote:
> This patch implements logic to make sure that either a
> page-fault/page-fault-vmexit or a nested-page-fault-vmexit
> is propagated back to the guest.
>
> Signed-off-by: Joerg Roedel<joerg.roedel@amd.com>
> ---
>   arch/x86/kvm/mmu.h         |    1 +
>   arch/x86/kvm/paging_tmpl.h |    2 ++
>   arch/x86/kvm/x86.c         |   15 ++++++++++++++-
>   3 files changed, 17 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index 64f619b..b42b27e 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -47,6 +47,7 @@
>   #define PFERR_USER_MASK (1U<<  2)
>   #define PFERR_RSVD_MASK (1U<<  3)
>   #define PFERR_FETCH_MASK (1U<<  4)
> +#define PFERR_NESTED_MASK (1U<<  31)
>    


Why is this needed?  Queue an ordinary page fault page; the injection 
code should check the page fault intercept and #VMEXIT if needed.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

