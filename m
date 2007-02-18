Return-Path: <linux-kernel-owner+w=401wt.eu-S1751824AbXBRS3P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824AbXBRS3P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 13:29:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751830AbXBRS3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 13:29:15 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:63565 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824AbXBRS3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 13:29:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=DZ2ePlfwfVqeGYOoqlLe/CclI0CLBIGi1KjZBPBmXV1pEjLkofMnCbmV9gvtU5CjOSCdNE+ZbXnopD+DqYiE7dZgbF2TOoTHYs7acskAZGm+kCutCM0XJDOBCC/j6aKrVQukZg1ZDUfTAtS9+iq72WeUaUINasyYM/aP7TI3v8U=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Roman Zippel <zippel@linux-m68k.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kbuild: Add the code maturity levels DEPRECATED and OBSOLETE.
Date: Sun, 18 Feb 2007 19:35:07 +0100
User-Agent: KMail/1.9.5
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       "Robert P. J. Day" <rpjday@mindspring.com>
References: <Pine.LNX.4.64.0702181203360.5131@CPE00045a9c397f-CM001225dbafb6>
In-Reply-To: <Pine.LNX.4.64.0702181203360.5131@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702181935.07454.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Would it be possible to get this patch merged
(or at least DEPRECATED part of it)?

I think that the patch is useful and that the distinction between
DEPRECATED and OBSOLETE options is quite clear:

* DEPRECATED == new better code is available, old code scheduled for removal

* OBSOLETE == no replacement yet but the code is broken by design
  and unreliable, not scheduled for removal yet (BTW Robert, I think
  CONFIG_OBSOLETE should also be "default y", at least initially)

I would like to start using CONFIG_DEPRECATED and CONFIG_OBSOLETE
for some IDE config config options/features (not drivers) in the future.

Thanks,
Bart

On Sunday 18 February 2007 18:06, Robert P. J. Day wrote:
> 
>   Add two new maturity levels of DEPRECATED and OBSOLETE to the kbuild
> structure.
> 
> Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
> 
> ---
> 
>   one more time, i'll see if i can get this into the main tree, since
> previous attempts just seem to disappear into the void, even though
> several people seemed to think it was a good idea.
> 
> diff --git a/init/Kconfig b/init/Kconfig
> index a3f83e2..acc0052 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -29,9 +29,10 @@ config EXPERIMENTAL
>  	  <file:Documentation/BUG-HUNTING>, and
>  	  <file:Documentation/oops-tracing.txt> in the kernel source).
> 
> -	  This option will also make obsoleted drivers available. These are
> -	  drivers that have been replaced by something else, and/or are
> -	  scheduled to be removed in a future kernel release.
> +	  At the moment, this option also makes obsolete drivers available,
> +	  but such drivers really should be removed from the EXPERIMENTAL
> +	  category and added to either DEPRECATED or OBSOLETE, depending
> +	  on their status.
> 
>  	  Unless you intend to help test and develop a feature or driver that
>  	  falls into this category, or you have a situation that requires
> @@ -40,6 +41,29 @@ config EXPERIMENTAL
>  	  you say Y here, you will be offered the choice of using features or
>  	  drivers that are currently considered to be in the alpha-test phase.
> 
> +config DEPRECATED
> +	bool "Prompt for deprecated code/drivers"
> +	default y
> +	---help---
> +	  Code that is tagged as "deprecated" is officially still available
> +	  for use but will typically have already been scheduled for removal
> +	  at some point, so it's in your best interests to start looking for
> +	  an alternative.
> +
> +	  Check the file Documentation/feature-removal-schedule.txt to see
> +	  if a particular feature has an official scheduled removal date.
> +
> +config OBSOLETE
> +	bool "Prompt for obsolete code/drivers"
> +	default n
> +	---help---
> +	  Code that is tagged as "obsolete" is officially no longer supported
> +	  and shouldn't play a part in any normal build, but those features
> +	  might still be available if you absolutely need access to them.
> +
> +	  You are *strongly* discouraged from continuing to depend on
> +	  obsolete code on an ongoing, long-term basis.
> +
>  config BROKEN
>  	bool
