Return-Path: <linux-kernel-owner+w=401wt.eu-S1422922AbXBPAmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422922AbXBPAmq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 19:42:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422925AbXBPAmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 19:42:46 -0500
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:53179 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422922AbXBPAmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 19:42:45 -0500
Date: Thu, 15 Feb 2007 19:37:39 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tilman Schmidt <tilman@imap.cc>, linux-kernel@vger.kernel.org
Subject: Re: sparse chokes on arch/i386/kernel/i8253.c (was: 2.6.20-mm1)
Message-ID: <20070216003739.GC9851@Krystal>
References: <20070215051408.a7fb7d81.akpm@linux-foundation.org> <45D483D7.2040609@imap.cc> <20070215144142.0c13580a.akpm@linux-foundation.org> <20070215224656.GB6297@Krystal> <20070215154418.88edfcbc.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070215154418.88edfcbc.akpm@linux-foundation.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 19:29:18 up 13 days, 14:37,  3 users,  load average: 1.02, 1.49, 1.57
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton (akpm@linux-foundation.org) wrote:
> On Thu, 15 Feb 2007 17:46:56 -0500
> Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > > Me too.  It's due to the linux-kernel-markers patches.  Mathieu, can you
> > > take a look please?
> > 
> > I will give a deeper look in sparse, but I should say up front that I
> > add this to the root build tree Makefile :
> > 
> > LINUXINCLUDE    := -Iinclude \
> >                    $(if $(KBUILD_SRC),-Iinclude2 -I$(srctree)/include) \
> >                    -include include/linux/autoconf.h \
> >                    -include linux/marker.h
> > 
> > I guess sparse is maybe not using this Makefile or variable ?
> 
> ow, that's going to hurt - this stuff is complex and fragile.
> 

Sorry, I will remember to do more explicit changelogs.

> For what reason was that change made?
> 

It was made so that we can use the markers in C code without actually
including marker.h everywhere. I am sure someone has a better way to do
it : I would be happy to use this-nice-build-system-feature-I-missed to
have marker.h included.

> Pleeze, tricky things like this should be changelogged - we shouldn't need
> to ask.  I missed it.
> 
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Candidate, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
