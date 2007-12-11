Return-Path: <linux-kernel-owner+w=401wt.eu-S1756362AbXLKUi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756362AbXLKUi1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 15:38:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753947AbXLKUiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 15:38:17 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48803 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753148AbXLKUiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 15:38:16 -0500
Date: Tue, 11 Dec 2007 12:37:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Martin Bligh" <mbligh@google.com>
Cc: linux-kernel@vger.kernel.org, "Andy Whitcroft" <apw@shadowen.org>,
       netdev@vger.kernel.org, Auke Kok <auke-jan.h.kok@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.24-rc4-mm1
Message-Id: <20071211123705.844aac24.akpm@linux-foundation.org>
In-Reply-To: <33307c790712110813h23def95dvd068b7226e9fcd36@mail.gmail.com>
References: <20071204211701.994dfce6.akpm@linux-foundation.org>
	<33307c790712110813h23def95dvd068b7226e9fcd36@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Dec 2007 08:13:52 -0800 "Martin Bligh" <mbligh@google.com> wrote:

> >
> >
> > - Lots of device IDs have been removed from the e1000 driver and moved
> > over
> >  to e1000e.  So if your e1000 stops working, you forgot to set
> > CONFIG_E1000E.
> >
> >
> Wouldn't it make sense to just default this to on if E1000 was on, rather
> than screwing
> everybody for no good reason (plus breaking all the automated testing, etc
> etc)?
> Much though I love random refactoring, it is fairly painful to just keep
> changing the
> names of things.

(cc netdev and Auke)

Yes, that would be very sensible.  CONFIG_E1000E should default to whatever
CONFIG_E1000 was set to.

> 
> I can't see this compile failure posted anywhere:
> http://test.kernel.org/results/IBM/126049/build/debug/stderr
> 
> arch/x86/vdso/vdso32/sigreturn.S: Assembler messages:
> arch/x86/vdso/vdso32/sigreturn.S:23: Error: suffix or operands invalid for `pop'
> arch/x86/vdso/vdso32/syscall.S:25: Error: suffix or operands invalid for `pop'
> make[1]: *** [arch/x86/vdso/vdso32/syscall.o] Error 1
> make: *** [arch/x86/vdso] Error 2

(cc Ingo and Thomas)

> 
> Nor this one:
> http://test.kernel.org/results/IBM/126096/build/debug/stderr
> 
> drivers/char/hvcs.c: In function â€˜hvcs_openâ€™:
> drivers/char/hvcs.c:1180: error: wrong type argument to unary exclamation mark
> 

(cc Greg)

Caused by gregkh-driver-kobject-convert-hvcs-to-use-kref-not-kobject.patch.
