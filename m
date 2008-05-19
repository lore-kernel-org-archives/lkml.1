Return-Path: <linux-kernel-owner+w=401wt.eu-S1763460AbYESU1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763460AbYESU1U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 16:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752360AbYESU1C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 16:27:02 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48056 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763284AbYESU1A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 16:27:00 -0400
Date: Mon, 19 May 2008 17:26:54 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: [PATCH] msi: skip calling pci_find_capability from
	msi_set_mask_bits
Message-ID: <20080519202654.GE17967@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@redhat.com>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
	Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
	linux-pci@vger.kernel.org, linux-rt-users@vger.kernel.org
References: <20080515160426.GD14846@ghostprotocols.net> <200805161044.34938.jbarnes@virtuousgeek.org> <48310691.9050706@jp.fujitsu.com> <200805191311.46162.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805191311.46162.jbarnes@virtuousgeek.org>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, May 19, 2008 at 01:11:45PM -0700, Jesse Barnes escreveu:
> On Sunday, May 18, 2008 9:48 pm Hidetoshi Seto wrote:
> > Jesse Barnes wrote:
> > > Since we know MSI is a problem, let's just go with fixing that for now. 
> > > If we find that other caps are also causing problems we can revisit
> > > caching all of them; the patch is simple enough.
> >
> > Humm...
> > I suppose it can be more simple. How about this patch?
> >
> > > everytime handle_edge_irq is called it needs to mask and unmask MSI, and
> > > that leads to a series of very expensive calls to pci_find_capability
> >
> > The position of MSI capability is already cached in the msi_desc when
> > we enter the msi_set_mask_bits().  Use it instead.
> >
> > Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
> 
> Yeah, this looks really nice.  It should also fix Arnaldo's latency problem, 
> and really looks like a bug fix for the MSI code more than anything.
> 
> Arnaldo, can you take a look & test and ack/nack?

I'll do that now

- Arnaldo
