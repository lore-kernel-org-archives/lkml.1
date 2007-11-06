Return-Path: <linux-kernel-owner+w=401wt.eu-S1756469AbXKFJtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756469AbXKFJtS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 04:49:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753958AbXKFJtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 04:49:09 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:58571 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbXKFJtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 04:49:07 -0500
Subject: Re: device struct bloat
From: Peter Zijlstra <peterz@infradead.org>
To: Greg KH <greg@kroah.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oneukum@suse.de>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org, apw <apw@shadowen.org>,
       Ingo Molnar <mingo@elte.hu>, linux-usb-devel@lists.sourceforge.net
In-Reply-To: <20071105224929.GA30521@kroah.com>
References: <20071103124823.6059640e@shemminger-laptop>
	 <1194208158.5911.63.camel@lappy> <20071105035855.GA25511@kroah.com>
	 <1194259581.27652.418.camel@twins> <1194260234.27652.425.camel@twins>
	 <20071105224929.GA30521@kroah.com>
Content-Type: text/plain
Date: Tue, 06 Nov 2007 10:48:54 +0100
Message-Id: <1194342534.6544.25.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-11-05 at 14:49 -0800, Greg KH wrote:
> On Mon, Nov 05, 2007 at 11:57:14AM +0100, Peter Zijlstra wrote:
> > Hmm, the problem seems to be stuff like:
> > 
> > add usb driver to pci
> >   scan pci devices
> >      add usb host controller device
> >         scan usb devices
> >           add usb hub device
> >             scan usb devices
> >               add usb .....
> > 
> > This seems to be able to go on forever, as long as one can cascade usb
> > hubs.
> 
> USB hubs only work 7 deep, so there is a limit.

Ah, missed that bit of knowledge :-)

> > Doesn't seem like an ideal thing to do from a stack space POV either.
> > 
> > Would it be possible to break at the second scan, that is the device
> > probe and stick that into a workqueue or something. Then we'd only ever
> > have driver->device nesting.
> 
> Alan and Oliver have done some work in this area I think, combined with
> the suspend/bind/unbind issues.  I'll let them comment on your patch :)

Great, so the thing I need to make this work nicely is a limited
device->mutex nesting, if these changes result in that we can work
together to finish this conversion.



