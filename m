Return-Path: <linux-kernel-owner+w=401wt.eu-S933024AbXGKUKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933024AbXGKUKV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 16:10:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763609AbXGKUKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 16:10:10 -0400
Received: from nz-out-0506.google.com ([64.233.162.227]:57794 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760231AbXGKUKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 16:10:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=EpMg+fl0IqmruDJW3KmzZb8KQfiXN7AqUlBDbHkDUAdkbWp99dcx+WWIWtwDbisNVImk3uSbxYuENKCioi4bET38PcvIEBk9amKZn4tbNbZap57IYq60cuYYRA3aOTU1acVPp0C0lQk/vTGqRtor8mzB6hKeqSGfIzKVo2o1t5s=
Message-ID: <68676e00707111310v4862974am37dc7c723486b96c@mail.gmail.com>
Date: Wed, 11 Jul 2007 22:10:07 +0200
From: Luca <kronos.it@gmail.com>
To: "Avi Kivity" <avi@qumranet.com>
Subject: Re: [kvm-devel] [PATCH 2/2] KVM: Use the scheduler preemption hooks to make kvm preemptible
Cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <1184169333786-git-send-email-avi@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11841693332609-git-send-email-avi@qumranet.com>
	 <1184169333786-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/11/07, Avi Kivity <avi@qumranet.com> wrote:
> Current kvm disables preemption while the new virtualization registers are
> in use.  This of course is not very good for latency sensitive workloads (one
> use of virtualization is to offload user interface and other latency
> insensitive stuff to a container, so that it is easier to analyze the
> remaining workload).  This patch re-enables preemption for kvm; preemption
> is now only disabled when switching the registers in and out, and during
> the switch to guest mode and back.
[...]
> diff --git a/drivers/kvm/Kconfig b/drivers/kvm/Kconfig
> index 33fa28a..92644b5 100644
> --- a/drivers/kvm/Kconfig
> +++ b/drivers/kvm/Kconfig
> @@ -10,7 +10,7 @@ if VIRTUALIZATION
>
>  config KVM
>         tristate "Kernel-based Virtual Machine (KVM) support"
> -       depends on X86 && EXPERIMENTAL
> +       depends on X86 && EXPERIMENTAL && PREEMPT_HOOKS
>         depends on X86_CMPXCHG64 || 64BIT

select PREEMPT_HOOKS maybe?

Luca
