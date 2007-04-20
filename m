Return-Path: <linux-kernel-owner+w=401wt.eu-S2993302AbXDTRdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993302AbXDTRdQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 13:33:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993303AbXDTRdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 13:33:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:59795 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993302AbXDTRdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 13:33:15 -0400
Date: Fri, 20 Apr 2007 10:31:18 -0700
From: Greg KH <gregkh@suse.de>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: const struct pci_driver [Was: [RFC 2/2] Input: phantom, add a
	new driver]
Message-ID: <20070420173118.GA10082@suse.de>
References: <210731960111436322@karneval.cz> <258431179037841809@karneval.cz> <20070419230719.a118a132.akpm@linux-foundation.org> <462879BE.1050401@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <462879BE.1050401@gmail.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2007 at 10:28:46AM +0200, Jiri Slaby wrote:
> Andrew Morton napsal(a):
> > On Tue, 17 Apr 2007 22:02:10 +0200 (CEST) Jiri Slaby <jirislaby@gmail.com> wrote:
> > 
> >> phantom, add a new driver
> [...]
> >> +static struct pci_driver phantom_pci_driver = {
> >> +	.name = "phantom",
> >> +	.id_table = phantom_pci_tbl,
> >> +	.probe = phantom_probe,
> >> +	.remove = __devexit_p(phantom_remove),
> >> +	.suspend = phantom_suspend,
> >> +	.resume = phantom_resume
> >> +};
> > 
> > This goes into the read/write section.  Make it const?
> 
> Hmm, good question, I don't know the answer. Why are not pci_driver structs
> const, Greg?

Because the pci core sets the needed pci_driver.driver structure fields
that the driver core needs in order to properly hook up things.

I'm considering a change to this that would allow pci (and all other)
driver structures be const, and then dynamically create the needed
driver core structure based on this "template" which would also let us
do some other things that the driver core wants, but that work is a few
months away.  When/if I get to that, I'll go through and mark all of the
driver structures const to move them to the read-only kernel section.

thanks,

greg k-h
