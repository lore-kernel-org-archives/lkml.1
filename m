Return-Path: <linux-kernel-owner+w=401wt.eu-S1763843AbXKNTk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763843AbXKNTk2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 14:40:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753834AbXKNTkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 14:40:11 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:46486 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757320AbXKNTkK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 14:40:10 -0500
Date: Wed, 14 Nov 2007 20:41:42 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 2/4] Add ARCH_SUPPORTS_OPROFILE
Message-ID: <20071114194142.GC10047@uranus.ravnborg.org>
References: <20071113142609.103579906@polymtl.ca> <20071113142935.063097504@polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071113142935.063097504@polymtl.ca>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mathieu.

> 
> It would be much better to do
> 
>         depends on ARCH_SUPPORTS_KPROBES
> 
> in that generic file, and then architectures that do support it would just
> have a
> 
>         bool ARCH_SUPPORTS_KPROBES
>                 default y

The above suggestion is actually not exactly the best way to do it...
First the naming..
A quick grep shows following usage today (in Kconfig files)
ARCH_HAS	51
ARCH_SUPPORTS	4
HAVE_ARCH	7

ARCH_HAS is the clear winner.


In the common Kconfig file do:

config FOO
	depends on ARCH_HAS_FOO
	bool "bla bla" 

config ARCH_HAS_FOO
	def_bool n


In the arch specific Kconfig file in a suitable place do:

config SUITABLE_OPTION
	select ARCH_HAS_FOO


The naming of ARCH_HAS_ is fixed and shall be:
ARCH_HAS_<config option it will enable>


Only a single line added pr. architecture.
And we will end up with a (maybe even commented) list of trivial selects.

Sorry for providing late feedback on this!

	Sam
