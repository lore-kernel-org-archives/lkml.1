Return-Path: <linux-kernel-owner+w=401wt.eu-S1758829AbXFZRgO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758829AbXFZRgO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 13:36:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756714AbXFZRf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 13:35:59 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49350 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751147AbXFZRf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 13:35:58 -0400
Date: Tue, 26 Jun 2007 10:35:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Ingo Molnar <mingo@elte.hu>, Jesper Juhl <jesper.juhl@gmail.com>,
       linux-kernel@vger.kernel.org, John Stultz <johnstul@us.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch, v2.6.22-rc6] sys_time() speedup
Message-Id: <20070626103529.fb302908.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0706261858350.1817@scrub.home>
References: <20070625200601.GA18980@elte.hu>
	<200706252309.47467.zippel@linux-m68k.org>
	<9a8748490706251417v10b3f24bwdf7ebd44093eaddf@mail.gmail.com>
	<Pine.LNX.4.64.0706252356400.1817@scrub.home>
	<9a8748490706251520g24ff7a9dk716d73e7dbfd9ec3@mail.gmail.com>
	<20070626161857.GA7178@elte.hu>
	<Pine.LNX.4.64.0706261858350.1817@scrub.home>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jun 2007 19:08:27 +0200 (CEST) Roman Zippel <zippel@linux-m68k.org> wrote:

> > This current ... interesting piece of Roman about a _single_ trivial 
> > unlikely() branch in do_gettimeofday() borders on the ridiculous. My 
> > patch might be wrong for various reasons, but that single
> > 'if (unlikely())' statement is not one of those reasons =B-)
> 
> That's even more nonsense, that wasn't what my mail was about and Andrew 
> understood me correctly, so you could have too.

umm, yeah.  Ingo went a bit over the top there, IMO.

It boils down to: is sys_time() called at more or less than 1/2000th the
frequency of gettimeofday(), across the expected lifetime of 2.6.23 and
later?  Ingo has a couple of (surprising) examples where the sys_time()
call frequency _is_ high, but whether that will remain true across 2.6.23
and later is an open question.

How does mysql call sys_time() at all, if time(2) uses the vsyscall page??

Will contemporary-to-2.6.23-and-later mysqls do this?

All this isn't super-trivial silliness, either.  gettimeofday() is, for
many workloads, the kernel's most time-critical codepath bar none, I
believe.

