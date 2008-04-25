Return-Path: <linux-kernel-owner+w=401wt.eu-S1760860AbYDYNSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760860AbYDYNSz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 09:18:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755574AbYDYNSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 09:18:48 -0400
Received: from el-out-1112.google.com ([209.85.162.177]:56733 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754969AbYDYNSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 09:18:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=H4pglnz4s68RHLwgDUjW4XpkCuKBy17q/267SZQYSOpWImeLOFrk2q//NlcJ8FEnvo3b4AdkGW7vG0o3Ai0EnAzQ++GoZuq134VEkP8u3zP6HxJ88JTQxPLQhWE7BzSQOD3FvwrCfuBx9zrm4W/A8oQje87Q06/XonXcE/fSabA=
Message-ID: <cfd18e0f0804250618ic6dfd09gf68573256be3ff@mail.gmail.com>
Date: Fri, 25 Apr 2008 15:18:46 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: "Neil Horman" <nhorman@tuxdriver.com>
Subject: Re: core_pattern pipe documentation
Cc: "Andi Kleen" <andi@firstfloor.org>, linux-man@vger.kernel.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Petr Gajdos" <pgajdos@suse.cz>, michael.kerrisk@gmail.com
In-Reply-To: <20080423145933.GA26228@hmsendeavour.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <cfd18e0f0804151409q178addf4t4c6cba683bd0bff4@mail.gmail.com>
	 <cfd18e0f0804151411x62080f10y833493db7f1b8cfd@mail.gmail.com>
	 <48051FBA.60503@firstfloor.org> <4808D1F4.7050705@gmail.com>
	 <cfd18e0f0804230509g4e7456ecgd40c0bfee874a82c@mail.gmail.com>
	 <20080423145933.GA26228@hmsendeavour.rdu.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Neil,

On Wed, Apr 23, 2008 at 4:59 PM, Neil Horman <nhorman@tuxdriver.com> wrote:
>
> On Wed, Apr 23, 2008 at 02:09:14PM +0200, Michael Kerrisk wrote:
> > Andi -- ping!
> >
> > Adding Neil to CC, since it looks like he also did some work here, and
> > so can perhaps comment.
> >
> > On Fri, Apr 18, 2008 at 6:53 PM, Michael Kerrisk
> > <mtk.manpages@googlemail.com> wrote:
> > > Andi,
> > >
> > > I wrote the following description of the core_pattern pipe feature.  Does this
> > > seem okay?
> > >
> > >   Piping core dumps to a program
> > >       Since kernel 2.6.19, Linux supports an  alternate  syntax
> > >       for the /proc/sys/kernel/core_pattern file.  If the first
> > >       character of this file is a pipe  symbol  (|),  then  the
> > >       remainder  of  the line is interpreted as a program to be
> > >       executed.  Instead of being written to a disk  file,  the
> > >       core  dump  is  given  as  standard input to the program.
> > >       Note the following points:
> > >
> > >       *  The program must be specified using an absolute  path-
> > >          name  (or  a  pathname relative to the root directory,
> > >          /), and must immediately follow the '|' character.
> > >
> > >       *  The process created to run the program  runs  as  user
> > >          and group root.
> > >
> > >       *  Arguments can be supplied to the program, delimited by
> > >          white space (up to a total line length of 128  bytes).
> > >
> > > Cheers,
> > >
> > > Michael
> > >
> Thanks for CC'ing me.  The above all looks good.  I would add documentation
> however, about the available macros that can be used when core_pattern is
> specified as a pipe.  Adding something like the following would be good:
>
>        * Arguments can be statically declared or implied via the use of macros,
>          denoted by the use of the %sign.  The following macros are supported:
>                * %% - output a literal % sign on the command line
>                * %p - the pid of the crashing process
>                * %u - the uid of the crashing process
>                * %g - the gid of the crashing process
>                * %s - the signal that caused the crashing process to crash
>                * %t - the time the crashing process dumped
>                * %h - the hostname of the system
>                * %e - the executable name of the crashing process
>                * %c - the core limit size of the crashing process

Thanks for pointing that out!  I'll note it in the page.

>          Note that the core limit size macro may be a different value than what
>          is returned by getrlimit(RLIMIT_CORE,...).  This is due to the fact
>          that the core_pattern specified executible will be run as the same uid
>          as the crashing process, and to facilitate reception of the entire
>          core, the kernel will temporarily set RLIMIT_CORE to unlimited while
>          the dump is in progress.

Actually, I can't seem to get an example of this behavior.  In my
experiments, %c always seems to give the "right" info (i.e., I don't
ever see %c showing 2^32 (unlimited) when I set a soft limit).  Can
you show a specific case where it doesn't give the "right" value?

>          Note also %u and %g may be different values
>          than getuid/getgid in the event that the core_pattern executable is
>          set[u|g]id root

I'm slightly confused by that last point.  According to my
experiments, the core_pattern executable is always run as user and
group root, so making it set[ug]id root would seem to be a no-op.
(But anyway, %u and %g do give the "right" values -- the UID and GID
of the dumping process.)

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
