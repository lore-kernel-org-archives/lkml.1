Return-Path: <linux-kernel-owner+w=401wt.eu-S1752912AbZK3Ncs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912AbZK3Ncs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 08:32:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752601AbZK3Ncr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 08:32:47 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:33102 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375AbZK3Ncq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 08:32:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=nRO7U34LAJvuganp/43FpqxhGTBg/5P+IjNwassIeC07J7GZX0kegUGwYLxUF6xYHb
         gTqejokUwfAg0nA9gxFLJxmE1qprrJTclEU3RasmDjBolmi9NWUGiEaV+druLPz0hh3b
         ZsXglEjWlheMCvtI/Linju9vQeDOg/s0/adKw=
Subject: Re: [PATCH] mmc: add module parameter to set whether cards are
 assumed removable
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Pierre Ossman <pierre@ossman.eu>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Ben Hutchings <ben@decadent.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>, linux-mmc@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, 504391@bugs.debian.org,
       Wouter van Heyst <larstiq@larstiq.dyndns.org>
In-Reply-To: <20091130133949.794fef00@mjolnir.ossman.eu>
References: <1257914676.2237.57.camel@localhost>
	 <20091116122329.847916b6.akpm@linux-foundation.org>
	 <1258410709.2792.9.camel@localhost> <4B02565C.1030406@s5r6.in-berlin.de>
	 <20091130133949.794fef00@mjolnir.ossman.eu>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 Nov 2009 15:32:46 +0200
Message-ID: <1259587966.13049.6.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-30 at 13:39 +0100, Pierre Ossman wrote: 
> On Tue, 17 Nov 2009 08:53:00 +0100
> Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> 
> > Ben Hutchings wrote:
> > > In general, it is not possible to tell whether a card present in an MMC
> > > slot after resume is the same that was there before suspend.
> > 
> > That's true for virtually all storage devices, not just MMC.
> > 
> > > So there are two possible behaviours, each of which will cause data
> > > loss in some cases:
> > > 
> > > CONFIG_MMC_UNSAFE_RESUME=n (default): Cards are assumed to be removed
> > > during suspend.  Any filesystem on them must be unmounted before
> > > suspend; otherwise, buffered writes will be lost.
> > > 
> > > CONFIG_MMC_UNSAFE_RESUME=y: Cards are assumed to remain present during
> > > suspend.  They must not be swapped during suspend; otherwise, buffered
> > > writes will be flushed to the wrong card.
> > > 
> > > Currently the choice is made at compile time and this allows that to be
> > > overridden at module load time.
> > 
> > Can't the kernel flush the write buffer at suspend time, so that you can
> > remove this choice for good?
> 
> I'm afraid that's insufficient. What it would need to do is to is
> flush everything (to make sure what's on disk matches what's in
> memory), but also read back the filesystem on resume to verify that
> nothing else modified it (i.e. making sure what's on disk still matches
> what's in memory).

I had just an idea.

Before we do suspend, pick few random sectors from the media, run that
through some hash function, thus creating some sort of watermark.

On resume do that again.

This should catch all unintentional card swappings.

Of course this is only half of the problem, because user could edit the
card meanwhile, but still solving half the problem is better that
nothing?


What do you think ?

Best regards,
Maxim Levitsky

