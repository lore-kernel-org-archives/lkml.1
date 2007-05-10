Return-Path: <linux-kernel-owner+w=401wt.eu-S1762603AbXEJWQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762603AbXEJWQR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 18:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755932AbXEJWQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 18:16:05 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:39326 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754954AbXEJWQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 18:16:04 -0400
Date: Fri, 11 May 2007 00:16:59 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: David Miller <davem@davemloft.net>, cw@f00f.org,
       linux-kernel@vger.kernel.org
Subject: Re: (hacky) [PATCH] silence MODPOST section mismatch warnings
Message-ID: <20070510221659.GA23915@uranus.ravnborg.org>
References: <20070510203417.GA23019@tuatara.stupidest.org> <20070510.135147.55726615.davem@davemloft.net> <20070510205427.GF29713@flint.arm.linux.org.uk> <20070510.140725.99616053.davem@davemloft.net> <20070510215920.GH29713@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070510215920.GH29713@flint.arm.linux.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2007 at 10:59:20PM +0100, Russell King wrote:
> On Thu, May 10, 2007 at 02:07:25PM -0700, David Miller wrote:
> > From: Russell King <rmk+lkml@arm.linux.org.uk>
> > Date: Thu, 10 May 2007 21:54:27 +0100
> > 
> > > I've not had one accurate one on ARM yet.
> > > 
> > > Here's another example:
> > > 
> > > WARNING: init/built-in.o - Section mismatch: reference to .init.text:
> > >  from .text between 'rest_init' (at offset 0x4c) and 'run_init_process'
> > > 
> > > from init/main.c:
> > > 
> > > static void noinline rest_init(void)
> > >         __releases(kernel_lock)
> > > 
> > > static void run_init_process(char *init_filename)
> > > 
> > > Clearly, it just does _not_ work.
> > 
> > Russell, the symbols are where the reference to an .init.text
> > section are coming from, they are not the .init.text function
> > being referenced itself.
> > 
> > It is saying that something between rest_init and run_init_processes,
> > which are not .init.text, are referencing an .init.text object.
> 
> I'd like to make a suggestion to make the wording of the warning
> clearer:
> 
> WARNING: init/built-in.o(.text+0x4c): section mismatch: reference to
>  .init.text:blah (between 'rest_init' and 'run_init_process')
> 
> I think this would remove the confusion - the primary information
> relating to where the reference is located is contained together
> ("init/built-in.o(.text+0x4c)") and the confusing "between" clause
> which seems to only be a hint becomes entirely secondary.
> 
> Moreover, it's similar to binutils warnings - which are of the form:
> 
> file:(section+offset): message

I like the new format - thanks!
Did you drop the ':' after the file on purpose?

[I am not familiar with this particular binutils warning so I did not
know an easy way to provoke it]

PS. Will apply the path you submitted in next mail.

	Sam
