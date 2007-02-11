Return-Path: <linux-kernel-owner+w=401wt.eu-S932856AbXBKN52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932856AbXBKN52 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 08:57:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932858AbXBKN52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 08:57:28 -0500
Received: from 1wt.eu ([62.212.114.60]:2356 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932856AbXBKN51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 08:57:27 -0500
Date: Sun, 11 Feb 2007 14:57:08 +0100
From: Willy Tarreau <w@1wt.eu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       Daniel Barkalow <barkalow@iabervon.org>, nigel@nigel.suspend2.net,
       Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.osdl.org>
Subject: Re: [PATCH] Re: NAK new drivers without proper power management?
Message-ID: <20070211135708.GC1868@1wt.eu>
References: <fa.xSKPgY66Q+DPCZ1pszFFfdrJ0To@ifi.uio.no> <20070211131957.GA6039@srcf.ucam.org> <20070211133710.GB1868@1wt.eu> <200702111450.49736.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702111450.49736.rjw@sisk.pl>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 11, 2007 at 02:50:48PM +0100, Rafael J. Wysocki wrote:
> On Sunday, 11 February 2007 14:37, Willy Tarreau wrote:
> > On Sun, Feb 11, 2007 at 01:19:57PM +0000, Matthew Garrett wrote:
> > > On Sun, Feb 11, 2007 at 02:09:43PM +0100, Willy Tarreau wrote:
> > > 
> > > > Then change the PCI layer to do the basic PM only for known compatible
> > > > drivers, and modify only the known-compatible drivers to mark them
> > > > explicitly compatible. IMHO, it generally is a bad idea to require that
> > > > any driver explicitly states what it *does not* support. It's the reason
> > > > why users encounter problem on new features with old drivers. For instance,
> > > > do you know if the old ISA NE2000 driver breaks suspend ? I don't know,
> > > > but I would at least expect it not to support it by default. It's best
> > > > to announce what *is* supported and consider everything unimplemented
> > > > otherwise explicitly stated.
> > > 
> > > This ignores the reality of the situation, which is that many drivers 
> > > support suspend and resume despite the lack of any explicit 
> > > implementation. Changing things so they're flagged as broken when 
> > > they're not would be a regression.
> > 
> > Those which are identified as OK should be flagged OK. Only those for
> > which we have no idea should be flagged broken.
> 
> I think we don't need to flag the drivers identified as OK.  Let's flag only
> the suspicious ones.
> 
> Whatever we finally come up with, I'd like to avoid modifying drivers that are
> known good.

I understand your concerns, but the problem is not *current* drivers, but
what will happen to *new* drivers. If we make it implicit that a driver
is compatible, then new drivers will be promoted as good even if nothing
has been done for this.

Regards,
Willy

