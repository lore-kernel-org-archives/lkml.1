Return-Path: <linux-kernel-owner+w=401wt.eu-S1755033AbYICGp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755033AbYICGp4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 02:45:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751695AbYICGpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 02:45:46 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:56092 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751926AbYICGpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 02:45:45 -0400
Date: Wed, 3 Sep 2008 09:44:18 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for September 1 (recordmcount.pl)
Message-ID: <20080903064416.GC4104@cs181140183.pp.htv.fi>
References: <20080901191946.4c35ffc9.sfr@canb.auug.org.au> <20080901112549.9849ab39.randy.dunlap@oracle.com> <20080902232639.255efb4f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080902232639.255efb4f.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2008 at 11:26:39PM -0700, Andrew Morton wrote:
> On Mon, 1 Sep 2008 11:25:49 -0700 Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
> > On Mon, 1 Sep 2008 19:19:46 +1000 Stephen Rothwell wrote:
> > 
> > > Hi all,
> > > 
> > > Changes since next-20080829:
> > 
> > When using patch tarballs and applying that to kernel bases,
> > scripts/recordmcount.pl fails because it is not executable.
> > (Yes, I know, using the git would/should fix this.)
> > 
> > Is there any way to make (new) scripts executable when using
> > tarballs?
> > 
> > I'll handle it on a case-by-case basis for now.
> > 
> 
> I did this:
> 
> From: Andrew Morton <akpm@linux-foundation.org>
> 
>   CHK     include/linux/version.h
>   CHK     include/linux/utsrelease.h
>   CC      scripts/mod/empty.o
> /bin/sh: /usr/src/25/scripts/recordmcount.pl: Permission denied
> 
> We shouldn't assume that files have their `x' bits set.  There are various
> ways in which file permissions get lost, including use of patch(1).
> 
> It might not be correct to assume that perl lives in $PATH?


scripts/recordmcount.pl starts with "#!/usr/bin/perl -w", which is an 
even stronger assumption.


> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  scripts/Makefile.build |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff -puN scripts/Makefile.build~kbuild-ftrace-dont-assume-that-scripts-recordmcountpl-is-executable scripts/Makefile.build
> --- a/scripts/Makefile.build~kbuild-ftrace-dont-assume-that-scripts-recordmcountpl-is-executable
> +++ a/scripts/Makefile.build
> @@ -199,8 +199,9 @@ cmd_modversions =							\
>  endif
>  
>  ifdef CONFIG_FTRACE_MCOUNT_RECORD
> -cmd_record_mcount = $(srctree)/scripts/recordmcount.pl "$(ARCH)" \
> -	"$(OBJDUMP)" "$(OBJCOPY)" "$(CC)" "$(LD)" "$(NM)" "$(RM)" "$(MV)" "$(@)";
> +cmd_record_mcount = perl $(srctree)/scripts/recordmcount.pl \
> +	"$(ARCH)" "$(OBJDUMP)" "$(OBJCOPY)" "$(CC)" "$(LD)" "$(NM)" "$(RM)" \
> +	"$(MV)" "$(@)";
>  endif
>  
>  define rule_cc_o_c
> _
> 
> 
> but I haven't been able to interest anyone in the patch yet.


cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

