Return-Path: <linux-kernel-owner+w=401wt.eu-S1757389AbYFYKNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757389AbYFYKNW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 06:13:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755305AbYFYKNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 06:13:13 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:33973 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755112AbYFYKNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 06:13:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=ef0f0uQRauUbZh4TWV+Kele2mABJBVtPIANd4/yBym9/ENR6tFM1H/d+56Cd+nfL2M
         BjzbBO5WTk49zOb2SYnzt5FHUDRthwHKaYD0lIwFb7hUWgf1jwEULVAhjDAtDXoL+xX8
         qVFn0A6IfJE0TeKyzWqvwAL9y8YOcCWHiduQk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: Removal of BAST IDE driver
Date: Wed, 25 Jun 2008 12:14:14 +0200
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, jgarzik@pobox.com,
       Linux Kernel List <linux-kernel@vger.kernel.org>, ben-linux@fluff.org
References: <20080625090953.GA26556@flint.arm.linux.org.uk>
In-Reply-To: <20080625090953.GA26556@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806251214.14749.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Wednesday 25 June 2008, Russell King wrote:
> Referring to this commit in mainline:
> 
> commit ac1623625c5818bbdf5c68973098ba386ba7a004
> Author: Ben Dooks <ben-linux@fluff.org>
> Date:   Fri Jun 20 20:53:35 2008 +0200
> 
>     BAST: Remove old IDE driver
> 
>     Remove the old BAST IDE driver, as we are now using the platform-pata
>     support.
> 
>     Signed-off-by: Ben Dooks <ben-linux@fluff.org>
>     Cc: Jeff Garzik <jgarzik@pobox.com>
>     Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> 
> I've recieved a couple of patches for the next merge window from Ben
> which say:
> 
> >  Subject: [patch 20/32] BAST/VR1000: Move to using ata_platform (libata)
> >
> >  Use the pata_platform driver to provide the IDE port
> >  drivers on the Simntec BAST and Thorcom VR1000 machines
> >  as a precursor to removing drivers/ide/arm/bast-ide.c
> 
> And when I queried Ben on this, he responded thusly:
> 
> 09:58 < fluffy> yes, bart was rather quicker at applying the removal patch
> 09:59 < fluffy> i send 'for next kernel release' and he shoved it in his -rc6
>                 sub
> 
> So, quite clearly we have a regression - we have platforms which have
> lost IDE support.
> 
> There's two ways to resolve this.  Either the above commit can be
> reverted restoring old IDE support, or the patches to add libata

The libata part is already in, we just need an arch part.

[ Looks like we need this patch from 2008-05-29:

  http://article.gmane.org/gmane.linux.ports.arm.kernel/42021 ]

> support for these platforms can be submitted.  Given where we are in
> the -rc, I think reverting the bad commit would be more sensible.

I think that it is up to arch maintainer to decide, either way is fine
with me.

> The question also has to be asked - what are maintainers doing putting
> driver removals into -rc kernels?  Surely they are only merge-window
> candidates?

This was a special case as indicated in pull request:

...
  [ not strictly -rc stuff but as we are now using the platform-pata
    support lets not confuse people with having this driver around ]
...

I somehow missed 'the next release' part (please indicate it more clearly
when sending patches and always tell us that there are some other patches
which should be merged before if you are not including them in the patch
series) so when later Jeff merged:

commit cc18e0fea7907e7a96b7df71b81838d518bc074e
Author: Ben Dooks <ben-linux@fluff.org>
Date:   Mon Jun 16 12:16:26 2008 +0100

    LIBATA: Add HAVE_PATA_PLATFORM to select PATA_PLATFORM driver
...

which was patch #1/2 in the series I was under impression that now we
have both new and old driver with the old driver being the default because
of the link order.  Seems I was wrong after all as other things are moving
slower than IDE/ATA. ;)

Sorry for messing things up.  Russell/Ben: how should we proceed with
fixing it (arch part in or ide part out)?

Thanks,
Bart
