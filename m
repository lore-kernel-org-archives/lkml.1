Return-Path: <linux-kernel-owner+w=401wt.eu-S1761065AbXJLXR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761065AbXJLXR6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 19:17:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933308AbXJLW6x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 18:58:53 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:22412 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933310AbXJLW6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 18:58:51 -0400
Date: Fri, 12 Oct 2007 15:57:08 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: zippel@linux-m68k.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       sam@ravnborg.org
Subject: Re: [PATCH] Allow kconfig to accept overrides
Message-Id: <20071012155708.d8abd06d.randy.dunlap@oracle.com>
In-Reply-To: <Pine.LNX.4.64.0710122341530.16098@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0710122341530.16098@fbirervta.pbzchgretzou.qr>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Oct 2007 23:44:08 +0200 (CEST) Jan Engelhardt wrote:

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
> 
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

				if (
> +					conf_warning("override: %s turns state choice", sym->name);

What does that warning message mean?  I can't decipher it.

Other than that, it works for me.  Thanks.

> +				cs->def[def].val = sym;
>  				break;
>  			}
>  			cs->def[def].tri = E_OR(cs->def[def].tri, sym->def[def].tri);


---
~Randy
