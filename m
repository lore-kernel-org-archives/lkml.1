Return-Path: <linux-kernel-owner+w=401wt.eu-S1754619AbZGWV2L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619AbZGWV2L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 17:28:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754558AbZGWV2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 17:28:11 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:35615 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753841AbZGWV2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 17:28:09 -0400
Date: Thu, 23 Jul 2009 23:28:09 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Frans Pop <elendil@planet.nl>
Cc: linux-ia64@vger.kernel.org, linux-kbuild@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ia64: minor Makefile simplification through use of
	cc-ifversion
Message-ID: <20090723212809.GB9488@merkur.ravnborg.org>
References: <200907232056.51064.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907232056.51064.elendil@planet.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 23, 2009 at 08:56:50PM +0200, Frans Pop wrote:
> Signed-off-by: Frans Pop <elendil@planet.nl>
> ---
> 
> Change was suggested by Sam Ravnborg; see http://lkml.org/lkml/2009/7/18/15.
> Untested.
> 
> diff --git a/arch/ia64/Makefile b/arch/ia64/Makefile
> index 58a7e46..2bf6107 100644
> --- a/arch/ia64/Makefile
> +++ b/arch/ia64/Makefile
> @@ -41,10 +41,8 @@ $(error Sorry, you need a newer version of the assember, one that is built from
>  		ftp://ftp.hpl.hp.com/pub/linux-ia64/gas-030124.tar.gz)
>  endif
>  
> -ifeq ($(call cc-version),0304)
> -	cflags-$(CONFIG_ITANIUM)	+= -mtune=merced
> -	cflags-$(CONFIG_MCKINLEY)	+= -mtune=mckinley
> -endif
> +cflags-$(CONFIG_ITANIUM)  += $(call cc-ifversion, -eq, 0304, -mtune=merced)
> +cflags-$(CONFIG_MCKINLEY) += $(call cc-ifversion, -eq, 0304, -mtune=mckinley)

The above change is correct.
But I really wonder if the original code was correct?
Do we really only want to use the -mtune options for this specific gcc version?
If this is indeed the case this deserves a comment explaning this.

So the patch has my:

Acked-by: Sam Ravnborg <sam@ravnborg.org>

But the code that this patch highligt (but does not chage) looks questionable.

	Sam
