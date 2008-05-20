Return-Path: <linux-kernel-owner+w=401wt.eu-S1764685AbYETUHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764685AbYETUHP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 16:07:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758538AbYETUG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 16:06:56 -0400
Received: from outbound-mail-25.bluehost.com ([69.89.21.20]:43763 "HELO
	outbound-mail-25.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933775AbYETUGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 16:06:55 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH] msi: skip calling pci_find_capability from msi_set_mask_bits
Date: Tue, 20 May 2008 13:06:45 -0700
User-Agent: KMail/1.9.9
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, linux-rt-users@vger.kernel.org
References: <20080515160426.GD14846@ghostprotocols.net> <200805191311.46162.jbarnes@virtuousgeek.org> <20080520195609.GC6714@ghostprotocols.net>
In-Reply-To: <20080520195609.GC6714@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805201306.45496.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, May 20, 2008 12:56 pm Arnaldo Carvalho de Melo wrote:
> Em Mon, May 19, 2008 at 01:11:45PM -0700, Jesse Barnes escreveu:
> > On Sunday, May 18, 2008 9:48 pm Hidetoshi Seto wrote:
> > > Jesse Barnes wrote:
> > > > Since we know MSI is a problem, let's just go with fixing that for
> > > > now. If we find that other caps are also causing problems we can
> > > > revisit caching all of them; the patch is simple enough.
> > >
> > > Humm...
> > > I suppose it can be more simple. How about this patch?
> > >
> > > > everytime handle_edge_irq is called it needs to mask and unmask MSI,
> > > > and that leads to a series of very expensive calls to
> > > > pci_find_capability
> > >
> > > The position of MSI capability is already cached in the msi_desc when
> > > we enter the msi_set_mask_bits().  Use it instead.
> > >
> > > Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
> >
> > Yeah, this looks really nice.  It should also fix Arnaldo's latency
> > problem, and really looks like a bug fix for the MSI code more than
> > anything.
> >
> > Arnaldo, can you take a look & test and ack/nack?
>
> Tested, works as expected, thanks.
>
> Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>

Great, thanks a lot for testing (and getting us on track to fix this in the 
first place!).

Jesse
