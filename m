Return-Path: <linux-kernel-owner+w=401wt.eu-S1763505AbXFEHXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763505AbXFEHXQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 03:23:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761418AbXFEHXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 03:23:06 -0400
Received: from raven.upol.cz ([158.194.120.4]:53959 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760838AbXFEHXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 03:23:04 -0400
Date: Tue, 5 Jun 2007 09:33:35 +0200
To: Sam Ravnborg <sam@ravnborg.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       kbuild-devel@lists.sourceforge.net
Subject: Re: [kbuild-devel] [PATCH 08/19] scripts: Make cleanfile/cleanpatch warn about long lines
Message-ID: <20070605073335.GM7266@flower.upol.cz>
References: <20070603204700.GH9240@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070603204700.GH9240@uranus.ravnborg.org>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hallo.

On Sun, Jun 03, 2007 at 10:47:00PM +0200, Sam Ravnborg wrote:
> Subject: [PATCH 08/19] scripts: Make cleanfile/cleanpatch warn about long lines
> From: H. Peter Anvin <hpa@zytor.com>
> Date: Fri, 25 May 2007 17:58:26 -0700
> 
> Make the "cleanfile" and "cleanpatch" script warn about long lines,
> by default lines whose visual width exceeds 79 characters.
> 
> Per suggestion from Auke Kok.
> 
> Signed-off-by: H. Peter Anvin <hpa@zytor.com>
> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>

Thank you, Sam, for sending messages back in Kbuild list again.
I have ~30k backlog in LKML, so that thing is good.

So, there are some new scripts. What if my proposition will be better,
so to speak? Any problems i'm willing to fix/enhance.

Note: only one copy of the file required. Sym-linked name *diff* or
*patch* will process patches. I know, that symlinks in sources isn't
good, thus change "$0" -> "$1" will process first parameter.

-*- shell-script: clean-whitespace.sh -*-

#!/bin/sh -e
# stdin/stdout

case $0 in *diff* | *patch*) p='+';; esac
t="`printf '\t'`" ; w79=79 ; IFS=''

while read line
do case "$line" in
   ++*) echo "$line";;
   $p*) line="`echo \"$line\" | expand`"
	[ ${#line} -gt $w79 ] && : ${long:=line}
	echo "$line" | sed -e "/^$p/{s_        _${t}_g;s_^$p *_${p}_;s_ *\$__}"
	;;
     *) echo "$line";;
   esac
done
[ -n "$long" ] && echo "at least one line, wider than $w79 chars, found" 1>&2

-*-
> ---
>  scripts/cleanfile  |   54 ++++++++++++++++++++++++++++++++++++++++++++++-
>  scripts/cleanpatch |   58 +++++++++++++++++++++++++++++++++++++++++++++++++--
>  2 files changed, 107 insertions(+), 5 deletions(-)
>  bla-bla...
____
