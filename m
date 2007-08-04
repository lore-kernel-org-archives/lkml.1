Return-Path: <linux-kernel-owner+w=401wt.eu-S1758930AbXHDGRr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758930AbXHDGRr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 02:17:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753990AbXHDGRk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 02:17:40 -0400
Received: from mtagate1.uk.ibm.com ([195.212.29.134]:18737 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbXHDGRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 02:17:39 -0400
Date: Sat, 4 Aug 2007 09:17:17 +0300
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Andy Whitcroft <apw@shadowen.org>
Cc: Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, riku.seppala@kymp.net,
       Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: Oops in 2.6.23-rc1-git9, arch/x86_64/pci/k8-bus.c::fill_mp_bus_to_cpumask()
Message-ID: <20070804061717.GV25771@rhun.ibm.com>
References: <46B3A7BB.9000102@redhat.com> <20070803155035.1fb11c9a.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070803155035.1fb11c9a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 03, 2007 at 03:50:35PM -0700, Andrew Morton wrote:
> On Fri, 03 Aug 2007 18:10:03 -0400
> Chuck Ebbert <cebbert@redhat.com> wrote:
> 
> > https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=250859
> > 
> > at line 74:
> > 
> > muli@62829: 
> > muli@62829: 					sd = bus->sysdata;
> > muli@62829: 					sd->node = node;   <=====
> > 
> > bus->sysdata is NULL.
> > 
> > Last changed by this hunk of
> > "x86-64: introduce struct pci_sysdata to facilitate sharing of ->sysdata":
> > 
> > @@ -67,7 +69,9 @@ fill_mp_bus_to_cpumask(void)
> >  						continue;
> >  					if (!node_online(node))
> >  						node = 0;
> > -					bus->sysdata = (void *)node;
> > +
> > +					sd = bus->sysdata;
> > +					sd->node = node;
> >  				}		
> >  			}
> >  		}
> > 
> 
> Andy keeps trotting out a patch which will probably fix this, but
> for some reason it doesn't seem to make progress.

Hmm, looks like we're missing one of the paths where sd gets
allocated.

Andy can you please point me to the latest version of your patch? I
recall thinking that it papers over the bug rather than fixing it but
would like to take a second look.

Thanks,
Muli

