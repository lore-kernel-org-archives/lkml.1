Return-Path: <linux-kernel-owner+w=401wt.eu-S1753432AbZGFHoC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432AbZGFHoC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 03:44:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756929AbZGFHnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 03:43:46 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:38788 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756924AbZGFHno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 03:43:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=ul0WmXkkwKGE33mLl7kOuu7+xINjKqyjFTPUmd6/0TYtOXCpPltn9phV5snSxhcb+P
         lk6o+ErswqmgFNGX3gwRSPB4bYiYiwwzl5ipl1BH2xrjq+Uodfua+3W2G6AMtoyCSAzC
         jsCo62qU8gTJFBWtE/YnHPkGlzD1rg72RNYfw=
Date: Mon, 6 Jul 2009 09:43:42 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: Peter Feuerer <peter@piie.net>
Cc: Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
       Andreas Mohr <andi@lisas.de>
Subject: Re: [PATCH] Acerhdf: fix fan control for BIOS 3309
Message-ID: <20090706074341.GA27582@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@googlemail.com>,
	Peter Feuerer <peter@piie.net>, Len Brown <lenb@kernel.org>,
	linux-kernel@vger.kernel.org, Andreas Mohr <andi@lisas.de>
References: <20090705135806.GB9778@liondog.tnic>
 <cone.1246812673.209196.4691.1000@onepiie>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cone.1246812673.209196.4691.1000@onepiie>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Sun, Jul 05, 2009 at 06:51:13PM +0200, Peter Feuerer wrote:
> >With BIOS update v3309, the Aspire One has had some changes to how
> >the fan is being controlled. Reads to the fanreg (0x55) do not simply
> >return the on/off values of the fan anymore but rather a different
> >fan stage based on the current temperature. Empirically, I could
> >observe the fan stage being 0x1 when booting the machine, then the
> >temperature went up and the BIOS switched the fan to stage 0x2, making
> >it rotate faster with final stage being fan state 0x3, aka max.
> 
> I think it was already like that before v3309. But in my opinion it
> doesn't matter how fast the fan spins. As soon as it's spinning it's
> making too much noise. That's why I like to use only two states for
> the fan, "on" (noisy, doesn't matter how fast it's spinning) and
> "off" (quiet ;))

Agreed. I'd like to keep that in the patch description though so that we
have that behavior documented somewhere.

> >This requires some changes to the controlling code so that it can
> >still be done adequately. Also, the OFF switch has changed from 0x21
> >to 0x20. It seems almost as if they're using the least significant
> >nibble of the command written to the ioport for the different fan
> >stages.
>
> I've been developping acerhdf with BIOS v3309 since the very
> beginning. And it was working fine with 0x21 all the time. I'm
> going to do some further inverstigations next few days. Thanks for
> reporting!

The thing I'm observing here with the 0x21 command is that whenever it
is written into the ->fanreg, the fan gets turned on for maybe a second
or less and then off again. The 0x20 keeps it off just fine. What does
your BIOS version string say, here it is:

[33340.535861] acerhdf: Acer Aspire One Fan driver, v.0.5.14
[33340.537078] acerhdf: BIOS info: Acer v0.3309, product: AOA150

-- 
Regards/Gruss,
    Boris.
