Return-Path: <linux-kernel-owner+w=401wt.eu-S1756464AbXJEFll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756464AbXJEFll (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 01:41:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751495AbXJEFld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 01:41:33 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33277 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751478AbXJEFlc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 01:41:32 -0400
Date: Fri, 5 Oct 2007 07:41:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Glauber de Oliveira Costa <glommer@gmail.com>
Cc: Alistair John Strachan <alistair@devzero.co.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Linux 2.6.23-rc9 and a heads-up for the 2.6.24 series..
Message-ID: <20071005054117.GB25242@elte.hu>
References: <alpine.LFD.0.999.0710012029400.3579@woody.linux-foundation.org> <200710022351.48971.alistair@devzero.co.uk> <5d6222a80710021600tb42532bhd4001060b464bb48@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d6222a80710021600tb42532bhd4001060b464bb48@mail.gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Glauber de Oliveira Costa <glommer@gmail.com> wrote:

> On 10/2/07, Alistair John Strachan <alistair@devzero.co.uk> wrote:
> > This is certainly a tool issue, but if I use Debian's kernel-image "make-kpkg"
> > wrapper around the kernel build system, it fails with:
> >
> > cp: cannot stat `arch/x86_64/boot/bzImage': No such file or directory
> >
> > Obviously, this file has moved to arch/x86/boot, but it seems like possibly
> > unnecessary breakage. I've been copying bzImage for years from
> > arch/x86_64/boot, and I'm sure there's a handful of scripts (other than
> > Debian's kernel-image) doing this too.
> 
> I believe most sane tools would be using the output of uname -m, so a 
> possible way to fix this would be fixing the data passed to userspace 
> from uname. However, that might be the case that it creates a new set 
> of problems too, with tools relying on the output of uname -m to 
> determine wheter the machine is 32 or 64 bit, and so on.

there are two problems with the use of uname -m:

- the build machine architecture is not necessarily the same as the
  target architecture. (for example i cross-compile all my 32-bit
  kernels on a 64-bit box.)

- we kept uname -m compatile. multilib depends on it, and other pieces
  of userspace as well. So uname -m still outputs 'i386' on 32-bit and
  'x86_64' on 64-bit - not 'x86'.

a symlink looks like the best solution to me.

	Ingo
