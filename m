Return-Path: <linux-kernel-owner+w=401wt.eu-S1761498AbZFXQwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761498AbZFXQwy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 12:52:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760671AbZFXQwq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 12:52:46 -0400
Received: from fmailhost06.isp.att.net ([207.115.11.56]:39146 "EHLO
	fmailhost06.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756075AbZFXQwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 12:52:46 -0400
X-Originating-IP: [65.28.94.183]
Message-ID: <4A4259E2.8090006@lwfinger.net>
Date: Wed, 24 Jun 2009 11:52:50 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Gary Hade <garyhade@us.ibm.com>
CC: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>, Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Regression with commit f9cde5f in 2.6.30-gitX
References: <4A418254.9050607@lwfinger.net> <1245845787.3093.3.camel@localhost.localdomain> <4A423686.8050905@lwfinger.net> <alpine.LFD.2.00.0906241715500.2767@localhost.localdomain> <1245859068.3216.5.camel@localhost.localdomain> <20090624161306.GC7239@us.ibm.com>
In-Reply-To: <20090624161306.GC7239@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gary Hade wrote:

> I think the resource array needs to be larger.  Can you try
> the below patch?
> 
> Gary
> 
> --- linux-2.6.30-rc8/include/linux/pci.h.ORIG	2009-06-24 09:03:41.000000000 -0700
> +++ linux-2.6.30-rc8/include/linux/pci.h	2009-06-24 09:06:50.000000000 -0700
> @@ -319,7 +319,7 @@ static inline void pci_add_saved_cap(str
>  }
>  
>  #ifndef PCI_BUS_NUM_RESOURCES
> -#define PCI_BUS_NUM_RESOURCES	16
> +#define PCI_BUS_NUM_RESOURCES	20
>  #endif
>  
>  #define PCI_REGION_FLAG_MASK	0x0fU	/* These bits of resource flags tell us the PCI region flags */

As noted, I had already tested and posted that increasing
PCI_BUS_NUM_RESOURCES from 16 to 24 "solves" the problem as does
increasing it to 20, but I wonder if that isn't just papering over the
bug, which will reoccur when there is a machine with even a more
complicated PCI bus structure even more complicated than mine. Of
course, increasing it to something as large as 64 might delay the
problem "forever".

Larry


