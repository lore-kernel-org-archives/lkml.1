Return-Path: <linux-kernel-owner+w=401wt.eu-S1761284AbXJLVxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761284AbXJLVxT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 17:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758534AbXJLVxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 17:53:10 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:22556 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758181AbXJLVxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 17:53:08 -0400
Message-ID: <470FEBEF.4000204@oracle.com>
Date: Fri, 12 Oct 2007 14:49:35 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: zippel@linux-m68k.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       sam@ravnborg.org
Subject: Re: [PATCH] Allow kconfig to accept overrides
References: <Pine.LNX.4.64.0710122341530.16098@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0710122341530.16098@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> Allow config variables in .config to override earlier ones in the same
> file. In other words,
> 
> 	# CONFIG_SECURITY is not defined
> 	CONFIG_SECURITY=y
> 
> will activate it. This makes it a bit easier to do
> 
> 	(cat original-config myconfig myconfig2 ... >.config)
> 
> and run menuconfig as expected.

This is a feature that we want IMO, but I already do this without having
a patch for it (although to a lesser degree than full config files;
I just cat a few entries to the end of a config file then run oldconfig)...
so are there some cases where it works and some cases
where it doesn't work?  Do you know what those cases are?


> Previously sent:
> 	http://lkml.org/lkml/2006/10/25/81
> 	http://lkml.org/lkml/2007/4/1/175
> 
> Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Cc: Roman Zippel <zippel@linux-m68k.org>
> Cc: Randy Dunlap <randy.dunlap@oracle.com>
> 
> ---
>  scripts/kconfig/confdata.c |   14 +++++---------
>  1 file changed, 5 insertions(+), 9 deletions(-)
> 
> #
> # Applies cleanly to 2.6.22/23/git.
> #
> Index: linux-2.6.22.1/scripts/kconfig/confdata.c
> ===================================================================
> --- linux-2.6.22.1.orig/scripts/kconfig/confdata.c
> +++ linux-2.6.22.1/scripts/kconfig/confdata.c
> @@ -170,8 +170,7 @@ load:
>  					sym->type = S_BOOLEAN;
>  			}
>  			if (sym->flags & def_flags) {
> -				conf_warning("trying to reassign symbol %s", sym->name);
> -				break;
> +				conf_warning("override: reassigning to symbol %s", sym->name);
>  			}
>  			switch (sym->type) {
>  			case S_BOOLEAN:
> @@ -210,8 +209,7 @@ load:
>  					sym->type = S_OTHER;
>  			}
>  			if (sym->flags & def_flags) {
> -				conf_warning("trying to reassign symbol %s", sym->name);
> -				break;
> +				conf_warning("override: reassigning to symbol %s", sym->name);
>  			}
>  			switch (sym->type) {
>  			case S_TRISTATE:
> @@ -288,11 +286,9 @@ load:
>  				}
>  				break;
>  			case yes:
> -				if (cs->def[def].tri != no) {
> -					conf_warning("%s creates inconsistent choice state", sym->name);
> -					cs->flags &= ~def_flags;
> -				} else
> -					cs->def[def].val = sym;
> +				if(cs->def[def].tri != no)
> +					conf_warning("override: %s turns state choice", sym->name);
> +				cs->def[def].val = sym;
>  				break;
>  			}
>  			cs->def[def].tri = E_OR(cs->def[def].tri, sym->def[def].tri);
> 


-- 
~Randy
