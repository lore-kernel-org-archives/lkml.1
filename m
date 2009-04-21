Return-Path: <linux-kernel-owner+w=401wt.eu-S1757232AbZDUDQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757232AbZDUDQn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 23:16:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753504AbZDUDQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 23:16:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:54168 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365AbZDUDQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 23:16:34 -0400
Date: Mon, 20 Apr 2009 20:18:26 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tim Abbott <tabbott@MIT.EDU>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <andi@firstfloor.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Jeff Arnold <jbarnold@MIT.EDU>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jon Masters <jonathan@jonmasters.org>
Subject: Re: [PATCH v2 0/4] Add support for compiling with
 -ffunction-sections -fdata-sections
Message-ID: <20090420201826.7c1f7f06@infradead.org>
In-Reply-To: <alpine.LFD.2.00.0904201730590.2199@localhost.localdomain>
References: <1238973278-31735-1-git-send-email-tabbott@mit.edu>
	<alpine.DEB.1.10.0904072019560.17274@vinegar-pot.mit.edu>
	<alpine.DEB.1.10.0904201255080.30705@vinegar-pot.mit.edu>
	<alpine.LFD.2.00.0904201637280.2199@localhost.localdomain>
	<alpine.DEB.1.10.0904202010220.30705@vinegar-pot.mit.edu>
	<alpine.LFD.2.00.0904201730590.2199@localhost.localdomain>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Apr 2009 17:35:32 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Mon, 20 Apr 2009, Tim Abbott wrote:
> > 
> > I assume you're only worried about toolchain problems for people
> > who are actually using the -ffunction-sections option.  Would it
> > help if the -ffunction-sections compilation option were marked as
> > experimental until proven otherwise?
> 
> The thing is, people will enable them, and then maybe the compiler 
> _appears_ to work, and things don't boot, and people spend tons of
> time chasing down somethign that just turns out to be a tools issue
> and not a kernel issue at all. And nobody happens to realize that
> what's up is that the person who reported the regression had enabled
> an experimental feature.
> 
> > If you're not willing to merge even an experimental option for 
> > -ffunction-sections, would you at least be willing to merge the
> > first three patches in the patch series?  Compiling with
> > -ffunction-sections would not be supported by the mainline kernel,
> > so any toolchain issues with it would not be your problem.  But any
> > vendor that wants to take advantage of -ffunction-sections would
> > still be able to use it without having to maintain 300 lines of
> > scattered changes to the kernel.
> 
> Are there any advantages outside of the size things?

we can probably drop a ton of ifdefs...


an alternative approach would be to have a special build target that
uses this, but makes a 2nd vmlinux, and then runs a diff on the symbols
against the regular one... and finds which functions got dropped.
Some patient soul can then go about and stick in ifdefs and stuff...

(or delete the totally not-used-by-anyone functions entirely)


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
