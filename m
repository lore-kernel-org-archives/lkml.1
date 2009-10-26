Return-Path: <linux-kernel-owner+w=401wt.eu-S1753449AbZJZVVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449AbZJZVVv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 17:21:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752418AbZJZVVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 17:21:50 -0400
Received: from outbound-mail-160.bluehost.com ([67.222.39.40]:58604 "HELO
	outbound-mail-160.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752353AbZJZVVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 17:21:50 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=qtNh7Cevo3NfWVDbUygxpxqfBsEuD23C64Wg/eON71duhmCtj8fHPrAMfijBV7rc7BIHMGvl5UF7gKxui8NH7UIak4O3ql5Ca7fL1IEZONFCFafrHtRLB16IPVn0Ji0/;
Date: Mon, 26 Oct 2009 14:21:50 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Andrew Patterson <andrew.patterson@hp.com>,
       "prarit@redhat.com" <prarit@redhat.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "pci-linux@vger.kernel.org" <pci-linux@vger.kernel.org>
Subject: Re: [PATCH 5/5] PCI: fix memory leak in aer_inject
Message-ID: <20091026142150.37711e0d@jbarnes-g45>
In-Reply-To: <1255333470.6047.141.camel@yhuang-dev.sh.intel.com>
References: <20091012070248.27029.78378.stgit@bob.kio>
	<20091012070314.27029.35077.stgit@bob.kio>
	<1255333470.6047.141.camel@yhuang-dev.sh.intel.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Oct 2009 15:44:30 +0800
Huang Ying <ying.huang@intel.com> wrote:

> On Mon, 2009-10-12 at 15:03 +0800, Andrew Patterson wrote: 
> > PCI: fix memory leak in aer_inject
> > 
> > Fixed probable typo in aer_inject cleanup code resulting in a memory
> > leak.
> > 
> > Signed-off-by: Andrew Patterson <andrew.patterson@hp.com>
> > ---
> > 
> > diff --git a/drivers/pci/pcie/aer/aer_inject.c
> > b/drivers/pci/pcie/aer/aer_inject.c index da2ad6e..2246bf7 100644
> > --- a/drivers/pci/pcie/aer/aer_inject.c
> > +++ b/drivers/pci/pcie/aer/aer_inject.c
> > @@ -474,7 +474,7 @@ static void __exit aer_inject_exit(void)
> >  	}
> >  
> >  	spin_lock_irqsave(&inject_lock, flags);
> > -	list_for_each_entry_safe(err, err_next, &pci_bus_ops_list,
> > list) {
> > +	list_for_each_entry_safe(err, err_next, &einjected, list) {
> >  		list_del(&err->list);
> >  		kfree(err);
> >  	}
> 
> Thanks for the patch.
> 
> Acked-by: Huang Ying <ying.huang@intel.com>
> 

How do the rest of the patches look, Ying?  Should I add your acked-by
on Andrew's latest set?

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
