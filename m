Return-Path: <linux-kernel-owner+w=401wt.eu-S933326AbXBGMyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933326AbXBGMyb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 07:54:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933328AbXBGMya
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 07:54:30 -0500
Received: from raven.upol.cz ([158.194.120.4]:58043 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933326AbXBGMya (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 07:54:30 -0500
Date: Wed, 7 Feb 2007 14:02:27 +0100
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roman Zippel <zippel@linux-m68k.org>, Sam Ravnborg <sam@ravnborg.org>,
       William Stearns <wstearns@pobox.com>,
       Martin Schlemmer <azarah@nosferatu.za.org>
Subject: Re: [patch 1/3, resend] scripts: replace gawk, head, bc with shell, update
Message-ID: <20070207130227.GD1160@flower.upol.cz>
References: <20070206011819.160359000@flower.upol.cz> <20070206012207.805083000@flower.upol.cz> <9a8748490702070058rab5a9d6vd57cf49b722e4850@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a8748490702070058rab5a9d6vd57cf49b722e4850@mail.gmail.com>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 07, 2007 at 09:58:12AM +0100, Jesper Juhl wrote:
> On 06/02/07, Oleg Verych <olecom@flower.upol.cz> wrote:
> >scripts: replace gawk, head, bc with shell, update
> >
> >  Replacing overhead of using some (external) programs
> >  instead of good old `sh'.
> >
> >Cc: Roman Zippel <zippel@linux-m68k.org>
> >Cc: Sam Ravnborg <sam@ravnborg.org>
> >Cc: William Stearns <wstearns@pobox.com>
> >Cc: Martin Schlemmer <azarah@nosferatu.za.org>
> >Signed-off-by: Oleg Verych <olecom@flower.upol.cz>
> >---
> >
> > Whitespace cleanup included.
> >
> > scripts/gen_initramfs_list.sh | 43 
> > +++++++++++++++++++++---------------------
> > scripts/makelst               | 34 ++++++++++++++++-----------------
> > 2 files changed, 39 insertions(+), 38 deletions(-)
> >
> >Index: linux-2.6.20/scripts/makelst
> >===================================================================
> >--- linux-2.6.20.orig/scripts/makelst   2007-02-06 02:12:38.811908000 +0100
> >+++ linux-2.6.20/scripts/makelst        2007-02-06 02:12:43.688212750 +0100
> >@@ -1,31 +1,31 @@
> >-#!/bin/bash
> >+#!/bin/sh
> 
> I don't like this change much.  We don't know what shell /bin/sh is on
> a random users system - much better to be explicit and make sure we
> use/require bash.
> I expect this change to cause pain for users who have zsh, csh, ksh,
> ash or some other shell as /bin/sh but also have /bin/bash available.
> Previously things would just work, but now it will possibly break due
> to using a different shell.


I've tested on dash, that is `sh'. Everybody is welcome to test on his
favorite `/bin/sh' compatible shell.

It's very unclear from bash man page, where are extentions, and where are
common features. That particular script is small and non-bash oriented,
unlike gen_initramfs_list.sh [s/sh/bash].

Thus it's OK, even in scope of SUSv3 "incompatible" "%ul" in `printf'
(see my other reply on that).

____
