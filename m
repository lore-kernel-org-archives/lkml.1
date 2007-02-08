Return-Path: <linux-kernel-owner+w=401wt.eu-S933337AbXBHAWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933337AbXBHAWk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 19:22:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933328AbXBHAWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 19:22:39 -0500
Received: from raven.upol.cz ([158.194.120.4]:33655 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933337AbXBHAWi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 19:22:38 -0500
Date: Thu, 8 Feb 2007 01:31:27 +0100
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] refix localversion handling
Message-ID: <20070208003127.GD22699@flower.upol.cz>
References: <Pine.LNX.4.64.0702080109550.14457@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702080109550.14457@scrub.home>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 08, 2007 at 01:13:39AM +0100, Roman Zippel wrote:
> Hi,
> 
> This reverts part of the localversion patch, which now already got into 
> git. It removes the unnecessary find call, with the simpler $(notdir ...) 
> fix.

I'm certainly have more stuff to deal with, but that was my attept to
prevent bloatware in makefiles (unlucky "meat" from "flies" split ;)

>  
> -pattern = ".*/localversion[^~]*"
> -string  = $(shell cat /dev/null \
> -	   `find $(objtree) $(srctree) -maxdepth 1 -regex $(pattern) | sort`)
> -
> -localver = $(subst $(space),, $(string) \
> -			      $(patsubst "%",%,$(CONFIG_LOCALVERSION)))
> +___localver = $(objtree)/localversion* $(srctree)/localversion*
> +__localver  = $(sort $(wildcard $(___localver)))
> +# skip files containing '~' (like backup files)
> +_localver = $(foreach f,$(__localver),$(if $(findstring ~,$(notdir $(f))),,$(f)))
> +
> +localver = $(subst $(space),, \
> +	   $(shell cat /dev/null $(_localver)) \
> +	   $(patsubst "%",%,$(CONFIG_LOCALVERSION)))
____
