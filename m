Return-Path: <linux-kernel-owner+w=401wt.eu-S1758375AbZDAXmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758375AbZDAXmU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 19:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754735AbZDAXmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 19:42:05 -0400
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:27030 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752858AbZDAXmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 19:42:03 -0400
X-Trace: 176155451/mk-filter-1.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.41.47.161/None/adrian@newgolddream.dyndns.info
X-SBRS: None
X-RemoteIP: 80.41.47.161
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-MUA: Evolution 2.24.3 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApwEAC+Y00lQKS+h/2dsb2JhbACBU81vg30G
X-IronPort-AV: E=Sophos;i="4.39,309,1235952000"; 
   d="scan'208";a="176155451"
Subject: Re: [PATCH] snd: aica - fix annoying compiler warning
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Takashi Iwai <tiwai@suse.de>,
       Alsa-devel <alsa-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-sh <linux-sh@vger.kernel.org>
In-Reply-To: <20090330231043.GF19535@linux-sh.org>
References: <1237154740.6636.4.camel@localhost.localdomain>
	 <s5htz5urnae.wl%tiwai@suse.de>
	 <1237190049.6513.3.camel@localhost.localdomain>
	 <s5hd4chsxt3.wl%tiwai@suse.de>  <20090330231043.GF19535@linux-sh.org>
Content-Type: text/plain
Date: Thu, 02 Apr 2009 00:41:50 +0100
Message-Id: <1238629310.7455.0.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-31 at 08:10 +0900, Paul Mundt wrote:
> On Mon, Mar 16, 2009 at 08:59:20AM +0100, Takashi Iwai wrote:
> > At Mon, 16 Mar 2009 07:54:09 +0000,
> > Adrian McMenamin wrote:
> > > 
> > > On Mon, 2009-03-16 at 07:31 +0100, Takashi Iwai wrote:
> > > > At Sun, 15 Mar 2009 22:05:40 +0000,
> > > > Adrian McMenamin wrote:
> > > > > 
> > > > > Cast pointer to data member of struct firmware as a void to end an
> > > > > annoying compiler warning.
> > > > > 
> > > > > fix annoying compiler warning
> > > > > 
> > > > > Signed-off-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
> > > > > ---
> > > > > 
> > > > > diff --git a/sound/sh/aica.c b/sound/sh/aica.c
> > > > > index 7c920f3..822b119 100644
> > > > > --- a/sound/sh/aica.c
> > > > > +++ b/sound/sh/aica.c
> > > > > @@ -567,7 +567,7 @@ static int load_aica_firmware(void)
> > > > >  		return err;
> > > > >  	/* write firware into memory */
> > > > >  	spu_disable();
> > > > > -	spu_memload(0, fw_entry->data, fw_entry->size);
> > > > > +	spu_memload(0, (void *)fw_entry->data, fw_entry->size);
> > > > 
> > > > IMO, it's better to fix spu_memload() to take const pointer instead of 
> > > > cast.
> > > > 
> > > 
> > > If that's what you want I can do that but it adds to kernel bloat by
> > > having two functions essentially do the same thing.
> > 
> > I meant a fix like below...
> > 
> Is anything happening with this, or should I just ignore it? 
> 

I though Takashi's fix was fine/obvious but it doesn't appear to have
been pushed upstream (yet?)

