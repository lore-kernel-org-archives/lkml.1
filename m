Return-Path: <linux-kernel-owner+w=401wt.eu-S1762502AbXKNVgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762502AbXKNVgR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 16:36:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753921AbXKNVgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 16:36:04 -0500
Received: from tomts36.bellnexxia.net ([209.226.175.93]:58396 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753457AbXKNVgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 16:36:01 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAIb5OkdMROHU/2dsb2JhbACBXA
Date: Wed, 14 Nov 2007 16:35:58 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 2/4] Add ARCH_SUPPORTS_OPROFILE
Message-ID: <20071114213558.GB9010@Krystal>
References: <20071113142609.103579906@polymtl.ca> <20071113142935.063097504@polymtl.ca> <20071114194142.GC10047@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20071114194142.GC10047@uranus.ravnborg.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:34:18 up 11 days,  2:39,  5 users,  load average: 0.45, 0.58,
	0.62
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Sam Ravnborg (sam@ravnborg.org) wrote:
> Hi Mathieu.
> 
> > 
> > It would be much better to do
> > 
> >         depends on ARCH_SUPPORTS_KPROBES
> > 
> > in that generic file, and then architectures that do support it would just
> > have a
> > 
> >         bool ARCH_SUPPORTS_KPROBES
> >                 default y
> 
> The above suggestion is actually not exactly the best way to do it...
> First the naming..
> A quick grep shows following usage today (in Kconfig files)
> ARCH_HAS	51
> ARCH_SUPPORTS	4
> HAVE_ARCH	7
> 
> ARCH_HAS is the clear winner.
> 
> 
> In the common Kconfig file do:
> 
> config FOO
> 	depends on ARCH_HAS_FOO
> 	bool "bla bla" 
> 
> config ARCH_HAS_FOO
> 	def_bool n
> 
> 
> In the arch specific Kconfig file in a suitable place do:
> 
> config SUITABLE_OPTION

Since config KPROBES will already be used in the architecture
independent Kconfig, I should find a different name for "config
SUITABLE_OPTION". Would

config KPROBES_SUPPORT
  select ARCH_HAS_KPROBES

be ok ?

> 	select ARCH_HAS_FOO
> 
> 
> The naming of ARCH_HAS_ is fixed and shall be:
> ARCH_HAS_<config option it will enable>
> 
> 
> Only a single line added pr. architecture.
> And we will end up with a (maybe even commented) list of trivial selects.
> 
> Sorry for providing late feedback on this!
> 
> 	Sam

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
