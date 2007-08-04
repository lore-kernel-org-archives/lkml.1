Return-Path: <linux-kernel-owner+w=401wt.eu-S1764381AbXHDJcY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764381AbXHDJcY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 05:32:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759852AbXHDJcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 05:32:18 -0400
Received: from ns1.suse.de ([195.135.220.2]:57102 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757645AbXHDJcR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 05:32:17 -0400
From: Andi Kleen <ak@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Oops in 2.6.23-rc1-git9, arch/x86_64/pci/k8-bus.c::fill_mp_bus_to_cpumask()
Date: Sat, 4 Aug 2007 11:30:41 +0200
User-Agent: KMail/1.9.1
Cc: Chuck Ebbert <cebbert@redhat.com>, Muli Ben-Yehuda <muli@il.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, riku.seppala@kymp.net,
       Andy Whitcroft <apw@shadowen.org>
References: <46B3A7BB.9000102@redhat.com> <20070803155035.1fb11c9a.akpm@linux-foundation.org>
In-Reply-To: <20070803155035.1fb11c9a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708041130.42038.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 04 August 2007 00:50, Andrew Morton wrote:
> On Fri, 03 Aug 2007 18:10:03 -0400
>
> Chuck Ebbert <cebbert@redhat.com> wrote:
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
> > "x86-64: introduce struct pci_sysdata to facilitate sharing of
> > ->sysdata":

Hmm, will double check. Perhaps Muli's conversion was incomplete.

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
>
> Andy keeps trotting out a patch which will probably fix this,

What patch do you mean? I don't have anything sysdata related
left over.

-Andi
