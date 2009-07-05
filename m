Return-Path: <linux-kernel-owner+w=401wt.eu-S1754500AbZGETIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500AbZGETIW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 15:08:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752725AbZGETIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 15:08:13 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:53885 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191AbZGETIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 15:08:13 -0400
Date: Sun, 5 Jul 2009 21:08:15 +0200
From: Andreas Mohr <andi@lisas.de>
To: Peter Feuerer <peter@piie.net>
Cc: Borislav Petkov <petkovbb@googlemail.com>, Len Brown <lenb@kernel.org>,
       linux-kernel@vger.kernel.org, Andreas Mohr <andi@lisas.de>
Subject: Re: [PATCH] Acerhdf: fix fan control for BIOS 3309
Message-ID: <20090705190815.GA25926@rhlx01.hs-esslingen.de>
References: <20090705135806.GB9778@liondog.tnic> <cone.1246812673.209196.4691.1000@onepiie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cone.1246812673.209196.4691.1000@onepiie>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Jul 05, 2009 at 06:51:13PM +0200, Peter Feuerer wrote:
> Hi Boris,
>
> Borislav Petkov writes:
>> With BIOS update v3309, the Aspire One has had some changes to how
>> the fan is being controlled. Reads to the fanreg (0x55) do not simply
>> return the on/off values of the fan anymore but rather a different
>> fan stage based on the current temperature. Empirically, I could
>> observe the fan stage being 0x1 when booting the machine, then the
>> temperature went up and the BIOS switched the fan to stage 0x2, making
>> it rotate faster with final stage being fan state 0x3, aka max.
>
> I think it was already like that before v3309. But in my opinion it 
> doesn't matter how fast the fan spins. As soon as it's spinning it's 
> making too much noise. That's why I like to use only two states for the 
> fan, "on" (noisy, doesn't matter how fast it's spinning) and "off" (quiet 
> ;))

I really don't think so.

If you're in a meeting (think university environment, where _many_ netbooks
end up being used due to highly mobile requirements...)
or a moderately occupied room, then there's some ambient noise
(say, one guy speaking) which I'm pretty damn sure fully drowns out
the first level of fan operation but certainly NOT the second or third level
(extrapolating from my very own experience here...).

Due to these effects I'd think we want to adapt the driver to handle this.
Though I'm very well aware that going the extra mile of "intelligent"
temperature handling might cause a ton of extra risks if we aren't
careful. ;)

Still, I believe it would be very useful to keep fan operation low for
moderate distances beyond fan trip point.

And ideally add a module parameter for aggressive ("binary" fan
operation) vs. soft ("intelligent" fan operation) handling, whatever
a user desires, for noise or power consumption or whatever reasons.

Andreas Mohr
