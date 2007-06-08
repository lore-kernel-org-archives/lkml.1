Return-Path: <linux-kernel-owner+w=401wt.eu-S936103AbXFHGpm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936103AbXFHGpm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 02:45:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758264AbXFHGpe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 02:45:34 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54053 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757168AbXFHGpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 02:45:33 -0400
Date: Thu, 7 Jun 2007 23:44:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Verych <olecom@flower.upol.cz>
Cc: kbuild-devel@lists.sourceforge.net, "H. Peter Anvin" <hpa@zytor.com>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch] scripts: clean-whitespace.sh
Message-Id: <20070607234459.e4dffd65.akpm@linux-foundation.org>
In-Reply-To: <E1HwY9K-0008Jz-CG@flower>
References: <20070605073335.GM7266@flower.upol.cz>
	<20070605081959.GB21991@uranus.ravnborg.org>
	<20070605133834.GO7266@flower.upol.cz>
	<20070605141254.GA24722@uranus.ravnborg.org>
	<20070605145759.GP7266@flower.upol.cz>
	<20070605151101.GQ7266@flower.upol.cz>
	<20070606174556.GS7266@flower.upol.cz>
	<20070606175026.GA6303@uranus.ravnborg.org>
	<20070606191426.GT7266@flower.upol.cz>
	<Pine.LNX.4.64.0706071634470.8762@fbirervta.pbzchgretzou.qr>
	<20070607230657.GV7266@flower.upol.cz>
	<4668929C.7040209@zytor.com>
	<E1HwY9K-0008Jz-CG@flower>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Jun 2007 08:40:42 +0200 Oleg Verych <olecom@flower.upol.cz> wrote:

> After running this script with filename as parameter,
> look (with diff) for, what can be corrected.

Sorry, but "run it and see what it did" is pretty poor documentation.

> Only "*.diff" and "*.patch" files are handled as patches.
> 
> Signed-off-by: Oleg Verych <olecom@flower.upol.cz>
> --
>  Two clean rules added, that can change look of damaged lines.
>  Yet script still fits one ordinary screen, so read the code!
> 
>  test cases: include/linux/ipv6.h, arch/x86_64/lib/{copy_user, memcpy}.S
> 
>  It's like lguest -- just for fun.
> 
>  clean-whitespace.sh |   28 ++++++++++++++++++++++++++++
>   1 file changed, 28 insertions(+)
> 
> --- /dev/null	2007-04-04 10:55:19.204075250 +0200
> +++ linux-just-for-fun/scripts/clean-whitespace.sh	2007-06-08 07:53:21.000000000 +0200
> @@ -0,0 +1,28 @@
> +#!/bin/sh -e
> +# clean whitespace damage; i/o = $1/$1.clean
> +
> +IFS='' ; t="`printf '\t'`" ; s=' ' ; s4="$s$s$s$s" ; w79=79 ;
> +i="$1" ; o="$1.clean"
> +strip_file_end='/^$/{N;s_^\n$_&_;T e;:n;N;s_^.*\n\n$_&_;t n;:e;};'
> +not_patch_line='/^+[^+]/'
> +
> +case $1 in *[.]diff | *[.]patch)
> +	file=patch ; sp='+[!+]' ; p='+' ; addr="$not_patch_line";;
> +esac
> +
> +sed -n "${addr:-$strip_file_end} {
> +s|[$t$s]*$||;	# trailing whitespace
> +:next;		# x*8 spaces on the line start -> x*tabs
> +s|^\([\n]*\)$p\($t*\)$s4$s4|\1$p\2$t|;t next;	# \n is needed after N command
> +s|^\([\n]*\)$p\($t*\)$s*$t|\1$p\2$t|g;		# strip spaces between tabs
> +s|$s4$s4$s$s*|$t$t|g				# more than 8 spaces -> 2 tabs
> +s|$s*$t|$t|g	# strip spaces before tab; tradeoff: may break some alignment !
> +};p" -- "$i" >"$o" && echo "
> +please, see clean ${file:=source} file: $o
> +"
> +exec expand $i | while read -r line # check for long line
> +do   [ ${#line} -gt $w79 ] && case "$line" in $sp*) echo \
> +"at least one line wider than $w79 chars, found
> +check your $file, please
> +" 1>&2 ; exit ;; esac
> +done

Then again, it's a better strategy than trying to read the code ;)

Please, tell us what it does, so that we can decide whether we want it in
Linux.

