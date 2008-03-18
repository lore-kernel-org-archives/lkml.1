Return-Path: <linux-kernel-owner+w=401wt.eu-S1753001AbYCRHJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001AbYCRHJv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 03:09:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750870AbYCRHJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 03:09:41 -0400
Received: from john.hrz.tu-chemnitz.de ([134.109.132.2]:50909 "EHLO
	john.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456AbYCRHJl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 03:09:41 -0400
From: Stefan Bauer <stefan.bauer@cs.tu-chemnitz.de>
Organization: Chemnitz University of Technology
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] i810fb: Fix console switch regression
Date: Tue, 18 Mar 2008 08:09:09 +0100
User-Agent: KMail/1.9.5
Cc: linux-fbdev-devel@lists.sourceforge.net,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Antonino Daplas <adaplas@pol.net>
References: <200803161942.24555.stefan.bauer@cs.tu-chemnitz.de> <200803171641.10750.stefan.bauer@cs.tu-chemnitz.de> <20080317204812.2c3e3754.akpm@linux-foundation.org>
In-Reply-To: <20080317204812.2c3e3754.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200803180809.10020.stefan.bauer@cs.tu-chemnitz.de>
X-Spam-Score: -1.4 (-)
X-Spam-Report: --- Start der SpamAssassin 3.2.4 Textanalyse (-1.4 Punkte)
	Fragen an/questions to:  Postmaster TU Chemnitz <postmaster@tu-chemnitz.de>
	-1.4 ALL_TRUSTED            Nachricht wurde nur ueber vertrauenswuerdige Rechner
	weitergeleitet
	--- Ende der SpamAssassin Textanalyse
X-Scan-Signature: bd263acef5c49e825d8b5debdb1b160d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 18. März 2008 04:48 schrieb Andrew Morton:
> On Mon, 17 Mar 2008 16:41:10 +0100 Stefan Bauer 
<stefan.bauer@cs.tu-chemnitz.de> wrote:
> > From: Stefan Bauer <stefan.bauer@cs.tu-chemnitz.de>
> >
> > Since 4c7ffe0b9f7f40bd818fe3af51342f64c483908e ("fbdev: prevent drivers
> > that have hardware cursors from calling software cursor code") every call
> > of i810fb_cursor fails with -ENXIO because of a incorrect "!".
> >
> > This hasn't striked until eaa0ff15c30dc9799eb4d12660edb73aeb6d32c5 ("fix
> > ! versus & precedence in various places") surrounded the expression with
> > braces, so that the intended behavior was inverted. That caused 'pixel
> > waste' - the same line of multi-colored pixels repeated over the whole
> > screen - during console switch.
> >
> > This switches back to the original pre-4c7ffe0 behavior.
> >
> > Signed-off-by: Stefan Bauer <stefan.bauer@cs.tu-chemnitz.de>
> > Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> > Cc: Antonino Daplas <adaplas@pol.net>
> >
> > --- linux-2.6/drivers/video/i810/i810_main.c.orig
> > +++ linux-2.6/drivers/video/i810/i810_main.c
> > @@ -1476,7 +1476,7 @@ static int i810fb_cursor(struct fb_info
> >  	struct i810fb_par *par = info->par;
> >  	u8 __iomem *mmio = par->mmio_start_virtual;
> >
> > -	if (!(par->dev_flags & LOCKUP))
> > +	if (par->dev_flags & LOCKUP)
> >  		return -ENXIO;
> >
> >  	if (cursor->image.width > 64 || cursor->image.height > 64)
>
> Can you please confirm that this actually fixes the bug?  That wasn't
> clear.
>
> Thanks.

Yes, yesterday I worked the whole day with that machine running -rc6 + my 
patch. The regression definitely is fixed, fbi and fbset work w/o problems or 
new regressions.

	Regards
		Stefan
