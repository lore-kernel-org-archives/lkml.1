Return-Path: <linux-kernel-owner+w=401wt.eu-S1755707AbYFROZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707AbYFROZn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 10:25:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751884AbYFROZf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 10:25:35 -0400
Received: from il.qumranet.com ([212.179.150.194]:40059 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750819AbYFROZe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 10:25:34 -0400
Message-ID: <48591AD9.9050903@qumranet.com>
Date: Wed, 18 Jun 2008 07:25:29 -0700
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Amit Shah <amit.shah@qumranet.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, muli@il.ibm.com,
       benami@il.ibm.com, allen.m.kay@intel.com, chrisw@redhat.com
Subject: Re: [PATCH 1/3] KVM: Expose get_eoi_gsi for IRQ acking for assigned
 devices.
References: <1212143270-18333-1-git-send-email-amit.shah@qumranet.com>
In-Reply-To: <1212143270-18333-1-git-send-email-amit.shah@qumranet.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amit Shah wrote:
> Also add kvm_ prefix.
>
> Signed-off-by: Amit Shah <amit.shah@qumranet.com>
> ---
>  virt/kvm/ioapic.c |    4 ++--
>  virt/kvm/ioapic.h |    1 +
>  2 files changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
> index 99a1736..4c41a00 100644
> --- a/virt/kvm/ioapic.c
> +++ b/virt/kvm/ioapic.c
> @@ -284,7 +284,7 @@ void kvm_ioapic_set_irq(struct kvm_ioapic *ioapic, int irq, int level)
>  	}
>  }
>  
> -static int get_eoi_gsi(struct kvm_ioapic *ioapic, int vector)
> +int kvm_get_eoi_gsi(struct kvm_ioapic *ioapic, int vector)
>  {
>  	int i;
>  
> @@ -300,7 +300,7 @@ void kvm_ioapic_update_eoi(struct kvm *kvm, int vector)
>  	union ioapic_redir_entry *ent;
>  	int gsi;
>  
> -	gsi = get_eoi_gsi(ioapic, vector);
> +	gsi = kvm_get_eoi_gsi(ioapic, vector);
>  	if (gsi == -1) {
>  		printk(KERN_WARNING "Can't find redir item for %d EOI\n",
>  		       vector);
>
>   

de53f0e48a1ec9880613a9bdbc5d1d3dcfada0f7 kills get_eoi_gsi, since there 
can be more than one irq mapped to a vector.  I guess the right way to 
deal with this is to install a callback in the pic and apic, to be 
called when the guest acks the interrupt.


-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

