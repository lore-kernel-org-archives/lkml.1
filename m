Return-Path: <linux-kernel-owner+w=401wt.eu-S966459AbXILLBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966459AbXILLBf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 07:01:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763878AbXILLB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 07:01:27 -0400
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:36663
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759933AbXILLB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 07:01:26 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH -mm] ssb: Make pcmciahost depend on PCMCIA=y
Date: Wed, 12 Sep 2007 12:59:00 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20070912021100.GB26827@linux-sh.org> <200709121209.10068.mb@bu3sch.de> <20070912101745.GA23417@linux-sh.org>
In-Reply-To: <20070912101745.GA23417@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709121259.00700.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 September 2007 12:17:45 Paul Mundt wrote:
> On Wed, Sep 12, 2007 at 12:09:09PM +0200, Michael Buesch wrote:
> > On Wednesday 12 September 2007 04:11:00 Paul Mundt wrote:
> > > SSB uses a bool (SSB_PCMCIAHOST_POSSIBLE) to determine whether to
> > > build in PCMCIA support or not, as the PCMCIA host code itself is
> > > also only a bool, make SSB_PCMCIAHOST_POSSIBLE depend on PCMCIA=y.
> > > 
> > > Without this, SSB_PCMCIAHOST_POSSIBLE evaluates to y when PCMCIA
> > > is built as a module, which results in link errors due to the
> > > pcmcia_access_configuration_register() accesses, where the symbol
> > > is only defined in a module.
> > > 
> > > --- linux-2.6.23-rc4-mm1.orig/drivers/ssb/Kconfig	2007-09-11 15:15:52.000000000 +0900
> > > +++ linux-2.6.23-rc4-mm1/drivers/ssb/Kconfig	2007-09-12 10:51:53.000000000 +0900
> > > @@ -37,7 +37,7 @@
> > >  
> > >  config SSB_PCMCIAHOST_POSSIBLE
> > >  	bool
> > > -	depends on SSB && PCMCIA && EXPERIMENTAL
> > > +	depends on SSB && PCMCIA=y && EXPERIMENTAL
> > >  	default y
> > >  
> > >  config SSB_PCMCIAHOST
> > > 
> > > 
> > 
> > There we go. The usual SELECT dependency hell again...
> > Would changing SSB_PCMCIAHOST_POSSIBLE to tristate also fix it?
> > What would be the sideeffects?
> > 
> I tried that first, if you do that you have to change the default to
> SSB && PCMCIA, and then anything that depends on it also has to be a
> tristate. That worked ok for SSB_PCMCIAHOST, but it didn't work ok for
> the b43 wireless + PCMCIA, which is why I opted for the PCMCIA=y thing
> instead, which makes sure that SSB_PCMCIAHOST can't be enabled if PCMCIA
> is modular.

Ok, so much for "SELECT is easy and it works if used correctly..." :)
Well, let's apply that patch then. It needlessly restricts the
choice to not allow modular pcmcia in that case, though.

-- 
Greetings Michael.
