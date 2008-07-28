Return-Path: <linux-kernel-owner+w=401wt.eu-S1755561AbYG1K0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561AbYG1K0m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 06:26:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752911AbYG1K0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 06:26:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60798 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752593AbYG1K0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 06:26:32 -0400
Date: Mon, 28 Jul 2008 12:26:29 +0200
From: Karsten Keil <kkeil@suse.de>
To: David Miller <davem@davemloft.net>
Cc: marcel@holtmann.org, linux-kernel@vger.kernel.org, sfr@canb.auug.org.au,
       linuxppc-dev@ozlabs.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: Re: mISDN still breaking the allmodconfig build...
Message-ID: <20080728102629.GA25509@pingi.kke.suse.de>
References: <20080727.170235.97056809.davem@davemloft.net> <93120C4B-D2F4-4479-806B-2141AC3DC607@holtmann.org> <20080727.180736.74131389.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080727.180736.74131389.davem@davemloft.net>
Organization: SuSE Linux AG
X-Operating-System: Linux 2.6.16.54-0.2.5-smp x86_64
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 27, 2008 at 06:07:36PM -0700, David Miller wrote:
> From: Marcel Holtmann <marcel@holtmann.org>
> Date: Mon, 28 Jul 2008 03:03:04 +0200
> 
> > > More fallout from the premature mISDN driver merge:
> > >
> > > drivers/isdn/hardware/mISDN/hfcmulti.c:5255:2: error: #error "not  
> > > running on big endian machines now"
> > 
> > is that only the HFC driver or the whole mISDN stack?
> > 
> > I know that the two old ISDN stacks where really bad on big endian,  
> > but my assumption was that we did sort this out in the end.
> 
> One of the two mISDN drivers uses the deprecated virt_to_bus()
> interface for handling DMA addresses (that doesn't even work on many
> x86 systems these days) and the other mISDN driver gives the above
> big-endian compile time error.
> 

OK this was forgotten to change in a printk from the old driver, the new allocation
code should be OK it use pci_alloc_consistent().
I think it should simple use the returned dmahandle in this printk.

-- 
Karsten Keil
SuSE Labs
ISDN and VOIP development
SUSE LINUX Products GmbH, Maxfeldstr.5 90409 Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
