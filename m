Return-Path: <linux-kernel-owner+w=401wt.eu-S1752857AbYKSXC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857AbYKSXC2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 18:02:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751538AbYKSXCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 18:02:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59544 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751395AbYKSXCT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 18:02:19 -0500
Date: Thu, 20 Nov 2008 00:02:15 +0100
From: Bernhard Walle <bwalle@suse.de>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Mingarelli, Thomas" <Thomas.Mingarelli@hp.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "stable@kernel.org" <stable@kernel.org>
Subject: Re: [PATCH] [WATCHDOG] [hpwdt] Set the mapped BIOS address space as
 executable
Message-ID: <20081120000215.45071a50@kopernikus.site>
In-Reply-To: <20081119230014.GC30873@infomag.infomag.iguana.be>
References: <1226674023-5374-1-git-send-email-bwalle@suse.de>
	<20081118143015.72af31d3.akpm@linux-foundation.org>
	<20081118233229.294270fb@kopernikus.site>
	<183C1D5A376DE343AA8F94FC2A1EC1493AA5CEE7AB@GVW1091EXB.americas.hpqcorp.net>
	<20081119093041.1af8fd7e.akpm@linux-foundation.org>
	<20081119183444.56b342cb@hale.suse.de>
	<20081119230014.GC30873@infomag.infomag.iguana.be>
Organization: SUSE Linux Products GmbH
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Wim Van Sebroeck [2008-11-20 00:00]:
>
> Hi All,
> 
> > * Andrew Morton [2008-11-19 09:30]:
> > > > 
> > > 
> > > (top-posting repaired.  Please don't top-post!)
> > > 
> > > I haven't seen any patch which alters hpwdt_pretimeout() and there is
> > > no such patch in linux-next.  Perhaps it got lost?
> 
> This was the patch (see below). It's in the linux-2.6-watchdog-next tree now,
> so it should go into the linux-next tree soon.
> 
> The other patch is in the linux-2.6-watchdog-next tree also.

Wasn't the conclusion that NOTIFY_OK always works and we should not
rely on that 'allow_kdump' option?


Regards,
Bernhard


>  
>  static void __iomem *pci_mem_addr;		/* the PCI-memory address */
>  static unsigned long __iomem *hpwdt_timer_reg;
> @@ -485,7 +485,11 @@ static int hpwdt_pretimeout(struct notifier_block *nb, unsigned long ulReason,
>  			"Management Log for details.\n");
>  	}
>  
> -	return NOTIFY_STOP;
> +	/*
> +	 * for kdump, we must return NOTIFY_OK here to execute the
> +	 * crash_nmi_callback afterwards, see arch/x86/kernel/crash.c
> +	 */
> +	return allow_kdump ? NOTIFY_OK : NOTIFY_STOP;
>  }
>  
>  /*
