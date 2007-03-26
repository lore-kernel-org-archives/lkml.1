Return-Path: <linux-kernel-owner+w=401wt.eu-S1752462AbXCZDIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462AbXCZDIA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 23:08:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753075AbXCZDIA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 23:08:00 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:34475 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751947AbXCZDH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 23:07:59 -0400
Date: Mon, 26 Mar 2007 05:08:03 +0200
From: Adrian Bunk <bunk@stusta.de>
To: "Kevin P. Fleming" <lkml@kpfleming.us>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
       Jan Beulich <jbeulich@novell.com>, Alan Cox <alan@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: drivers/pci/probe.c patch in 2.6.20.4 causes 'cannot adjust BAR0 (not I/O)' on NVidia MCP51
Message-ID: <20070326030803.GT16477@stusta.de>
References: <460693EB.9080203@kpfleming.us> <20070325161144.GA12155@kroah.com> <20070325210846.05d3f2c8@the-village.bc.nu> <20070325192127.GR16477@stusta.de> <46072F2A.9060803@kpfleming.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <46072F2A.9060803@kpfleming.us>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 25, 2007 at 07:25:46PM -0700, Kevin P. Fleming wrote:
> Adrian Bunk wrote:
> > It also adds PCI_BASE_ADDRESS_SPACE_IO to the flags which it didn't 
> > without the patch.
> 
> As an experiment I modified 2.6.20.4 to _only_ remove that value from
> the combined value for the flags and it did not help in any noticeable
> way. I can reliably boot and operate the machine with the original patch
> reversed, though.

OK thanks, then it's something else.

I see only one more thing that might make any difference:
Perhaps we are not seeing the problematic operation due to the different 
loglevel?

Please change in the third printk() the patch adds the KERN_INFO to 
KERN_WARNING.

If you get a "...trying to change BAR..." before it hangs, remove the 
pci_write_config_dword() line - this should then fix it.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

