Return-Path: <linux-kernel-owner+w=401wt.eu-S1754217AbZG2DDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217AbZG2DDh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 23:03:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752821AbZG2DDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 23:03:37 -0400
Received: from mga10.intel.com ([192.55.52.92]:56833 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752728AbZG2DDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 23:03:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,286,1246863600"; 
   d="scan'208";a="711985727"
From: Sheng Yang <sheng@linux.intel.com>
Organization: Intel Opensource Technology Center
To: kvm@vger.kernel.org
Subject: Re: [PATCH] kvm: remove superfluous NULL pointer check in kvm_inject_pit_timer_irqs()
Date: Wed, 29 Jul 2009 11:02:36 +0800
User-Agent: KMail/1.11.2 (Linux/2.6.28-13-generic; KDE/4.2.2; x86_64; ; )
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org,
       Dan Carpenter <error27@gmail.com>, corbet@lwn.net, eteo@redhat.com,
       Julia Lawall <julia@diku.dk>
References: <200907290046.40596.bzolnier@gmail.com>
In-Reply-To: <200907290046.40596.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907291102.38682.sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 July 2009 06:46:38 Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] kvm: remove superfluous NULL pointer check in
> kvm_inject_pit_timer_irqs()
>
> This takes care of the following entries from Dan's list:
>
> arch/x86/kvm/i8254.c +714 kvm_inject_pit_timer_irqs(6) warning: variable
> derefenced in initializer 'vcpu' arch/x86/kvm/i8254.c +714
> kvm_inject_pit_timer_irqs(6) warning: variable derefenced before check
> 'vcpu'
>
> Reported-by: Dan Carpenter <error27@gmail.com>
> Cc: corbet@lwn.net
> Cc: eteo@redhat.com
> Cc: Julia Lawall <julia@diku.dk>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
>  arch/x86/kvm/i8254.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> Index: b/arch/x86/kvm/i8254.c
> ===================================================================
> --- a/arch/x86/kvm/i8254.c
> +++ b/arch/x86/kvm/i8254.c
> @@ -713,7 +713,7 @@ void kvm_inject_pit_timer_irqs(struct kv
>  	struct kvm *kvm = vcpu->kvm;
>  	struct kvm_kpit_state *ps;
>
> -	if (vcpu && pit) {
> +	if (pit) {
>  		int inject = 0;
>  		ps = &pit->pit_state;
>
Oh, follow up for the recent zero day exploit, right? :)

Yes, vcpu NULL check is not necessary here.

Acked-by: Sheng Yang <sheng@linux.intel.com>

-- 
regards
Yang, Sheng

> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


