Return-Path: <linux-kernel-owner+w=401wt.eu-S1757229AbZGEQvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229AbZGEQvT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 12:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753217AbZGEQvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 12:51:08 -0400
Received: from smtprelay05.ispgateway.de ([80.67.31.39]:60056 "EHLO
	smtprelay05.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674AbZGEQvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 12:51:07 -0400
References: <20090705135806.GB9778@liondog.tnic>
Message-ID: <cone.1246812673.209196.4691.1000@onepiie>
X-Mailer: http://www.courier-mta.org/cone/
From: Peter Feuerer <peter@piie.net>
To: Borislav Petkov <petkovbb@googlemail.com>
Cc: Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
       Andreas Mohr <andi@lisas.de>
Subject: Re: [PATCH] Acerhdf: fix fan control for BIOS 3309
Date: Sun, 05 Jul 2009 18:51:13 +0200
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
X-Df-Sender: 404094
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris,

Borislav Petkov writes:

> Hi Len,
> 
> please apply.
> 
> ---
> From: Borislav Petkov <petkovbb@gmail.com>
> Date: Sun, 5 Jul 2009 14:35:01 +0200
> Subject: [PATCH] Acerhdf: fix fan control for BIOS 3309
> 
> With BIOS update v3309, the Aspire One has had some changes to how
> the fan is being controlled. Reads to the fanreg (0x55) do not simply
> return the on/off values of the fan anymore but rather a different
> fan stage based on the current temperature. Empirically, I could
> observe the fan stage being 0x1 when booting the machine, then the
> temperature went up and the BIOS switched the fan to stage 0x2, making
> it rotate faster with final stage being fan state 0x3, aka max.

I think it was already like that before v3309. But in my opinion it doesn't 
matter how fast the fan spins. As soon as it's spinning it's making too much 
noise. That's why I like to use only two states for the fan, "on" (noisy, 
doesn't matter how fast it's spinning) and "off" (quiet ;))

> This requires some changes to the controlling code so that it can still
> be done adequately. Also, the OFF switch has changed from 0x21 to 0x20.
> It seems almost as if they're using the least significant nibble of the
> command written to the ioport for the different fan stages.

I've been developping acerhdf with BIOS v3309 since the very beginning. And 
it was working fine with 0x21 all the time. I'm going to do some further 
inverstigations next few days. Thanks for reporting!

> 
> While at it, convert the fancmd[] array to a real struct thus
> disambiguating command handling and making code more readable.

Good!

kind regards,
--peter
