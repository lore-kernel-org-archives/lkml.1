Return-Path: <linux-kernel-owner+w=401wt.eu-S1755117AbZJEX27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117AbZJEX27 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 19:28:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754611AbZJEX27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 19:28:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50590 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754505AbZJEX26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 19:28:58 -0400
Date: Mon, 5 Oct 2009 16:27:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stanislav Brabec <utx@penguin.cz>
Cc: linux@arm.linux.org.uk, linux-kernel@vger.kernel.org, gregkh@suse.de,
       alan@lxorguk.ukuu.org.uk, s.hauer@pengutronix.de, saxena@laptop.org,
       gregkh@suse.de
Subject: Re: [PATCH] serial-core: resume serial hardware with
 no_console_suspend
Message-Id: <20091005162741.599a1be9.akpm@linux-foundation.org>
In-Reply-To: <1253872547.13257.18.camel@hammer.suse.cz>
References: <1253021938.6597.16.camel@hammer.suse.cz>
	<20090924170503.37cbe4ed.akpm@linux-foundation.org>
	<20090925073617.GA5856@n2100.arm.linux.org.uk>
	<1253872547.13257.18.camel@hammer.suse.cz>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Sep 2009 11:55:47 +0200
Stanislav Brabec <utx@penguin.cz> wrote:

> Russell King - ARM Linux wrote:
> > On Thu, Sep 24, 2009 at 05:05:03PM -0700, Andrew Morton wrote:
> > > On Tue, 15 Sep 2009 15:38:58 +0200
> > > Stanislav Brabec <utx@penguin.cz> wrote:
> > > 
> > > > Hardware may need re-initialization to get serial port working after
> > > > resume. It does not happen with no_console_suspend. Attached patch
> > > > attempts to fix it.
> > > > 
> > > > The patch attempts to keep hardware running before suspend and run
> > > > hardware re-initialization after resume. Maybe simpler approach is
> > > > possible.
> > > 
> > > The patch doesn't apply any more and seems like a rather hacky thing to do.
> 
> Yes, but no_console_suspend itself is a bit hacky. You need to save
> console state but keep it running as long as possible afterwards and
> resume it after return from the sleep.
> 
> I was not sure, what exactly should be skipped and what must be run, so
> I experimented a bit.
> 
> Not calling hardware suspend/resume (current implementation) breaks
> serial port in hardware that need resume.
> 
> Calling of resume without suspend seems to be dangerous. Not calling
> suspend at all and standard initialization on resume would probably
> reset the port setting and maybe cause memory leak.
> 
> > > It appears that you have specific serial hardware which doesn't resume
> > > correctly?  If so, that's a bug, so how about we start with a bug
> > > report/description?
> 
> The hardware resumes correctly. But no_console_suspend breaks its
> resume.
> 
> > It's something that I did point out when the no_console_suspend patch
> > appeared, but I was overruled/ignored.
> > 
> > The problem is that on ARM hardware, there is no BIOS to re-initialize
> > hardware.  The kernel has to do restore the entire system hardware
> > state upon resume.  Unfortunately, no_console_suspend not only prevents
> > the console from being suspended but _also_ resumed.
> > 
> > The result of that is the console UART is left in a totally uninitialized
> > state.
> 
> Exactly, my ARM hardware is PXA270 on Zaurus SL-C3200.

hm, well.  We can't go much further without a patch and the one you
sent won't apply.  Can you please redo against current mainline and
resend?

Do you expect that my some miracle, your patch will also fix
http://lkml.org/lkml/2009/9/30/164 ?


