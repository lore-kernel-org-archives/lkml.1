Return-Path: <linux-kernel-owner+w=401wt.eu-S1752376AbZBCWiO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752376AbZBCWiO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 17:38:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751708AbZBCWhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 17:37:55 -0500
Received: from gw.goop.org ([64.81.55.164]:34913 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755471AbZBCWhy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 17:37:54 -0500
Message-ID: <4988C73F.2070707@goop.org>
Date: Tue, 03 Feb 2009 14:37:51 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
       randy.dunlap@oracle.com, linux-kernel@vger.kernel.org, x86@kernel.org,
       Andrea Righi <righi.andrea@gmail.com>
Subject: Re: mmotm 2009-02-02-17-12 uploaded (x86/nopmd etc.)
References: <200902030112.n131CNiq010549@imap1.linux-foundation.org> <498893C8.6080506@oracle.com> <20090203191804.GA24698@elte.hu> <20090203121706.423d5cab.akpm@linux-foundation.org> <20090203212538.GB20527@elte.hu>
In-Reply-To: <20090203212538.GB20527@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> the include file spaghetti is ... interesting there, and it's historic.
>
> I could blame it on highmem, PAE or paravirt - but i'll only blame it on 
> paravirt for now because those developers are still around! ;-)
>   

Hey, don't forget unification, if we're pointing fingers ;)

> Jeremy, any ideas how to reduce the historic dependency mess in that area?
> I think we should go on three routes at once:
>
>  - agressive splitup and separation of type definitions from method
>    declaration (+ inline definitions). The spinlock_types.h / spinlock.h 
>    splitup was really nice in solving such dependency problems.
>   

That already exists to some extent, though I don't think it's being used 
to maximum advantage (pgtable-[23]level.h vs pgtable-[23]level-defs.h).  
For consistency we'd have  pgtable-4level(-defs).h headers too, and 
top-level pgtable.h/pgtable-defs.h headers.  But its not clear to me 
that would even be enough...

>  - uninlining of methods: instead of macro-ing them - wherever possible. 
>    It's really hard to mess up type + externs headers - while headers with 
>    inlines and macros mixed in get painful quickly.
>   

Yes.  I went through a period of fairly aggressive inline->macro 
conversion, and in many cases the remaining macros are there to #include 
hell.

>  - removal of spurious pile of dozens of #include lines in header files.

Yeah, it would be useful to make sure that each header only #includes 
the bare minimum headers to satisfy its own definitions - but of course 
that's going to provoke a long series of #include whack-a-mole patches.

    J
