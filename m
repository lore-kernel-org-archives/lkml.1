Return-Path: <linux-kernel-owner+w=401wt.eu-S1756557AbZGPO6H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557AbZGPO6H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 10:58:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751256AbZGPO6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 10:58:06 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:32802 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbZGPO6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 10:58:06 -0400
Date: Thu, 16 Jul 2009 08:58:04 -0600
From: dann frazier <dannf@dannf.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [x86] pci: Get rid of magic number in AMD bus discovery
Message-ID: <20090716145803.GC27036@ldl.fc.hp.com>
References: <20090716002821.GV11729@ldl.fc.hp.com>
 <4A5EFC52.7080201@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A5EFC52.7080201@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 16, 2009 at 03:09:22AM -0700, Yinghai Lu wrote:
> dann frazier wrote:
> > The number 4 is hardcoded in a couple of loops.
> > Use the already-defined PCI_ROOT_NR macro instead.
> > 
> > Signed-off-by: dann frazier <dannf@hp.com>
> > ---
> >  arch/x86/pci/amd_bus.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/pci/amd_bus.c b/arch/x86/pci/amd_bus.c
> > index 3ffa10d..feb3e09 100644
> > --- a/arch/x86/pci/amd_bus.c
> > +++ b/arch/x86/pci/amd_bus.c
> > @@ -332,7 +332,7 @@ static int __init early_fill_mp_bus_info(void)
> >  		return 0;
> >  
> >  	pci_root_num = 0;
> > -	for (i = 0; i < 4; i++) {
> > +	for (i = 0; i < PCI_ROOT_NR; i++) {
> >  		int min_bus;
> >  		int max_bus;
> >  		reg = read_pci_config(bus, slot, 1, 0xe0 + (i << 2));
> > @@ -368,7 +368,7 @@ static int __init early_fill_mp_bus_info(void)
> >  	memset(range, 0, sizeof(range));
> >  	range[0].end = 0xffff;
> >  	/* io port resource */
> > -	for (i = 0; i < 4; i++) {
> > +	for (i = 0; i < PCI_ROOT_NR; i++) {
> >  		reg = read_pci_config(bus, slot, 1, 0xc0 + (i << 3));
> >  		if (!(reg & 3))
> >  			continue;
> 
> please don't do that.
> 
> how about
>         /* mmio resource */
>         for (i = 0; i < 8; i++) {
> 
> those value is decided by HW...

Sorry, I don't follow.
My goal was just to remove the magic '4' number and replace it with a
macro instead - not to bump it up. PCI_ROOT_NR looked like the right
value (used in declaring the array we are indexing), but if not maybe
some other macro should be defined?

-- 
dann frazier

