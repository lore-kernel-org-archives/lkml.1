Return-Path: <linux-kernel-owner+w=401wt.eu-S1760579AbYGJRv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760579AbYGJRv2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 13:51:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756614AbYGJRvU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 13:51:20 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:35835 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330AbYGJRvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 13:51:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=vRJ4twGKtYAD7iaPIMbAcTvLdnQn4WNWc3WdjEG2JuV9PI9l/m1HaWctFWBienLoiK
         00RLjhvmJqx7PQSPQ9Soqr2ZqAB/BVzWxXGNr94bSRdi20s35P1DMsflXwl/oecYmwo5
         yw9O9z+Us0WcHop/7aH5wvc9vklx9Lpd37FhM=
Message-ID: <86802c440807101051g6e41b8fdk704361c0350b288c@mail.gmail.com>
Date: Thu, 10 Jul 2008 10:51:19 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Robert Richter" <robert.richter@amd.com>
Subject: Re: [PATCH 3/5] x86/pci merge: Fixing numaq initialization
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1215709106-9182-4-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1215709106-9182-1-git-send-email-robert.richter@amd.com>
	 <1215709106-9182-4-git-send-email-robert.richter@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2008 at 9:58 AM, Robert Richter <robert.richter@amd.com> wrote:
> Patch d49c4288 (tip/x86/mpparse) introduced some changes in calling
> subsys_init calls if CONFIG_X86_NUMAQ option is set. This patch
> updates subsystem initalization according to this changes.
>
> Signed-off-by: Robert Richter <robert.richter@amd.com>
> ---
>  arch/x86/pci/legacy.c |    3 +++
>  arch/x86/pci/numa.c   |   10 +---------
>  arch/x86/pci/pci.h    |    1 +
>  3 files changed, 5 insertions(+), 9 deletions(-)
>
> diff --git a/arch/x86/pci/legacy.c b/arch/x86/pci/legacy.c
> index 3c1d795..d8b6e92 100644
> --- a/arch/x86/pci/legacy.c
> +++ b/arch/x86/pci/legacy.c
> @@ -62,6 +62,9 @@ int __init pci_subsys_init(void)
>  #endif
>        pci_legacy_init();
>        pcibios_irq_init();
> +#ifdef CONFIG_X86_NUMAQ
> +       pci_numa_init();
> +#endif
>        pcibios_init();
>  }

please change sequence to

+#ifdef CONFIG_X86_NUMAQ
+       pci_numa_init();
+#endif
#ifdef CONFIG_ACPI
        pci_acpi_init();
#endif
        pci_legacy_init();

YH
