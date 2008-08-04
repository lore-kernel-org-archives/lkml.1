Return-Path: <linux-kernel-owner+w=401wt.eu-S1763223AbYHDVQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763223AbYHDVQZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 17:16:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758632AbYHDVQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 17:16:14 -0400
Received: from smtpout3.tre.se ([80.251.192.228]:25602 "EHLO smtpout3.tre.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758764AbYHDVQN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 17:16:13 -0400
Date: Mon, 4 Aug 2008 23:16:41 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jan Beulich <jbeulich@novell.com>
Cc: mingo@elte.hu, Harvey Harrison <harvey.harrison@gmail.com>,
       tglx@linutronix.de, Roman Zippel <zippel@linux-m68k.org>,
       Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: def_bool n
Message-ID: <20080804211640.GC29902@uranus.ravnborg.org>
References: <48971232.76E4.0078.0@novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48971232.76E4.0078.0@novell.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2008 at 01:29:06PM +0100, Jan Beulich wrote:
> Could either of you clarify what the significance of such a construct
> (encountered several times in arch/x86/Kconfig alone) is?
> 
> At first, I noticed it only with GENERIC_LOCKBREAK (it is my
> understanding that this block can go away entirely), but then realized
> that with the bool->def_bool conversion this was introduced in various
> other places (where "default n" was used before, which seems as
> pointless a statement). Am I missing something?

No.

arch/x86/Kconfig:
config GENERIC_LOCKBREAK
        def_bool n

I assume this is solely to document that x86 does
NOT use GENERIC_LOCKBREAK as it serves no other purpose.

Notice that we may see:

init/Kconfig:
config FOO
	def_bool y

arch/$ARCH/Kconfig:
config FOO
	def_bool n

And this will result in setting FOO to the last seen value.
All the HAVE_* stuff is btw to avoid such double definition
of a config symbol.

GENERIC_LOCKBREAK is another candidate.

	Sam
