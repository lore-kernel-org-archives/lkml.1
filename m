Return-Path: <linux-kernel-owner+w=401wt.eu-S933544AbXCJIVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933544AbXCJIVh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 03:21:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933541AbXCJIVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 03:21:37 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4629 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933539AbXCJIVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 03:21:35 -0500
Date: Sat, 10 Mar 2007 08:21:25 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC] implement __attribute_discard_text/data__ and use it to leave out PM functions if !CONFIG_PM
Message-ID: <20070310082124.GA6771@ucw.cz>
References: <20070305033819.GA32687@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070305033819.GA32687@htj.dyndns.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> This patch is the result from the following discussion.
> 
>   http://thread.gmane.org/gmane.linux.ide/16475
> 
> The problem is that CONFIG_PM affects a lot of low level drivers and
> scattering CONFIG_PM all over the place is too ugly.  This patch...
> 
> * implements __attribute_discard_text__ and __attribute_discard_data__
>   (not implemented for modules yet, only for built-ins)
> * uses them to implement __pm and __pmdata markers
> * convert libata midlayer and ahci to use it instead of CONFIG_PM
> 
> __attribute_discard_text/data__ puts the marked symbols in separate
> sections which are located from VMA 0 and discarded when generating
> the final image.  It's similar to putting those into /DISCARD/ section
> but won't complain even if the discarded symbols are referenced by
> active sections.  As the discard sections are located from VMA 0,
> actually dereferencing such symbols will result in OOPS.
> 
> This trick certainly makes LLDs cleaner but there are also some
> downsides, so here are the cons.
> 
> * Cannot depend on the compiler to detect illegal dereferences to
>   discarded symbols.  We probably can do this using sparse.
> 
> * Cannot use the compiler to detect unused but unmarked symbols.  This
>   also probably can be done with sparse.
> 
> * EXPORT_SYMBOL() is nullified, so it will take extra bytes for
>   each symbol marked with __pm.  (insignificant)
> 
> * Implementation involves modifying kernel image, module build process
>   and possibly sparse.  It might be too expensive to achieve device
>   driver prettiness, but there are a lot of device drivers out there
>   and a lot of CONFIG_PM's to be added.  Also, discard attributes can
>   be used for other purposes too.
> 
> Any better ideas?  Comments?

Seems ok to me. Certainly better than config_pm...

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
