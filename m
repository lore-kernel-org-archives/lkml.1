Return-Path: <linux-kernel-owner+w=401wt.eu-S1756825AbYEEL3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825AbYEEL3d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 07:29:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753864AbYEEL3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 07:29:24 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:3776 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752935AbYEEL3X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 07:29:23 -0400
Date: Mon, 5 May 2008 07:29:08 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Michael Kerrisk <mtk.manpages@googlemail.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-man@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Petr Gajdos <pgajdos@suse.cz>, michael.kerrisk@gmail.com
Subject: Re: core_pattern pipe documentation - draft 2
Message-ID: <20080505112908.GA13860@hmsreliant.think-freely.org>
References: <cfd18e0f0804230509g4e7456ecgd40c0bfee874a82c@mail.gmail.com> <20080423145933.GA26228@hmsendeavour.rdu.redhat.com> <cfd18e0f0804250618ic6dfd09gf68573256be3ff@mail.gmail.com> <20080425162225.GA9833@hmsreliant.think-freely.org> <cfd18e0f0804251113w4ef2dea3t6727009aa67e6e09@mail.gmail.com> <20080425185442.GC9833@hmsreliant.think-freely.org> <cfd18e0f0804251305u4edb2bb1k290553965291c4fa@mail.gmail.com> <20080425201800.GD9833@hmsreliant.think-freely.org> <cfd18e0f0804251339x2b19dd79o593d836986bf99ee@mail.gmail.com> <481EB4F4.8050901@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <481EB4F4.8050901@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2008 at 09:19:16AM +0200, Michael Kerrisk wrote:
> Hi Neil,
> 
> Below is a revised draft of the text for core_pattern.  Would you be willing
> check it over?
> 
> Cheers,
> 
> Michael
> 
>      Naming of core dump files
>        By   default,   a  core  dump  file  is  named  core,  but  the
>        /proc/sys/kernel/core_pattern file (since Linux 2.6 and 2.4.21)
>        can  be set to define a template that is used to name core dump
>        files.  The template can contain % specifiers which are substi-
>        tuted by the following values when a core file is created:
> 
>            %%  a single % character
>            %p  PID of dumped process
>            %u  (numeric) real UID of dumped process
>            %g  (numeric) real GID of dumped process
>            %s  number of signal causing dump
>            %t  time  of  dump,  expressed  as  seconds since the Epoch
>                (00:00h, 1 Jan 1970, UTC)
>            %h  hostname (same as 'nodename' returned by uname(2))
>            %e  executable filename (without path prefix)
>            %c  core file size soft resource limit of crashing  process
>                (since Linux 2.6.24)
> 
>        A  single % at the end of the template is dropped from the core
>        filename, as is the combination of a % followed by any  charac-
>        ter other than those listed above.  All other characters in the
>        template become a literal part of the core filename.  The  tem-
>        plate  may  include  '/'  characters,  which are interpreted as
>        delimiters for  directory  names.   The  maximum  size  of  the
>        resulting  core  filename  is  128  bytes  (64 bytes in kernels
>        before 2.6.19).
>    [...]
> 
>      Piping core dumps to a program
>        Since kernel 2.6.19, Linux supports an alternate syntax for the
>        /proc/sys/kernel/core_pattern  file.  If the first character of
>        this file is a pipe symbol (|), then the remainder of the  line
>        is  interpreted  as a program to be executed.  Instead of being
>        written to a disk file, the core  dump  is  given  as  standard
>        input to the program.  Note the following points:
> 
>        *  The program must be specified using an absolute pathname (or
>           a pathname relative to the  root  directory,  /),  and  must
>           immediately follow the '|' character.
> 
>        *  The  process  created  to  run  the program runs as user and
>           group root.
> 
>        *  Command-line arguments can be supplied to the program (since
>           kernel 2.6.24), delimited by white space (up to a total line
>           length of 128 bytes).
> 
>        *  The command-line arguments can include any of the  %  speci-
>           fiers  listed  above.   For  example, to pass the PID of the
>           process that is being dumped, specify %p in an argument.
> 
>    [...]
>    EXAMPLE
>        The  program  below  can  be used to demonstrate the use of the
>        pipe syntax in  the  /proc/sys/kernel/core_pattern  file.   The
>        following  shell  session  demonstrates the use of this program
>        (compiled to create an executable named core_pattern_test):
> 
>            $ cc -o core_pattern_test core_pattern_test.c
>            $ su
>            Password:
>            # echo "|$PWD/core_pattern_test %p UID=%u GID=%g sig=%s" > \
>                /proc/sys/kernel/core_pattern
>            # exit
>            $ sleep 100
>            type control-backslash
>            Quit (core dumped)
>            $ cat core.info
>            argc=5
>            argc[0]=</home/mtk/core_pattern_test>
>            argc[1]=<20575>
>            argc[2]=<UID=1000>
>            argc[3]=<GID=100>
>            argc[4]=<sig=3>
>            Total bytes in core dump: 282624
> 
>        The source code of the program is as follows:
> 
>        /* core_pattern_test.c */
> 
>        #define _GNU_SOURCE
>        #include <sys/stat.h>
>        #include <fcntl.h>
>        #include <limits.h>
>        #include <stdio.h>
>        #include <stdlib.h>
>        #include <unistd.h>
> 
>        #define BUF_SIZE 1024
> 
>        int
>        main(int argc, char *argv[])
>        {
>            int tot, j;
>            ssize_t nread;
>            char buf[BUF_SIZE];
>            FILE *fp;
>            char cwd[PATH_MAX];
> 
>            /* Change our current working directory to that of the
>               crashing process */
> 
>            snprintf(cwd, PATH_MAX, "/proc/%s/cwd", argv[1]);
>            chdir(cwd);
> 
>            /* Write output to file "core.info" in that directory */
> 
>            fp = fopen("core.info", "w+");
>            if (fp == NULL)
>                exit(EXIT_FAILURE);
> 
>            /* Display command-line arguments given to core_pattern
>               pipe program */
> 
>            fprintf(fp, "argc=%d\n", argc);
>            for (j = 0; j < argc; j++)
>                fprintf(fp, "argc[%d]=<%s>\n", j, argv[j]);
> 
>            /* Count bytes in standard input (the core dump) */
> 
>            tot = 0;
>            while ((nread = read(STDIN_FILENO, buf, BUF_SIZE)) > 0)
>                tot += nread;
>            fprintf(fp, "Total bytes in core dump: %d\n", tot);
> 
>            exit(EXIT_SUCCESS);
>        }

All looks great to me, thanks!

Acked-by: Neil Horman <nhorman@tuxdriver.com>


-- 
/****************************************************
 * Neil Horman <nhorman@tuxdriver.com>
 * Software Engineer, Red Hat
 ****************************************************/
