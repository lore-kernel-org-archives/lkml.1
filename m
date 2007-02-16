Return-Path: <linux-kernel-owner+w=401wt.eu-S1946296AbXBPXib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946296AbXBPXib (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 18:38:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946302AbXBPXib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 18:38:31 -0500
Received: from tomts25-srv.bellnexxia.net ([209.226.175.188]:61847 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946301AbXBPXi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 18:38:29 -0500
Date: Fri, 16 Feb 2007 18:38:25 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Karim Yaghmour <karim.yaghmour@kryptiva.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@redhat.com>,
       systemtap@sources.redhat.com, ltt-dev@shafik.org
Subject: Re: [PATCH 05/05] Linux Kernel Markers, non optimized architectures
Message-ID: <20070216233825.GB28087@Krystal>
References: <1171224207118-git-send-email-mathieu.desnoyers@polymtl.ca> <1171224209195-git-send-email-mathieu.desnoyers@polymtl.ca> <20070214231635.091c7169.akpm@linux-foundation.org> <20070215190919.GA31359@Krystal> <45D61361.6030200@kryptiva.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <45D61361.6030200@kryptiva.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 18:32:40 up 14 days, 13:40,  5 users,  load average: 2.37, 2.34, 1.89
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Karim Yaghmour (karim.yaghmour@kryptiva.com) wrote:
> ----- KRYPTIVA PACKAGED MESSAGE -----
> PACKAGING TYPE: SIGNED
> 
> Mathieu Desnoyers wrote:
> > The main goal of this config option is for embedded systems which doesn't 
> support live code modification. Maybe we can put that under "embedded 
> sytems" menu ?
> 
> Not sure whether you had had other feedback on this elsewhere in
> the rest of the thread, but yes, this would make sense if the
> "embedded" angle is the only reason we need this (and not, say,
> performance, etc.) Also, having done that, maybe it would make
> some sense to have it be a "disable" rather than "enable":
> CONFIG_MARKERS_DISABLE_OPTIMIZATION?
> 

Hi Karim,

Yes, that was indeed the first way I implemented it, as a "disable"
option. One of the main thing we have to figure out before I modify this
is if we want to have the generic version of markers available in a
"forced" manner at the marker site with the GEN_MARK macro instead of
the MARK macro (this is the actual implementation). It has proven to
be useful to instrument lockdep.c irq enable/disable tracing functions.
The reason why is because they are called just before the trap handler
returns and I need it to do XMC on x86 and x86_64. It would therefore
cause a recursive trap.

I think it makes sense to have this kind of support for hard-to-instrument
sites within the marker infrastructure, but the cost is to have two
marker flavors : MARK and GEN_MARK (but really GEN_MARK is only intended
for a few sites).

Mathieu

> Karim
> 
> 
> ----- KRYPTIVA SIGNED MESSAGE -----
> This email claims to have been packaged by Kryptiva.
> To process this email and authenticate its origin, get
> the free plugin from:
> http://www.kryptiva.com/downloads
> 
> ----- KRYPTIVA SIGNATURE START -----
> AvWVqAAAAAIAAAABAAAAAAAATiACAQAAAAC3AQAIAAAAAgAAAAECABTXxT4xHdR4/1uU1hL2
> +TaPrqNB0wMAFNa8GHXZWJH5Dz+D76vfh6JhvWLvBAAUpuIZcCAkCC+ldyaBuoAWxK50HiQF
> ABRI38gc/foDHQsS6X3W0VP4xTukBwYAFDzvzh+u6zVtolglAZrnE7FOmtZDBwAUTxyTas6N
> WLapdnSnAwVHeC06/ioRABgAAAAAAABOIEXWD8AACTdnAAAAAAAAAN8TAAQAAAAAAAAAggP+
> K8Gk1SWj+c67jiJerodkr1gntoa9dJVVN6InxB824CfKC6flE4JMWtffw0Dxh0cJ8iOQ8UeC
> zoWzTs9Z+K9j1CL11CHkIIit3RK3hnfnby6whr4xoZ9UX/BUUv8FVKZeyRg7SbDKlhEZTwIH
> 7axjVQJ6MGU7h+0/5dKCDMEtzPY=
> ----- KRYPTIVA SIGNATURE END -----

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Candidate, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
