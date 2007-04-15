Return-Path: <linux-kernel-owner+w=401wt.eu-S1752851AbXDOLWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851AbXDOLWV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 07:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752853AbXDOLWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 07:22:20 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:4211 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851AbXDOLWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 07:22:20 -0400
Date: Sun, 15 Apr 2007 15:22:22 +0400
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Richard Henderson <rth@twiddle.net>,
       Jay Estabrook <jay.estabrook@hp.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ALPHA: support graphics on non-zero PCI domains (take 2)
Message-ID: <20070415152222.A12703@jurassic.park.msu.ru>
References: <20070415111937.A12310@jurassic.park.msu.ru> <20070415090115.GA18103@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
In-Reply-To: <20070415090115.GA18103@uranus.ravnborg.org>; from sam@ravnborg.org on Sun, Apr 15, 2007 at 11:01:15AM +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 15, 2007 at 11:01:15AM +0200, Sam Ravnborg wrote:
> > +	if (pci_vga_hose && __is_mem_vga(addr)) {
> >  		h = pci_vga_hose->index;
> 
> This code snippet is used in two places.
> A better approach would be to define a small inline function
> that is empty in the NON HOSe case to avod the ifdefs in the
> code logic.

Ok. Actually we have a macro for this.

> > +#ifndef CONFIG_ALPHA_GENERIC
> > +EXPORT_SYMBOL(tsunami_ioportmap);
> > +EXPORT_SYMBOL(tsunami_ioremap);
> > +#endif
> 
> It looks strange that the function is always defined but conditionally exported.
> Also usual style is to place EXPORT right after closing brace of function -
> (with no empty lines in-between).

In a generic kernel the IO functions are never addressed directly,
only via machine vector, so there is no point in exporting them.
What about something like EXPORT_SYMBOL_NONGENERIC() macro?

I agree with your other comments.

Ivan.
