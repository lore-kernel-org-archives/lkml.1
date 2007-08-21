Return-Path: <linux-kernel-owner+w=401wt.eu-S1762585AbXHUPaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762585AbXHUPaA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 11:30:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760589AbXHUP3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 11:29:49 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:1233 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761645AbXHUP3q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 11:29:46 -0400
Date: Tue, 21 Aug 2007 17:29:36 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Andres Salomon <dilinger@queued.net>
cc: kbuild-devel@lists.sourceforge.net, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kconfig: add *_silentdefconfig feature for config targets
In-Reply-To: <20070820204020.7cde776e.dilinger@queued.net>
Message-ID: <Pine.LNX.4.64.0708211717180.1817@scrub.home>
References: <20070820204020.7cde776e.dilinger@queued.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 20 Aug 2007, Andres Salomon wrote:

> AFAICT, there is nothing similar when using *_defconfig; one must copy
> a .config manually, and then run silentoldconfig.  Simply running the
> associated _defconfig will quietly update the config (which may silently
> drop config options).  This patch adds a *_silentdefconfig target, with
> semantics similar to silentoldconfig.  It will take the defconfig from
> arch/$(ARCH)/configs/$x_defconfig, check for changes, and if there are
> none, write out a .config.  If there have been changes and stdin is
> valid, it will prompt for updates.  If there have been changes and
> stdin is not valid, it will bail out with an error.

I would really like to avoid another input mode.
I think it be better to implement this as a combination of "-s -D 
<default>" and the silent mode is adjusted to read another config instead 
of .config if defconfig_file is set.

> A few things to note:
>   - Using getopt() in scripts/kconfig/conf.c would likely simplify things,
>     but that's a much larger patch.  Is there a reason we don't use it?

Not really.

>   - To make it truly silent, I had to change conf_write() to accept an
>     additional arg.  The alternative is to not have conf_write spit out
>     any information when it writes a file.  Personally, I don't see the need
>     for it to spit out information, but I figured I'd take the more cautious
>     route.  If folks don't care, I can update this patch to remove it.

I rather want to keep this print. The .config is already only written, 
when it has to be in this mode and then I also want to be notified about 
it.

>   - We seem to switch between using _() and not using it for strings; I'm
>     assuming that we don't actually care about i18n in conf.c, and that the
>     _() stuff was just copied from elsewhere.  If that's not the case, I
>     can update the patch to wrap strings properly.

I try to keep this uptodate, but I don't really check for this.

bye, Roman
