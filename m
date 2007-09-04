Return-Path: <linux-kernel-owner+w=401wt.eu-S1753945AbXIDJST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945AbXIDJST (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 05:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751763AbXIDJSD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 05:18:03 -0400
Received: from lana.hrz.tu-chemnitz.de ([134.109.132.3]:36686 "EHLO
	lana.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbXIDJSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 05:18:00 -0400
Date: Tue, 4 Sep 2007 11:17:57 +0200
From: Steffen Klassert <klassert@mathematik.tu-chemnitz.de>
To: Mark Hindley <mark@hindley.org.uk>
Cc: Satyam Sharma <satyam@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Netdev Mailing List <netdev@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH -mm 1/2] 3c59x: Fix uninitialized variable bug
Message-ID: <20070904091757.GC4241@newton.mathematik.tu-chemnitz.de>
References: <alpine.LFD.0.999.0709040340250.8504@enigma.security.iitk.ac.in> <20070904081602.GB4241@newton.mathematik.tu-chemnitz.de> <20070904085331.GH5944@hindley.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070904085331.GH5944@hindley.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Spam-Score: -1.4 (-)
X-Spam-Report: --- Start der SpamAssassin 3.2.3 Textanalyse (-1.4 Punkte)
	Fragen an/questions to:  Postmaster TU Chemnitz <postmaster@tu-chemnitz.de>
	-1.4 ALL_TRUSTED            Nachricht wurde nur ueber vertrauenswuerdige Rechner
	weitergeleitet
	--- Ende der SpamAssassin Textanalyse
X-Scan-Signature: 1eda448be3d4df409c597eaefe2c9e50
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 04, 2007 at 09:53:31AM +0100, Mark Hindley wrote:
> On Tue, Sep 04, 2007 at 02:09:47PM +0530, Satyam Sharma wrote:
> > Hi Steffen,
> > 
> > 
> > On Tue, 4 Sep 2007, Steffen Klassert wrote:
> > 
> > > On Tue, Sep 04, 2007 at 03:45:55AM +0530, Satyam Sharma wrote:
> > > > 
> > > > drivers/net/3c59x.c: In function 'vortex_up':
> > > > drivers/net/3c59x.c:1495: warning: 'err' may be used uninitialized in this function
> > > 
> > > This came in with the recently applied 3c59x-check-return-of-pci_enable_device patch
> > > from Mark Hindley. I just compiled it on a PCI only machine so far, therefore I did
> > > not notice the warning yet.
> > 
> > Hmm, the .config I built with had PCI=y as well. Probably a compiler
> > version difference -- Jeff also mentioned yesterday that some newer
> > GCC versions fail to warn about uninitialized variables cases.
> > 
> 
> Sorry, this is my bad. I have just checked: there is no warning with gcc
> 4.2 or 4.1, but 3.3 emits the warning. 
> 

The only warning that I was able to trigger with gcc 4.2 is in the case of a .config
without PCI support. In this case I get

drivers/net/3c59x.c: In function 'vortex_up':
drivers/net/3c59x.c:1672: warning: 'err' is used uninitialized in this function
                                         ^^
So we have to be more carefull with the newer gcc versions.

Steffen

