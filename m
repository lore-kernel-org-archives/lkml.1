Return-Path: <linux-kernel-owner+w=401wt.eu-S1764716AbZANRQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764716AbZANRQd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 12:16:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763246AbZANRQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 12:16:25 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:44723 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762985AbZANRQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 12:16:24 -0500
Subject: Re: [REGRESSION] Recent change to kernel spikes out ccache/distcc
From: Peter Zijlstra <peterz@infradead.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Jan Beulich <jbeulich@novell.com>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org, ccache@lists.samba.org
In-Reply-To: <E1LKDeQ-0002xz-7E@closure.thunk.org>
References: <E1LKDeQ-0002xz-7E@closure.thunk.org>
Content-Type: text/plain
Date: Wed, 14 Jan 2009 18:16:19 +0100
Message-Id: <1231953379.14825.29.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-06 at 10:15 -0500, Theodore Ts'o wrote:
> The following commit, ad7a953c, "kbuild: strip generated symbols from
> *.ko" which was merged to the mainline last week (December 28th) has the
> unfortunate side effct of making ccache useless.  That's because all
> files are now built using a two step process.  First they are compiled
> to assembly via "gcc -S -o .tmp_foo.s" and then assembled via "gcc" in a
> separate step.  Unfortunately, ccache doesn't seem to be able to cache
> either the compilation or the assembly step (and it may not be worth it
> once the two steps are separated).
> 
> It would be nice if there was a CONFIG option which compiles files the
> old-fashioned way, even if we lose the ability to strip the__crc_
> symbols, just so that ccache can function again, since it can really
> speed up the kernel development process.  Alternatively, maybe ccache
> could somehow be taught a specialized way take the .c file, some kind of
> kbuild-specified version identifier, and then output of the gcc -S,
> assembly frobnication, gcc -c, objcopy pipeline that kbuild uses to
> build an object file, so we can have cache the entire kbuild object
> building process.
> 
> Or, if that's too complicated, maybe it would be worthwhile to have
> kbuild create its own specialized ccache system?  Note that the last two
> solutions rule out using distcc, unless we can encapsulate the build
> process from a series of Makefile macros to a shell or C program, which
> could then be injected to the remote host system to be executed by
> distcc.  One value of doing that is the CRC or MD5 of the shell script
> could be used as the version tag for the cache system.
> 
> In the short term, though, it would be nice if we could get back a
> simple way of making a kernel  object file using just cc, so that ccache
> and distcc could be functional again.   Does that seem reasonable?

So what's the current status on this, could we get it reverted ASAP or
add that CONFIG_ switch (default N)?

Leaving the build system broken for so long just isn't cool.

