Return-Path: <linux-kernel-owner+w=401wt.eu-S932344AbYBMPfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932344AbYBMPfS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 10:35:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764949AbYBMPev
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 10:34:51 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:56105 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763744AbYBMPeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 10:34:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=SH6v1+sNH/NLlQMyyIfKRInafvqk1zveGEvH2ZC85fATxS3vzg/jNlIajSAndgK275AcprhW1zWQ+4x0cE8qQ7Ttcn30NbMoUNtXppjX8cxcXkRrhjh8q2fBEVUqd/AaKxsh6ItAULnEtCHC26WPR+untTPbJPLFtq97i96VpUM=
Date: Wed, 13 Feb 2008 09:33:14 -0600
From: Josh Boyer <jwboyer@gmail.com>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       viro@zeniv.linux.org.uk
Subject: Re: latest list of unused Kconfig variables
Message-ID: <20080213093314.3220e29d@zod.rchland.ibm.com>
In-Reply-To: <alpine.LFD.1.00.0802131002310.28617@localhost.localdomain>
References: <alpine.LFD.1.00.0802130353530.31183@localhost.localdomain>
	<20080213073242.5c069c25@zod.rchland.ibm.com>
	<alpine.LFD.1.00.0802131002310.28617@localhost.localdomain>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2008 10:07:27 -0500 (EST)
"Robert P. J. Day" <rpjday@crashcourse.ca> wrote:

> On Wed, 13 Feb 2008, Josh Boyer wrote:
> 
> > On Wed, 13 Feb 2008 03:56:34 -0500 (EST)
> > "Robert P. J. Day" <rpjday@crashcourse.ca> wrote:
> 
> > >   now that 2.6.25-rc1 is out, i can start updating the output from
> > > my scanning scripts.  the first updated output is the list of
> > > currently unused Kconfig variables -- variables that are defined
> > > in some Kconfig file somewhere but appear to be entirely unused
> > > throughout the source tree.
> > >
> > >   latest output here, sorted by architecture:
> > >
> > > http://www.crashcourse.ca/wiki/index.php/Unused_CONFIG_variables
> > >
> > > as always, there will probably be some false positives for one
> > > reason or another.
> > >
> > >   output from the other scanning scripts will be up in short order.
> >
> > You have lots of false positives (or something) for arch/powerpc.
> > Seems your script picked up #define names and comments that happen
> > to match a Kconfig variable?
> 
> it always will, given the proclivity of some folks to define their own
> variables with a "CONFIG_" prefix.  as i point out on the wiki page, i
> make no attempt to cull that list, i just print it as is, and readers
> will have to peruse the list carefully to see what's meaningful and
> what isn't.

OK.  Well all of your hits for 405EX, 440GRX, 440SPe, and
WANT_DEVICE_TREE in arch/powerpc seem bogus.  I dunno if you prune
those when reported or not.

> > And you have false positives on several CPU variables, as they are
> > used within Kconfig files themselves to select different sets of
> > options.
> 
> yes, i know ... perhaps there's a simple way to filter those out but,
> at the moment, it's pure brute force.  i'm guessing i could make that
> script a bit smarter but it probably isn't worth the investment in
> time.  law of diminishing returns and all that.

Maybe.  If the same false positives keep showing up people might ignore
it.  I won't, but others might.

> > For arch/ppc, the WANT_EARLY_SERIAL stuff was added by Al to fix those
> > boards that unconditionally called early_serial_setup by selecting
> > SERIAL_8250 in commit f08243a491f3e21feabbb04476a03fb0cbc975ff.  Al,
> > couldn't we just select SERIAL_8250 right in the board config
> > instead?
> >
> > Of course, arch/ppc is dying soon-ish anyway so we might not even
> > bother.
> 
> if that's the case, i can just stop scanning that entire directory.

It's going away in June, per feature-removal-schedule.  I will still fix
actual bugs until then, but not much else.

josh
