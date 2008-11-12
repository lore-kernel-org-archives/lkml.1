Return-Path: <linux-kernel-owner+w=401wt.eu-S1753261AbYKLSFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261AbYKLSFb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 13:05:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751232AbYKLSFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 13:05:22 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:40919 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbYKLSFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 13:05:21 -0500
Date: Wed, 12 Nov 2008 19:05:19 +0100
From: Andreas Mohr <andi@lisas.de>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Takashi Iwai <tiwai@suse.de>, Andreas Mohr <andi@lisas.de>,
       linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [alsa-devel] Bugs on aspire one A150
Message-ID: <20081112180519.GA21919@rhlx01.hs-esslingen.de>
References: <s5h3ai11dpt.wl%tiwai@suse.de> <20081109151323.GA18705@rhlx01.hs-esslingen.de> <s5h7i7c916e.wl%tiwai@suse.de> <20081109200929.GA29333@rhlx01.hs-esslingen.de> <s5hiqqtkxqr.wl%tiwai@suse.de> <491B0D38.1050207@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <491B0D38.1050207@gmail.com>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Nov 12, 2008 at 07:07:04PM +0200, Maxim Levitsky wrote:
> I pretty much studied the datasheet and driver, and this is what I found:
> btw, my acer 5720 and aspire one share same ALC268.
> Some stuff is trivially fixable, some seems to be unfixable at all:

Wow, what an extremely in-depth analysis!
I just intended to dive into getting mic routing corrected myself,
thus you saved me a lot of time!

> model=acer is used on my regular laptop.
> model-acer-aspire is used on aspire one laptop, and it needs to be renamed, as both are aspire.

+1 (your analysis of both being rather different - as already pondered -
confirms this necessity)

> And now for unfixable problems:
>
> 1) There is strong DC offset on all inputs.
> it is even different on left/right and depends on capture volume.
> I tried to change the VREF only param that could help, but it doesn't.
> I feel that this is hardware flaw.
> (It is possible that voltage on inputs is created by circuit made by acer, and then ALC268 amplifies it.)

Sounds like really bad circuit design then.
One would think that the Intel HDA architecture might have builtin
measures to compensate for this if needed? DC offset issues on
soundcards aren't exactly a new phenomenon after all...

> Lastly I noticed that datasheet mentions so called 'coefficients':
> the codecs exposes lots of internal and undocumented registers using set address/ get/set value scheme.
> maybe some of above bugs are fixable there, but ether realtek has to provide data for that or reverse engineering of
> windows driver is required.

I've actually had a peek at the .inf files since I thought that it would
already contain register values in those registry keys that it creates on
install, but yeah, that's all in-driver it seems.
Probably time to ask Acer about specifics, especially since I didn't spot
any hda-intel changes in their linux-2.6.23.9lw source.

Thank you very much,

Andreas Mohr
