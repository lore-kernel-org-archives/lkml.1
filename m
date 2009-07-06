Return-Path: <linux-kernel-owner+w=401wt.eu-S1757120AbZGFHtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757120AbZGFHtS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 03:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752835AbZGFHtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 03:49:08 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:60828 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831AbZGFHtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 03:49:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=FTRY62H9y7aYRug+nIdgPK/Btk9wGyCyo0FJRBOKYVXnL3yy6eLP0cILpZ4YyANXjR
         dXpK4q0U1wSms9CsdpxWoIulyzmZJ5RiYyLq/jkdmpYohkZzYARDsepm+i9YJnjATbEr
         hgslCxF9mgu0v2q985lIrSyex8+KXCDkUl31w=
Date: Mon, 6 Jul 2009 09:49:04 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: Andreas Mohr <andi@lisas.de>
Cc: Peter Feuerer <peter@piie.net>, Len Brown <lenb@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Acerhdf: fix fan control for BIOS 3309
Message-ID: <20090706074904.GB27582@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@googlemail.com>,
	Andreas Mohr <andi@lisas.de>, Peter Feuerer <peter@piie.net>,
	Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org
References: <20090705135806.GB9778@liondog.tnic>
 <cone.1246812673.209196.4691.1000@onepiie>
 <20090705190815.GA25926@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090705190815.GA25926@rhlx01.hs-esslingen.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 05, 2009 at 09:08:15PM +0200, Andreas Mohr wrote:
> Hi,
> 
> On Sun, Jul 05, 2009 at 06:51:13PM +0200, Peter Feuerer wrote:
> > Hi Boris,
> >
> > Borislav Petkov writes:
> >> With BIOS update v3309, the Aspire One has had some changes to how
> >> the fan is being controlled. Reads to the fanreg (0x55) do not simply
> >> return the on/off values of the fan anymore but rather a different
> >> fan stage based on the current temperature. Empirically, I could
> >> observe the fan stage being 0x1 when booting the machine, then the
> >> temperature went up and the BIOS switched the fan to stage 0x2, making
> >> it rotate faster with final stage being fan state 0x3, aka max.
> >
> > I think it was already like that before v3309. But in my opinion it 
> > doesn't matter how fast the fan spins. As soon as it's spinning it's 
> > making too much noise. That's why I like to use only two states for the 
> > fan, "on" (noisy, doesn't matter how fast it's spinning) and "off" (quiet 
> > ;))
> 
> I really don't think so.
> 
> If you're in a meeting (think university environment, where _many_ netbooks
> end up being used due to highly mobile requirements...)
> or a moderately occupied room, then there's some ambient noise
> (say, one guy speaking) which I'm pretty damn sure fully drowns out
> the first level of fan operation but certainly NOT the second or third level
> (extrapolating from my very own experience here...).
> 
> Due to these effects I'd think we want to adapt the driver to handle this.
> Though I'm very well aware that going the extra mile of "intelligent"
> temperature handling might cause a ton of extra risks if we aren't
> careful. ;)
> 
> Still, I believe it would be very useful to keep fan operation low for
> moderate distances beyond fan trip point.
> 
> And ideally add a module parameter for aggressive ("binary" fan
> operation) vs. soft ("intelligent" fan operation) handling, whatever
> a user desires, for noise or power consumption or whatever reasons.

That functionality is already in the BIOS. At least the v3309 I got
here. You simply remove the module and it does the intelligent control
with the different fan levels based on current temperature. But when
you're somewhere really quiet or you're getting annoyed even by the
level 1 fan rotation you'd still like to kill that noise (you know how
those cheap fans are :)) and that's when the module comes in.

-- 
Regards/Gruss,
    Boris.
