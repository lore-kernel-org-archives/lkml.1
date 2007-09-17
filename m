Return-Path: <linux-kernel-owner+w=401wt.eu-S1754741AbXIQQ7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741AbXIQQ7e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 12:59:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751945AbXIQQ7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 12:59:24 -0400
Received: from mail.gmx.net ([213.165.64.20]:48675 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751726AbXIQQ7X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 12:59:23 -0400
X-Authenticated: #24879014
X-Provags-ID: V01U2FsdGVkX18SIk5DHGgStrEWOw2jPuPokaKq+ONelMG8sWmbwJ
	e8HTME+EJWEI0b
Message-ID: <46EEB1E5.3000306@gmx.net>
Date: Mon, 17 Sep 2007 18:57:09 +0200
From: Michael Kerrisk <mtk-manpages@gmx.net>
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
CC: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: man-pages-2.65 is released
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday,

I recently released man-pages-2.65.

This release is now available for download at:

    http://www.kernel.org/pub/linux/docs/manpages
    or ftp://ftp.kernel.org/pub/linux/docs/manpages

Changes in this release that may be of interest to readers of this list are
noted below.

Cheers,

Michael
(man-pages maintenance is supported by Google, as a Google engineer 20%
project.)

==================== Changes in man-pages-2.65 ====================


New pages
---------

timeradd.3
    mtk
        Description of timeradd(), timersub(), timerclear(),
        timerisset(), timercmp() macros for operating on
        struct timeval.


Changes to individual pages
---------------------------

get_mempolicy.2
    Lee Schermerhorn
        changed the "policy" parameter to "mode" through out the
        descriptions in an attempt to promote the concept that the memory
        policy is a tuple consisting of a mode and optional set of nodes.

        added requirement to link '-lnuma' to synopsis

        rewrite portions of description for clarification.

        added all errors currently returned by sys call.

        removed cautionary note that use of MPOL_F_NODE|MPOL_F_ADDR
        is not supported.  This is no longer true.

        added mmap(2) to See Also list.

getitimer.2
    mtk
       Since kernel 2.6.22, Linux setitimer() now conforms to POSIX.1,
       giving an EINVAL error for a non-canonical tv_usec value.

mbind.2
    Lee Schermerhorn

        changed the "policy" parameter to "mode" throughout the
        descriptions in an attempt to promote the concept that the memory
        policy is a tuple consisting of a mode and optional set of nodes.

        rewrite portions of description for clarification.

            clarify interaction of policy with mmap()'d files and shared
            memory regions, including SHM_HUGE regions.

            defined how "empty set of nodes" specified and what this
            means for MPOL_PREFERRED.

            mention what happens if local/target node contains no
            free memory.

            clarify semantics of multiple nodes to BIND policy.
            Note:  subject to change.  We'll fix the man pages when/if
                   this happens.

        added all errors currently returned by sys call.

        added mmap(2), shmget(2), shmat(2) to See Also list.

mmap.2
mprotect.2
    François Diakhate
        Add text noting that PROT_WRITE may (and on x86 does)
        imply PROT_READ.
        See Debian bug 441387.

sched_setscheduler.2
    Carsten Emde
        Add text on real-time features of mainline Linux kernel.

set_mempolicy.2
    Lee Schermerhorn

        changed the "policy" parameter to "mode" throughout the
        descriptions in an attempt to promote the concept that the memory
        policy is a tuple consisting of a mode and optional set of nodes.

        added requirement to link '-lnuma' to synopsis

        rewrite portions of description for clarification.

            clarify interaction of policy with mmap()'d files.

            defined how "empty set of nodes" specified and what this
            means for MPOL_PREFERRED.

            mention what happens if local/target node contains no
            free memory.

            clarify semantics of multiple nodes to BIND policy.
            Note:  subject to change.  We'll fix the man pages when/if
                   this happens.

        added all errors currently returned by sys call.

        added mmap(2) to See Also list.

stat.2
    mtk
        Improve text describing underlying system calls.

uname.2
    mtk
        Improve text describing underlying system calls.

utime.2
    Vincent Lefevre / mtk
        Clarify utimes() behaviour when 'times' is NULL.

gethostbyaddr.3
    Mats Wichmann
        Add documentation for gethostbyaddr_r().
        Plus a few other small fixes.

longjmp.3
    Paul Brook / mtk
        After a call to longjmp(), the values of modified, non-volatile
        variables in the function that called setjmp() are unspecified.

opendir.3
    Ulrich Drepper; some edits and additional text by mtk
        Document fdopendir().

readdir.3
    mtk, after a note by Andi Kleen
        Document DT_* constants for d_type.
    Ulrich Drepper / mtk
        Rework discussion of non-standard structure fields.

proc.5
    mtk
        Improve description of num_threads field under /proc/PID/stat.
    Maxime Vaudequin
        Fix path error (s%proc/sys%proc/sys/kernel%) in mentions of
        /proc/sys/ostype, /proc/sys/osrelease and proc/sys/version.
    Maxime Vaudequin
        I noticed things to correct and to clarify in subsection
        "/proc/filesystems" of proc.5:
        - clarify filesystems listing: not only FS compiled
          into the kernel, also FS kernel modules currently loaded
        - add a reference to fs(5)
        - add an explanation for FS marked with "nodev"
        - s/mount(1)/mount(8)/, also corrected in section "SEE ALSO"
        - clarify usage by mount: the current wording may lead to
          think /proc/filesystems is always used by mount when no FS
          is specified. So, usage of "may" which IMHO is more
          appropriate + additional explanations
          In mount(8) we can see:

               If no -t option is given, or if the auto type is
               specified, mount will try to guess the desired type.
               If mount was compiled with the blkid library, the
               guessing is done by this library. Otherwise, mount
               guesses itself by probing the superblock; if that
               does not turn up anything that looks familiar,
               mount will try to read the file /etc/filesystems,
               or, if that does not exist, /proc/filesystems.
               All of the filesystem types listed there will be
               tried, except for those that are labeled "nodev"
               (e.g., devpts, proc and nfs). If /etc/filesystems
               ends in a line with a single * only, mount will
               read /proc/filesystems afterwards.
    Samuel Thibault
        Since linux 2.6.11, /proc/stat has an eighth value for cpu
        lines: stolen time, which is the time spent in other operating
        systems when running in a virtualized environment.

credentials.7
    mtk
        Add words to note that file system ID is Linux specific.

pthreads.7
    mtk
        Update text about modern threading implementations
        (NPTL vs LinuxThreads).

socket.7
    mtk, after a note by Andi Kleen
        Clarify that SO_SNDTIMEO and SO_RCVTIMEO only have effect for
        socket I/O calls; not for multiplexing system calls like
        select() and poll().


-- 
Michael Kerrisk
maintainer of Linux man pages Sections 2, 3, 4, 5, and 7

Want to help with man page maintenance?  Grab the latest tarball at
http://www.kernel.org/pub/linux/docs/manpages/
read the HOWTOHELP file and grep the source files for 'FIXME'.

