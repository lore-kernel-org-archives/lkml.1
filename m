Return-Path: <linux-kernel-owner+w=401wt.eu-S932501AbYDYSNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932501AbYDYSNk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 14:13:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762628AbYDYSNY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 14:13:24 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:31204 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759688AbYDYSNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 14:13:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=oRcwg99GHN1lLX3dDQaaIzFpn/Gh8VGgJW2Xh4cYM5w+o8Lt5ikyIZbaURgPN7BRvXDkReYQAchZcAYtxcA3CsSxVoL2cmCT1Qin+E+YO9mBfc1QyDAV8oXdMaU3lncUF/ipYLv1cqhm7FZ83n95gV4p7vwmus7Gcdv/G3oAHhI=
Message-ID: <cfd18e0f0804251113w4ef2dea3t6727009aa67e6e09@mail.gmail.com>
Date: Fri, 25 Apr 2008 20:13:21 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: "Neil Horman" <nhorman@tuxdriver.com>
Subject: Re: core_pattern pipe documentation
Cc: "Andi Kleen" <andi@firstfloor.org>, linux-man@vger.kernel.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Petr Gajdos" <pgajdos@suse.cz>, michael.kerrisk@gmail.com
In-Reply-To: <20080425162225.GA9833@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <cfd18e0f0804151409q178addf4t4c6cba683bd0bff4@mail.gmail.com>
	 <cfd18e0f0804151411x62080f10y833493db7f1b8cfd@mail.gmail.com>
	 <48051FBA.60503@firstfloor.org> <4808D1F4.7050705@gmail.com>
	 <cfd18e0f0804230509g4e7456ecgd40c0bfee874a82c@mail.gmail.com>
	 <20080423145933.GA26228@hmsendeavour.rdu.redhat.com>
	 <cfd18e0f0804250618ic6dfd09gf68573256be3ff@mail.gmail.com>
	 <20080425162225.GA9833@hmsreliant.think-freely.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2008 at 6:22 PM, Neil Horman <nhorman@tuxdriver.com> wrote:
>
> On Fri, Apr 25, 2008 at 03:18:46PM +0200, Michael Kerrisk wrote:
> > Hi Neil,
> >
> > On Wed, Apr 23, 2008 at 4:59 PM, Neil Horman <nhorman@tuxdriver.com> wrote:
> > >
> > > On Wed, Apr 23, 2008 at 02:09:14PM +0200, Michael Kerrisk wrote:
> > > > Andi -- ping!
> > > >
> > > > Adding Neil to CC, since it looks like he also did some work here, and
> > > > so can perhaps comment.
> > > >
> > > > On Fri, Apr 18, 2008 at 6:53 PM, Michael Kerrisk
> > > > <mtk.manpages@googlemail.com> wrote:
> > > > > Andi,
> > > > >
> > > > > I wrote the following description of the core_pattern pipe feature.  Does this
> > > > > seem okay?
> > > > >
> > > > >   Piping core dumps to a program
> > > > >       Since kernel 2.6.19, Linux supports an  alternate  syntax
> > > > >       for the /proc/sys/kernel/core_pattern file.  If the first
> > > > >       character of this file is a pipe  symbol  (|),  then  the
> > > > >       remainder  of  the line is interpreted as a program to be
> > > > >       executed.  Instead of being written to a disk  file,  the
> > > > >       core  dump  is  given  as  standard input to the program.
> > > > >       Note the following points:
> > > > >
> > > > >       *  The program must be specified using an absolute  path-
> > > > >          name  (or  a  pathname relative to the root directory,
> > > > >          /), and must immediately follow the '|' character.
> > > > >
> > > > >       *  The process created to run the program  runs  as  user
> > > > >          and group root.
> > > > >
> > > > >       *  Arguments can be supplied to the program, delimited by
> > > > >          white space (up to a total line length of 128  bytes).
> > > > >
> > > > > Cheers,
> > > > >
> > > > > Michael
> > > > >
> > > Thanks for CC'ing me.  The above all looks good.  I would add documentation
> > > however, about the available macros that can be used when core_pattern is
> > > specified as a pipe.  Adding something like the following would be good:
> > >
> > >        * Arguments can be statically declared or implied via the use of macros,
> > >          denoted by the use of the %sign.  The following macros are supported:
> > >                * %% - output a literal % sign on the command line
> > >                * %p - the pid of the crashing process
> > >                * %u - the uid of the crashing process
> > >                * %g - the gid of the crashing process
> > >                * %s - the signal that caused the crashing process to crash
> > >                * %t - the time the crashing process dumped
> > >                * %h - the hostname of the system
> > >                * %e - the executable name of the crashing process
> > >                * %c - the core limit size of the crashing process
> >
> > Thanks for pointing that out!  I'll note it in the page.
> >
> > >          Note that the core limit size macro may be a different value than what
> > >          is returned by getrlimit(RLIMIT_CORE,...).  This is due to the fact
> > >          that the core_pattern specified executible will be run as the same uid
> > >          as the crashing process, and to facilitate reception of the entire
> > >          core, the kernel will temporarily set RLIMIT_CORE to unlimited while
> > >          the dump is in progress.
> >
> > Actually, I can't seem to get an example of this behavior.  In my
> > experiments, %c always seems to give the "right" info (i.e., I don't
> > ever see %c showing 2^32 (unlimited) when I set a soft limit).  Can
> > you show a specific case where it doesn't give the "right" value?
> >
> Oops, you're right.  I had initially implemented my core pattern updates this
> way, but in the end wound up just ignoring the limit in do_coredump, rather than
> re-writing it.  Thanks for that.  You can scratch this.
>
>
> > >          Note also %u and %g may be different values
> > >          than getuid/getgid in the event that the core_pattern executable is
> > >          set[u|g]id root
> >
> > I'm slightly confused by that last point.  According to my
> > experiments, the core_pattern executable is always run as user and
> > group root, so making it set[ug]id root would seem to be a no-op.
> > (But anyway, %u and %g do give the "right" values -- the UID and GID
> > of the dumping process.)
> >
> Hmm, are you sure, I was under the impression that we fork the usermodehelper in
> do_coredump as a parent of current, which has the dumping processes uid/gid.  I
> do see that in do_coredump we call get_dumpable(mm) and if it returns with the
> appropriate value we switch current->fsuid to 0.  I wonder if thats what you're
> seeing?

Have a look at the following.  It demonstrates what I'm seeing (that
the coredump program is run as root/root).

===
$ cat core_pattern_test.c
/* core_pattern_test.c */

#define _GNU_SOURCE
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#define BUF_SIZE 1024

int
main(int argc, char *argv[])
{
    int fd, tot, j;
    ssize_t nread;
    char buf[BUF_SIZE];
    FILE *fp;

    fd = open(argv[1], O_CREAT | O_WRONLY | O_TRUNC, 0666);
    if (fd == -1)
        exit(EXIT_FAILURE);

    fp = fdopen(fd, "a");

    fprintf(fp, "PID=%ld\n", (long) getpid());
    fprintf(fp, "cwd=%s\n", get_current_dir_name());
    fprintf(fp, "UID=%ld; EUID=%ld\n", (long) getuid(), (long) geteuid());
    fprintf(fp, "GID=%ld; EGID=%ld\n", (long) getgid(), (long) getegid());

    fprintf(fp, "argc=%d\n", argc);
    for (j = 0; j < argc; j++)
        fprintf(fp, "argc[%d]=<%s>\n", j, argv[j]);

    /* Count bytes in standard input */

    tot = 0;
    while ((nread = read(STDIN_FILENO, buf, BUF_SIZE)) > 0)
        tot += nread;
    fprintf(fp, "Total bytes in core dump: %d\n", tot);

    exit(EXIT_SUCCESS);
}
$ cc core_pattern_test.c
$ sudo sh -c 'echo "|$PWD/core_pattern_test $PWD/c p_%p u_%u g_%g t_%t
c_%c" > /proc/sys/kernel/core_pattern'
root's password:
$ id
uid=1000(mtk) gid=100(users) groups=16(dialout),33(video),100(users)
$ sleep 100
[type ^\]
Quit (core dumped)
$ cat c
PID=6743
cwd=/
UID=0; EUID=0
GID=0; EGID=0
argc=7
argc[0]=</home/mtk/man-pages/man5/core_pattern_test>
argc[1]=</home/mtk/man-pages/man5/c>
argc[2]=<p_6742>
argc[3]=<u_1000>
argc[4]=<g_100>
argc[5]=<t_1209146940>
argc[6]=<c_4294967295>
Total bytes in core dump: 282624
$
===

Your thoughts?

Cheers,

Michael
