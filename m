Return-Path: <linux-kernel-owner+w=401wt.eu-S1757298AbYE0MTH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298AbYE0MTH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 08:19:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756627AbYE0MSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 08:18:54 -0400
Received: from www.tglx.de ([62.245.132.106]:57350 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754663AbYE0MSx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 08:18:53 -0400
Date: Tue, 27 May 2008 14:18:19 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Pavel Machek <pavel@suse.cz>
cc: kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Dave Jones <davej@codemonkey.org.uk>, Andi Kleen <andi@firstfloor.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: amd64-agp: resume but too late?
In-Reply-To: <20080526182904.GA13683@elf.ucw.cz>
Message-ID: <alpine.LFD.1.10.0805271415160.3295@apollo.tec.linutronix.de>
References: <20080526182904.GA13683@elf.ucw.cz>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 May 2008, Pavel Machek wrote:
> Hi!
> 
> I don't get it:
> 
> --- a/drivers/char/agp/amd64-agp.c
> +++ b/drivers/char/agp/amd64-agp.c
> @@ -549,6 +549,8 @@ static int agp_amd64_suspend(struct pci_
>         return 0;
>  }
>  
> +/* FIXME: this is strange; we enable iommu translation here, but that
> + * may be too late, no? */
>  static int agp_amd64_resume(struct pci_dev *pdev)
>  {
>         pci_set_power_state(pdev, PCI_D0);
> 
> ...but resume is normal pci device, so other devices may be resumed
> before this one, and already depend on iommu running...
> 
> How is this supposed to work? Should agp_amd64_resume be called from
> sysdev or something like that?

Hmm, you sent a patch some days ago to change it to
suspend_late/resume_early. Is the discussion resolved about that ?

Thanks,
	tglx
