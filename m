Return-Path: <linux-kernel-owner+w=401wt.eu-S964798AbXBAC3K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964798AbXBAC3K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 21:29:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933352AbXBAC3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 21:29:10 -0500
Received: from raven.upol.cz ([158.194.120.4]:65327 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933340AbXBAC3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 21:29:09 -0500
Date: Thu, 1 Feb 2007 03:37:17 +0100
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Roman Zippel <zippel@linux-m68k.org>,
       Bastian Blank <bastian@waldi.eu.org>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [patch] kbuild: correctly skip tilded backups in localversion files
Message-ID: <20070201023717.GA22328@flower.upol.cz>
References: <20070131071103.GA3295@flower.upol.cz> <20070131155651.529e933c.akpm@osdl.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070131155651.529e933c.akpm@osdl.org>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 31, 2007 at 03:56:51PM -0800, Andrew Morton wrote:
> On Wed, 31 Jan 2007 07:11:04 +0000
> Oleg Verych <olecom@flower.upol.cz> wrote:
> 
> > kbuild: correctly skip tilded backups in localversion files
> 
> Does this patch replace Bastian's patch, below?

Along with "Message-ID: <20070131093542.GA3471@flower.upol.cz>" -- yes.

Note, that they also make a little bit of cleanup to top makefile's mess,
And, i think, have more elegant, portable, clean solution.

Roman commented on another my patch, saying, that tilde in the end isn't
the only way to name backups. Filename, containing '~' is a backup in the
sources, thus i'm proposing new patch.

Unfortunately still no more comments from anybody. Roman joined, but
seems busy now, to comment on such minor stuff.

Anyway, thanks.


> From: Bastian Blank <bastian@waldi.eu.org>
> 
> Fix the problem that localversion files were ignored if the tree lives in
> a path which contains a ~.  It changes the test to apply to the filename
> only.
> 
> Debian allows versions which contains ~ in it.  The upstream part of the
> version is in the directory name of the build tree and we got weird results
> because the localversion files was just got ignored in this case.
> 
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Cc: Roman Zippel <zippel@linux-m68k.org>
> Signed-off-by: Andrew Morton <akpm@osdl.org>
> ---
> 
>  Makefile |    2 +-
>  1 files changed, 1 insertion(+), 1 deletion(-)
> 
> diff -puN Makefile~kbuild-dont-ignore-localversion-files-if-the-path-includes-a Makefile
> --- a/Makefile~kbuild-dont-ignore-localversion-files-if-the-path-includes-a
> +++ a/Makefile
> @@ -793,7 +793,7 @@ space      := $(nullstring) # end of lin
>  ___localver = $(objtree)/localversion* $(srctree)/localversion*
>  __localver  = $(sort $(wildcard $(___localver)))
>  # skip backup files (containing '~')
> -_localver = $(foreach f, $(__localver), $(if $(findstring ~, $(f)),,$(f)))
> +_localver = $(foreach f, $(__localver), $(if $(findstring ~, $(notdir $(f))),,$(f)))
>  
>  localver = $(subst $(space),, \
>  	   $(shell cat /dev/null $(_localver)) \
> _
> 
