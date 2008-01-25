Return-Path: <linux-kernel-owner+w=401wt.eu-S1760042AbYAYVfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760042AbYAYVfb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 16:35:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755835AbYAYVfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 16:35:24 -0500
Received: from wx-out-0506.google.com ([66.249.82.229]:24036 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754756AbYAYVfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 16:35:23 -0500
Message-ID: <479A561B.8070009@codemonkey.ws>
Date: Fri, 25 Jan 2008 15:35:23 -0600
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Avi Kivity <avi@qumranet.com>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [PATCH 3/8] SVM: add module parameter to disable
 Nested Paging
References: <1201294393-22613-1-git-send-email-joerg.roedel@amd.com> <1201294393-22613-4-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1201294393-22613-4-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel wrote:
> To disable the use of the Nested Paging feature even if it is available in
> hardware this patch adds a module parameter. Nested Paging can be disabled by
> passing npt=off to the kvm_amd module.
>
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  arch/x86/kvm/svm.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 49bb57a..2e718ff 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -48,6 +48,9 @@ MODULE_LICENSE("GPL");
>  #define SVM_DEATURE_SVML (1 << 2)
>  
>  static bool npt_enabled = false;
> +static char *npt = "on";
> +
> +module_param(npt, charp, S_IRUGO);
>   

This would probably be better as an integer.  Then we don't have to do 
nasty things like implicitly cast a literal to a char *.

Regards,

Anthony Liguori

>  static void kvm_reput_irq(struct vcpu_svm *svm);
>  
> @@ -415,6 +418,11 @@ static __init int svm_hardware_setup(void)
>  	if (!svm_has(SVM_FEATURE_NPT))
>  		npt_enabled = false;
>  
> +	if (npt_enabled && strncmp(npt, "off", 3) == 0) {
> +		printk(KERN_INFO "kvm: Nested Paging disabled\n");
> +		npt_enabled = false;
> +	}
> +
>  	if (npt_enabled)
>  		printk(KERN_INFO "kvm: Nested Paging enabled\n");
>  
>   

