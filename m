Return-Path: <linux-kernel-owner+w=401wt.eu-S1757639AbXLKXAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757639AbXLKXAa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 18:00:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752936AbXLKXAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 18:00:19 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:57112 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752103AbXLKXAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 18:00:18 -0500
Date: Wed, 12 Dec 2007 00:00:15 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [2.6 patch] drivers/pci/msi.c: move arch hooks to the top
Message-ID: <20071211230015.GD14204@stusta.de>
References: <20071211221940.GA14204@stusta.de> <1197413050.7276.1.camel@concordia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1197413050.7276.1.camel@concordia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2007 at 09:44:10AM +1100, Michael Ellerman wrote:
> On Tue, 2007-12-11 at 23:19 +0100, Adrian Bunk wrote:
> > This patch fixes the following problem present with older gcc versions:
> > 
> > <--  snip  -->
> > 
> > ...
> >   CC      drivers/pci/msi.o
> > /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/pci/msi.c:692: warning: weak declaration of `arch_msi_check_device' after first use results in unspecified behavior
> > /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/pci/msi.c:704: warning: weak declaration of `arch_setup_msi_irqs' after first use results in unspecified behavior
> > /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/pci/msi.c:724: warning: weak declaration of `arch_teardown_msi_irqs' after first use results in unspecified behavior
> > ...
> > 
> > <--  snip  -->
> 
> They're declared in <linux/msi.h>, I don't see what it's problem is.

Older gcc versions don't like that they cannot see that they are weak 
functions at the time when they are used.

I'm not sure whether the generated code does the right thing, but even 
if it does rearranging the code doesn't do any harm here.

> cheers

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

