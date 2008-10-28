Return-Path: <linux-kernel-owner+w=401wt.eu-S1752860AbYJ1Q6N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860AbYJ1Q6N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 12:58:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752927AbYJ1Q5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 12:57:47 -0400
Received: from kroah.org ([198.145.64.141]:39625 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752880AbYJ1Q5q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 12:57:46 -0400
Date: Tue, 28 Oct 2008 09:52:36 -0700
From: Greg KH <greg@kroah.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Jouni Malinen <jkmalinen@gmail.com>,
       Oliver Neukum <oliver@neukum.org>, Nicolas Bareil <nico@chdir.org>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, j@w1.fi
Subject: Re: [PATCH] x86, gart: fix gart detection for Fam11h CPUs
Message-ID: <20081028165236.GA4503@kroah.com>
References: <e785a1360810280207p1c162decs5a70b8915ea08476@mail.gmail.com> <1225206834-6189-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225206834-6189-1-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2008 at 04:13:54PM +0100, Joerg Roedel wrote:
> The AMD Fam11h CPUs have a K8 northbridge. This northbridge is different
> from other familys because it lacks GART support (as I just learned).
> But the kernel implicitly expects a GART if it finds an AMD northbridge.
> Fix this by removing the Fam11h northbridge id from the scan list of K8
> northbridges. This patch also changes the message in the GART driver
> about missing K8 northbridges to tell that the GART is missing which is
> the correct information in this case.
> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>

Looks like this needs to be added to the 2.6.27-stable tree also, right?

thanks,

greg k-h

> ---
>  arch/x86/kernel/k8.c          |    1 -
>  arch/x86/kernel/pci-gart_64.c |    2 +-
>  2 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/k8.c b/arch/x86/kernel/k8.c
> index 304d8ba..cbc4332 100644
> --- a/arch/x86/kernel/k8.c
> +++ b/arch/x86/kernel/k8.c
> @@ -18,7 +18,6 @@ static u32 *flush_words;
>  struct pci_device_id k8_nb_ids[] = {
>  	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_K8_NB_MISC) },
>  	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_10H_NB_MISC) },
> -	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_11H_NB_MISC) },
>  	{}
>  };
>  EXPORT_SYMBOL(k8_nb_ids);
> diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
> index e3f75bb..a42b02b 100644
> --- a/arch/x86/kernel/pci-gart_64.c
> +++ b/arch/x86/kernel/pci-gart_64.c
> @@ -744,7 +744,7 @@ void __init gart_iommu_init(void)
>  	long i;
>  
>  	if (cache_k8_northbridges() < 0 || num_k8_northbridges == 0) {
> -		printk(KERN_INFO "PCI-GART: No AMD northbridge found.\n");
> +		printk(KERN_INFO "PCI-GART: No AMD GART found.\n");
>  		return;
>  	}
>  
> -- 
> 1.5.6.4
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
