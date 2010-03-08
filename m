Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179Ab0CHJRt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 04:17:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50091 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752788Ab0CHJRq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 04:17:46 -0500
Message-ID: <4B94C0B5.7080507@redhat.com>
Date: Mon, 08 Mar 2010 11:17:41 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Alexander Graf <agraf@suse.de>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/18] KVM: MMU: Make tdp_enabled a mmu-context parameter
References: <1267643541-451-1-git-send-email-joerg.roedel@amd.com> <1267643541-451-3-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1267643541-451-3-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2010 09:12 PM, Joerg Roedel wrote:
> This patch changes the tdp_enabled flag from its global
> meaning to the mmu-context. This is necessary for Nested SVM
> with emulation of Nested Paging where we need an extra MMU
> context to shadow the Nested Nested Page Table.
>
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index ec891a2..e7bef19 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -254,6 +254,7 @@ struct kvm_mmu {
>   	int root_level;
>   	int shadow_root_level;
>   	union kvm_mmu_page_role base_role;
> +	bool tdp_enabled;
>
>    

This needs a different name, since the old one is still around.  Perhaps 
we could call it parent_mmu and make it a kvm_mmu pointer.

-- 
error compiling committee.c: too many arguments to function

