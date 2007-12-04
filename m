Return-Path: <linux-kernel-owner+w=401wt.eu-S1752885AbXLDTPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885AbXLDTPl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 14:15:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751444AbXLDTPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 14:15:33 -0500
Received: from tomts36-srv.bellnexxia.net ([209.226.175.93]:48474 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751432AbXLDTPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 14:15:32 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAFA2VUdMROHU/2dsb2JhbACBWg
Date: Tue, 4 Dec 2007 14:15:28 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, roland@redhat.com, dsmith@redhat.com,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [patch 2/2] Linux Kernel Markers - Create modpost file
Message-ID: <20071204191528.GA31752@Krystal>
References: <20071204181845.895090222@polymtl.ca> <20071204182403.319351701@polymtl.ca> <20071204111026.9f7d8ed5.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20071204111026.9f7d8ed5.akpm@linux-foundation.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:12:52 up 31 days, 18 min,  6 users,  load average: 0.14, 0.73,
	0.90
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton (akpm@linux-foundation.org) wrote:
> On Tue, 04 Dec 2007 13:18:47 -0500
> Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > This adds some new magic in the MODPOST phase for CONFIG_MARKERS.
> > Analogous to the Module.symvers file, the build will now write a
> > Module.markers file when CONFIG_MARKERS=y is set.  This file lists
> > the name, defining module, and format string of each marker,
> > separated by \t characters.  This simple text file can be used by
> > offline build procedures for instrumentation code, analogous to
> > how System.map and Module.symvers can be useful to have for
> > kernels other than the one you are running right now.
> > 
> > The strings are made easy to extract by having the __trace_mark macro
> > define the name and format together in a single array called __mstrtab_*
> > in the __markers_strings section.  This is straightforward and reliable
> > as long as the marker structs are always defined by this macro.  It is
> > an unreasonable amount of hairy work to extract the string pointers from
> > the __markers section structs, which entails handling a relocation type
> > for every machine under the sun.
> > 
> > Mathieu :
> > - Ran through checkpatch.pl
> > 
> > ...
> >
> > --- linux-2.6-lttng.orig/scripts/mod/modpost.c	2007-11-21 20:54:17.000000000 -0500
> > +++ linux-2.6-lttng/scripts/mod/modpost.c	2007-11-21 21:19:19.000000000 -0500
> > @@ -11,6 +11,8 @@
> >   * Usage: modpost vmlinux module1.o module2.o ...
> >   */
> >  
> > +#define _GNU_SOURCE
> 
> Why was the mystery addition of _GNU_SOURCE made?
> 

I think Roland needed it for asprintf().

> > +#include <stdio.h>
> >  #include <ctype.h>
> >  #include "modpost.h"
> >  #include "../../include/linux/license.h"
> > @@ -424,6 +426,8 @@ static int parse_elf(struct elf_info *in
> 
> These two patches are unfortunately large, intrusive and tricky to be
> turning up in -rc4.
> 

Yup. What I would really like is to, at least, get the API stabilised
for 2.6.24. It that means extracting the API changes from the first
patch, I could do it. Then we would have plenty of time to discuss the
multiple probes support.

API changes :
- Remove marker arm/disarm
- Probe callback now takes a va_list * instead of a ... argument.

Does it sound like a good idea ?

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
