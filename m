Return-Path: <linux-kernel-owner+w=401wt.eu-S932842AbXBKNhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932842AbXBKNhd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 08:37:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932846AbXBKNhd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 08:37:33 -0500
Received: from 1wt.eu ([62.212.114.60]:2347 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932842AbXBKNhc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 08:37:32 -0500
Date: Sun, 11 Feb 2007 14:37:10 +0100
From: Willy Tarreau <w@1wt.eu>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Daniel Barkalow <barkalow@iabervon.org>,
       nigel@nigel.suspend2.net, Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.osdl.org>
Subject: Re: [PATCH] Re: NAK new drivers without proper power management?
Message-ID: <20070211133710.GB1868@1wt.eu>
References: <fa.xSKPgY66Q+DPCZ1pszFFfdrJ0To@ifi.uio.no> <200702101130.44471.rjw@sisk.pl> <Pine.LNX.4.64.0702101231281.20138@iabervon.org> <200702102050.28218.rjw@sisk.pl> <20070211065404.GA943@1wt.eu> <20070211121339.GB4204@srcf.ucam.org> <20070211130943.GA1868@1wt.eu> <20070211131957.GA6039@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070211131957.GA6039@srcf.ucam.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 11, 2007 at 01:19:57PM +0000, Matthew Garrett wrote:
> On Sun, Feb 11, 2007 at 02:09:43PM +0100, Willy Tarreau wrote:
> 
> > Then change the PCI layer to do the basic PM only for known compatible
> > drivers, and modify only the known-compatible drivers to mark them
> > explicitly compatible. IMHO, it generally is a bad idea to require that
> > any driver explicitly states what it *does not* support. It's the reason
> > why users encounter problem on new features with old drivers. For instance,
> > do you know if the old ISA NE2000 driver breaks suspend ? I don't know,
> > but I would at least expect it not to support it by default. It's best
> > to announce what *is* supported and consider everything unimplemented
> > otherwise explicitly stated.
> 
> This ignores the reality of the situation, which is that many drivers 
> support suspend and resume despite the lack of any explicit 
> implementation. Changing things so they're flagged as broken when 
> they're not would be a regression.

Those which are identified as OK should be flagged OK. Only those for
which we have no idea should be flagged broken. It's better than leaving
them in the wild waiting for a victim. And given what Nigel would like,
they would all have to be reviewed to get .suspend/.resume entries
anyway. But at least, we would only have to change the known good instead
of all of them. And the remaining ones would not cause trouble to users.

Willy

