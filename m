Return-Path: <linux-kernel-owner+w=401wt.eu-S1753115AbZFXXL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115AbZFXXL2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 19:11:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752283AbZFXXLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 19:11:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35045 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751552AbZFXXLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 19:11:18 -0400
Date: Wed, 24 Jun 2009 16:09:36 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Yinghai Lu <yinghai@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Gary Hade <garyhade@us.ibm.com>, Matthew Wilcox <matthew@wil.cx>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-pci@vger.kernel.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>
Subject: Re: [PATCH] x86/pci: don't use crs for root if we only have one root
 bus
In-Reply-To: <4A42AFAC.6000300@kernel.org>
Message-ID: <alpine.LFD.2.01.0906241607100.18460@localhost.localdomain>
References: <20090624122433.GA24781@elte.hu> <20090624145119.GA12664@elte.hu> <4A429EBB.5010209@kernel.org> <4A42AFAC.6000300@kernel.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Should we not just revert 9e9f46c44e487af0a82eb61b624553e2f7118f5b?

The thing says:

 "At this point, it seems to solve more problems than it causes, so let's 
  try using it by default.  It's an easy revert if it ends up causing 
  trouble."

and it clearly does _not_ solve more problems than it causes, and the 
whole message in that commit implies we should revert it.

I'm happy to apply various patches to fix it up, but regardless, I thinkwe 
should revert that commit as bogus. We can try making it the default again 
next round, when maybe it will be true that it doesn't cause issues.

What did it even ever help with?

		Linus

On Wed, 24 Jun 2009, Yinghai Lu wrote:
> 
> for AMD system, when only one PCI root, just set PCI_NO_ROOT_CRS for it
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/pci/amd_bus.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> Index: linux-2.6/arch/x86/pci/amd_bus.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/pci/amd_bus.c
> +++ linux-2.6/arch/x86/pci/amd_bus.c
> @@ -561,6 +561,10 @@ static int __init early_fill_mp_bus_info
>  		}
>  	}
>  
> +	/* don't use _CRS if we only have one root */
> +	if (pci_root_num <= 1)
> +		pci_probe |= PCI_NO_ROOT_CRS;
> +
>  	return 0;
>  }
>  
> 
