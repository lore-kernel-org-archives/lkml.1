Return-Path: <linux-kernel-owner+w=401wt.eu-S1760632AbXEJAKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760632AbXEJAKX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 20:10:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759596AbXEJAKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 20:10:07 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51844 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757417AbXEJAKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 20:10:04 -0400
Date: Wed, 9 May 2007 17:09:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Florian Fainelli <florian.fainelli@int-evry.fr>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] time locale in gen_initramfs_list.sh
Message-Id: <20070509170926.27fad8bb.akpm@linux-foundation.org>
In-Reply-To: <200705080755.31157.florian.fainelli@int-evry.fr>
References: <200705080755.31157.florian.fainelli@int-evry.fr>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2007 07:55:26 +0200
Florian Fainelli <florian.fainelli@int-evry.fr> wrote:

> I noticed that some zsh users who forced their ls formatting to something non 
> standard could not generate the initramfs file list. Forcing the locale to C 
> while generating seems not to be enough. Adding --time-style=locale will use 
> C locale ls output and will let them generate the initramfs list. It has no 
> side effects for other users.
> 
> Signed-off-by: Florian Fainelli <florian.fainelli@int-evry.fr>
> --
> 
> 
> [time_locale.patch  text/plain (761B)]
> diff --git a/scripts/gen_initramfs_list.sh b/scripts/gen_initramfs_list.sh
> index 683eb12..1f96b9b 100644
> --- a/scripts/gen_initramfs_list.sh
> +++ b/scripts/gen_initramfs_list.sh
> @@ -125,7 +125,7 @@ parse() {
>  			str="${ftype} ${name} ${location} ${str}"
>  			;;
>  		"nod")
> -			local dev=`LC_ALL=C ls -l "${location}"`
> +			local dev=`LC_ALL=C ls --time-style=locale -l "${location}"`
>  			local maj=`field 5 ${dev}`
>  			local min=`field 6 ${dev}`
>  			maj=${maj%,}
> @@ -135,7 +135,7 @@ parse() {
>  			str="${ftype} ${name} ${str} ${dev} ${maj} ${min}"
>  			;;
>  		"slink")
> -			local target=`field 11 $(LC_ALL=C ls -l "${location}")`
> +			local target=`field 11 $(LC_ALL=C ls --time-style=locale -l "${location}")`
>  			str="${ftype} ${name} ${target} ${str}"
>  			;;

hm, --time-style sounds rather gnu-specific and perhaps we'd rather not
add that requirement.  Or perhaps we already require gnu ls, dunno.

I'll dump the problem in Sam's lap ;)
