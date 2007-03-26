Return-Path: <linux-kernel-owner+w=401wt.eu-S933332AbXCZWF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933332AbXCZWF2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 18:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933338AbXCZWF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 18:05:28 -0400
Received: from smtp.osdl.org ([65.172.181.24]:54639 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933332AbXCZWF1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 18:05:27 -0400
Date: Mon, 26 Mar 2007 15:05:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Brownell <david-b@pacbell.net>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2.6.21-rc5] arch/x86_64/kernel/early-quirks.c compiler
 warning
Message-Id: <20070326150523.b748b44b.akpm@linux-foundation.org>
In-Reply-To: <200703260917.44906.david-b@pacbell.net>
References: <200703260917.44906.david-b@pacbell.net>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Mar 2007 09:17:44 -0700
David Brownell <david-b@pacbell.net> wrote:

> Fix "unused variable" compiler warning on non-SMP x86_64 configs.
> 
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> 
> --- a/arch/x86_64/kernel/early-quirks.c
> +++ b/arch/x86_64/kernel/early-quirks.c
> @@ -73,9 +73,9 @@ static void __init ati_bugs(void)
>  
>  static void intel_bugs(void)
>  {
> +#ifdef CONFIG_SMP
>  	u16 device = read_pci_config_16(0, 0, 0, PCI_DEVICE_ID);
>  
> -#ifdef CONFIG_SMP
>  	if (device == PCI_DEVICE_ID_INTEL_E7320_MCH ||
>  	    device == PCI_DEVICE_ID_INTEL_E7520_MCH ||
>  	    device == PCI_DEVICE_ID_INTEL_E7525_MCH)

This whole function gets removed by
ftp://ftp.firstfloor.org/pub/ak/x86_64/quilt-current/patches/revert-x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525
so I think I'll duck the patch.  Which is very bad of me, because it means
2.6.21 goes out with this warning.  But I don't think many people build
non-SMP x86_64.


