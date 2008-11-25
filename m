Return-Path: <linux-kernel-owner+w=401wt.eu-S1754584AbYKYAg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584AbYKYAg4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 19:36:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753828AbYKYAgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 19:36:48 -0500
Received: from gir.skynet.ie ([193.1.99.77]:39443 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752827AbYKYAgr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 19:36:47 -0500
Date: Tue, 25 Nov 2008 00:36:45 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: petkovbb@gmail.com, sshtylyov@ru.mvista.com, linux-kernel@vger.kernel.org
Subject: Re: Is the change to IDE probing really necessary?
Message-ID: <20081125003644.GA16241@csn.ul.ie>
References: <20081124155632.GE23190@csn.ul.ie> <20081124184321.GA8293@csn.ul.ie> <20081124185453.57ca7dcc@lxorguk.ukuu.org.uk> <20081124230948.GB8293@csn.ul.ie> <20081125000306.014f7771@lxorguk.ukuu.org.uk> <20081125001618.GD8293@csn.ul.ie> <20081125003002.5dcd9783@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20081125003002.5dcd9783@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2008 at 12:30:02AM +0000, Alan Cox wrote:
> > > The mask is set to 0 and then the master/slave are detected based upon
> > > the presence of PCI IDE devices on the master/slave ports.
> > > 
> > 
> > This detection was not happening but then again the proper driver was not
> > compiled. The .config I used was very minimal and lacked most drivers.
> 
> The lspci shows the correct thing happened. You have PCI devices and
> didn't load the right driver. No driver, no support, no suprise.
> 

Yeah, luck seemed to have been working up until this point :/. ide-generic
has been working on the machine since at least 2.6.23 for sure and probably
longer than that which is why it had the hallmarks of a regression even though
ide-generic appears to be doing something more safe and sensible these days.

> > It is certainly the case I was not using the correct driver. Using
> > CONFIG_BLK_DEV_PIIX instead of CONFIG_IDE_GENERIC makes everything work as
> > expected without having to pass special options.
> 
> It would do - and you don't want to use pata_legacy/ide-generic for PCI
> devices. There are several with quirks, some even corruptors that the
> legacy drivers do not know how to handle.
> 

Understood.

> So I think this is a case of 'I put best steam coal in my car and it
> didn't go'

Using piix, I won't have to call in Fred Flintstone to push it with his
legs instead.

Thanks

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
