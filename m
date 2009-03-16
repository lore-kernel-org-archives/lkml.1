Return-Path: <linux-kernel-owner+w=401wt.eu-S1761299AbZCPVFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761299AbZCPVFz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 17:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759198AbZCPVFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 17:05:46 -0400
Received: from [213.79.90.228] ([213.79.90.228]:1931 "EHLO
	buildserver.ru.mvista.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758998AbZCPVFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 17:05:45 -0400
Date: Tue, 17 Mar 2009 00:05:42 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Pierre Ossman <drzeus@drzeus.cx>
Cc: Ben Dooks <ben-linux@fluff.org>, Arnd Bergmann <arnd@arndb.de>,
       Kumar Gala <galak@kernel.crashing.org>,
       Liu Dave <DaveLiu@freescale.com>, sdhci-devel@list.drzeus.cx,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 05/13] sdhci: Add support for card-detection polling
Message-ID: <20090316210542.GA1991@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20090213144630.GA13436@oksana.dev.rtsoft.ru> <20090213144718.GE23889@oksana.dev.rtsoft.ru> <20090221165821.1239aa5a@mjolnir.ossman.eu> <20090304174917.GD7477@oksana.dev.rtsoft.ru> <20090308151121.291f1abb@mjolnir.ossman.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
In-Reply-To: <20090308151121.291f1abb@mjolnir.ossman.eu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 08, 2009 at 03:11:21PM +0100, Pierre Ossman wrote:
> On Wed, 4 Mar 2009 20:49:17 +0300
> Anton Vorontsov <avorontsov@ru.mvista.com> wrote:
> 
> > On Sat, Feb 21, 2009 at 04:58:21PM +0100, Pierre Ossman wrote:
> > > Just modify the if-clause and
> > > things will work.
> > 
> > That would look horrid...
> > 
> >         if ((!(host->quirks & SDHCI_QUIRK_BROKEN_CARD_DETECTION) &&
> >                         !(sdhci_readl(host, SDHCI_PRESENT_STATE) &
> >                                 SDHCI_CARD_PRESENT)) ||
> >                         (host->flags & SDHCI_DEVICE_DEAD)) {
> > 
> 
> There are worse ones in that code, but I see your point. :)
> 
> > > Might want to add a comment also to make it more obvious what the
> > > if-clause does.
> > 
> > Let's try to avoid the if-clause above? How about this:
> > 
> 
> Looks ok.
> 
> > @@ -1096,6 +1099,7 @@ out:
> >  static void sdhci_request(struct mmc_host *mmc, struct mmc_request *mrq)
> >  {
> >  	struct sdhci_host *host;
> > +	bool present;
> >  	unsigned long flags;
> >  
> >  	host = mmc_priv(mmc);
> 
> Can we use bool in the kernel?

Sure, it's widely used in the kernel, even in such places as
mm/ or kernel/.


Thanks for the review!

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
