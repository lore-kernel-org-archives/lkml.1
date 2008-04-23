Return-Path: <linux-kernel-owner+w=401wt.eu-S1753896AbYDWO77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896AbYDWO77 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 10:59:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751187AbYDWO7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 10:59:49 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:3207 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751131AbYDWO7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 10:59:48 -0400
Date: Wed, 23 Apr 2008 10:59:33 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Michael Kerrisk <mtk.manpages@googlemail.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-man@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Petr Gajdos <pgajdos@suse.cz>, michael.kerrisk@gmail.com
Subject: Re: core_pattern pipe documentation
Message-ID: <20080423145933.GA26228@hmsendeavour.rdu.redhat.com>
References: <cfd18e0f0804151409q178addf4t4c6cba683bd0bff4@mail.gmail.com> <cfd18e0f0804151411x62080f10y833493db7f1b8cfd@mail.gmail.com> <48051FBA.60503@firstfloor.org> <4808D1F4.7050705@gmail.com> <cfd18e0f0804230509g4e7456ecgd40c0bfee874a82c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cfd18e0f0804230509g4e7456ecgd40c0bfee874a82c@mail.gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2008 at 02:09:14PM +0200, Michael Kerrisk wrote:
> Andi -- ping!
> 
> Adding Neil to CC, since it looks like he also did some work here, and
> so can perhaps comment.
> 
> On Fri, Apr 18, 2008 at 6:53 PM, Michael Kerrisk
> <mtk.manpages@googlemail.com> wrote:
> > Andi,
> >
> > I wrote the following description of the core_pattern pipe feature.  Does this
> > seem okay?
> >
> >   Piping core dumps to a program
> >       Since kernel 2.6.19, Linux supports an  alternate  syntax
> >       for the /proc/sys/kernel/core_pattern file.  If the first
> >       character of this file is a pipe  symbol  (|),  then  the
> >       remainder  of  the line is interpreted as a program to be
> >       executed.  Instead of being written to a disk  file,  the
> >       core  dump  is  given  as  standard input to the program.
> >       Note the following points:
> >
> >       *  The program must be specified using an absolute  path-
> >          name  (or  a  pathname relative to the root directory,
> >          /), and must immediately follow the '|' character.
> >
> >       *  The process created to run the program  runs  as  user
> >          and group root.
> >
> >       *  Arguments can be supplied to the program, delimited by
> >          white space (up to a total line length of 128  bytes).
> >
> > Cheers,
> >
> > Michael
> >
Thanks for CC'ing me.  The above all looks good.  I would add documentation
however, about the available macros that can be used when core_pattern is
specified as a pipe.  Adding something like the following would be good:

	* Arguments can be statically declared or implied via the use of macros,
	  denoted by the use of the %sign.  The following macros are supported:
		* %% - output a literal % sign on the command line
		* %p - the pid of the crashing process
		* %u - the uid of the crashing process
		* %g - the gid of the crashing process
		* %s - the signal that caused the crashing process to crash
		* %t - the time the crashing process dumped
		* %h - the hostname of the system
		* %e - the executable name of the crashing process
		* %c - the core limit size of the crashing process

	  Note that the core limit size macro may be a different value than what
	  is returned by getrlimit(RLIMIT_CORE,...).  This is due to the fact
	  that the core_pattern specified executible will be run as the same uid
	  as the crashing process, and to facilitate reception of the entire
	  core, the kernel will temporarily set RLIMIT_CORE to unlimited while
	  the dump is in progress.  Note also %u and %g may be different values
	  than getuid/getgid in the event that the core_pattern executable is
	  set[u|g]id root


Thanks & Regards
Neil


-- 
/***************************************************
 *Neil Horman
 *nhorman@tuxdriver.com
 *gpg keyid: 1024D / 0x92A74FA1
 *http://pgp.mit.edu
 ***************************************************/
