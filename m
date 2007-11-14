Return-Path: <linux-kernel-owner+w=401wt.eu-S1764591AbXKNVwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764591AbXKNVwx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 16:52:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755109AbXKNVwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 16:52:45 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:57143 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755296AbXKNVwo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 16:52:44 -0500
Date: Wed, 14 Nov 2007 22:54:25 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 2/4] Add ARCH_SUPPORTS_OPROFILE
Message-ID: <20071114215425.GA10920@uranus.ravnborg.org>
References: <20071113142609.103579906@polymtl.ca> <20071113142935.063097504@polymtl.ca> <20071114194142.GC10047@uranus.ravnborg.org> <20071114213558.GB9010@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071114213558.GB9010@Krystal>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > 
> > In the arch specific Kconfig file in a suitable place do:
> > 
> > config SUITABLE_OPTION
> 
> Since config KPROBES will already be used in the architecture
> independent Kconfig, I should find a different name for "config
> SUITABLE_OPTION". Would
> 
> config KPROBES_SUPPORT
>   select ARCH_HAS_KPROBES
> 
> be ok ?

I should have been more specific here.

We do NOT want a dedicated config symbol just for this.
For x86 use X86
For arm use ARM
For sparc64 use SPARC64
For sparc use SPARC32

etc. you get the picture.

For x86 (where I spend a fair amount of time recently)
there are several candidates to be moved to such a select
list.
Only reason not to do it then was to keep changes minimal.

It would look like this:

config X86
	select ARCH_HAS_KPROBES        # yada yada
	select ARCH_HAS_FOO            # more yada yada

If you select an undefined symbol kconfig will warn you so keep
an eye out for this (among all the other warnings kconfig spits out).

arm uses this for the different boards as a good example.
But they do not have the common-prefix rule in place.

	Sam
