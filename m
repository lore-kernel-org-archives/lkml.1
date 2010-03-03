Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477Ab0CCXhx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 18:37:53 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45926 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753226Ab0CCXhp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 18:37:45 -0500
Subject: Re: [PATCH 17/18] KVM: SVM: Report Nested Paging support to userspace
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <1267643541-451-18-git-send-email-joerg.roedel@amd.com>
Date: Thu, 4 Mar 2010 00:37:42 +0100
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <023D03A7-4DBE-4E6E-911D-14E8FCADB459@suse.de>
References: <1267643541-451-1-git-send-email-joerg.roedel@amd.com> <1267643541-451-18-git-send-email-joerg.roedel@amd.com>
To: Joerg Roedel <joerg.roedel@amd.com>
X-Mailer: Apple Mail (2.1077)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 03.03.2010, at 20:12, Joerg Roedel wrote:

> This patch implements the reporting of the nested paging
> feature support to userspace.
> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
> arch/x86/kvm/svm.c |   10 ++++++++++
> 1 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index fe1398e..ce71023 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -3289,6 +3289,16 @@ static void svm_cpuid_update(struct kvm_vcpu *vcpu)
> 
> static void svm_set_supported_cpuid(u32 func, struct kvm_cpuid_entry2 *entry)
> {
> +	switch (func) {
> +	case 0x8000000A:
> +		if (!npt_enabled)
> +			break;

if (!nested)
  break;

Alex