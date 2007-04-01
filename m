Return-Path: <linux-kernel-owner+w=401wt.eu-S933504AbXDAPnK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933504AbXDAPnK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 11:43:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933473AbXDAPnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 11:43:10 -0400
Received: from raven.upol.cz ([158.194.120.4]:43480 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933471AbXDAPnJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 11:43:09 -0400
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       stable@kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Jan Beulich <jbeulich@novell.com>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] kbuild: fix dependency generation
In-Reply-To: <20070401104551.GA7560@uranus.ravnborg.org>
References: <20070401104551.GA7560@uranus.ravnborg.org>
Date: Sun, 1 Apr 2007 17:51:05 +0200
Message-Id: <E1HY2Kf-0002QC-O3@flower>
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Sam Ravnborg
> Newsgroups: gmane.linux.kernel
> Subject: [PATCH] kbuild: fix dependency generation
> Date: Sun, 1 Apr 2007 12:45:51 +0200
>
[]
>  scripts/basic/fixdep.c |   10 +++++++---
>  1 files changed, 7 insertions(+), 3 deletions(-)
>
> diff --git a/scripts/basic/fixdep.c b/scripts/basic/fixdep.c
> index 668a11a..24144a2 100644
> --- a/scripts/basic/fixdep.c
> +++ b/scripts/basic/fixdep.c
> @@ -28,9 +28,11 @@
>   * the dependency on linux/autoconf.h by a dependency on every config
>   * option which is mentioned in any of the listed prequisites.
>   *
> - * To be exact, split-include populates a tree in include/config/,
> - * e.g. include/config/his/driver.h, which contains the #define/#undef
> - * for the CONFIG_HIS_DRIVER option.
> + * kconfig populates a tree in include/config/ with an empty file
> + * for each config symbol and when the configuration is updated
> + * the files representing changed config options are touched
> + * which thern let make pick up the changes and the files that uses
            ^ then?                                               ^ use?
> + * the config symbols are rebuild.
                             ^ rebuilt?

Just in case that's wrong (IANALang, of course :)

>   *
>   * So if the user changes his CONFIG_HIS_DRIVER option, only the objects
>   * which depend on "include/linux/config/his/driver.h" will be rebuilt,
> @@ -245,6 +247,8 @@ void parse_config_file(char *map, size_t len)
>  		continue;
>  
>  	found:
> +		if (!memcmp(q - 7, "_MODULE", 7))
> +			q -= 7;
>  		use_config(p+7, q-p-7);
>  	}
>  }
> -- 
> 1.5.1.rc3.20.gaa453
>
____
