Return-Path: <linux-kernel-owner+w=401wt.eu-S1759923AbYBYV4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759923AbYBYV4Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 16:56:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756739AbYBYV4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 16:56:12 -0500
Received: from wilson.telenet-ops.be ([195.130.132.42]:33547 "EHLO
	wilson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756600AbYBYV4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 16:56:10 -0500
Date: Mon, 25 Feb 2008 22:56:04 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: linux-next: Tree for Feb 24
In-Reply-To: <20080224162309.3e67dd22.sfr@canb.auug.org.au>
Message-ID: <Pine.LNX.4.64.0802252252070.5158@anakin>
References: <20080224162309.3e67dd22.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Feb 2008, Stephen Rothwell wrote:
> I have created today's linux-next tree at
> git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git.
> 
> You can see which trees have been included by looking in the Next/Trees
> file in the source.  There are also quilt-import.log and merge.log files
> in the Next directory.  Between each merge, the tree was built with
> allmodconfig for both powerpc and x86_64.
> 
> There only one minor merge problem and a few build failures (the two in
> Linus' tree have been fixed and the other reported).
> 
> We are up to 32 trees, more are welcome (even if they are currently
> empty).

Can you please add
http://linux-m68k-cvs.ubb.ca/~geert/linux-m68k-patches-2.6/series?
So far there's only one patch in between NEXT_PATCHES_{START,END} yet,
though.

> Status of my local build tests is at
> http://kisskb.ellerman.id.au/kisskb/branch/9/.

Ah, I see the m68k cross-compiler is still missing? ;-)

Gr{oetje,eeting}s,

						Geert

P.S. For the interested, a script to update the SHA1 in the quilt series file:

anakin$ cat $(type -p quilt-update-git-base)
#!/bin/bash
series=patches/series

if [ ! -f $series ]; then
    echo Cannot find $series
    exit 1
fi

if head=$(git rev-parse --verify HEAD); then
    if grep '^# BASE' $series > /dev/null; then
	sed -i -e "s/^# BASE.*$/# BASE $head/" $series
	echo Updated BASE to $head
    else
	echo No BASE found
    fi
fi
anakin$ 

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
