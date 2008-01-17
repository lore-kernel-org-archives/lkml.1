Return-Path: <linux-kernel-owner+w=401wt.eu-S1753924AbYAQACR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924AbYAQACR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 19:02:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751438AbYAQACH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 19:02:07 -0500
Received: from smtp111.sbc.mail.mud.yahoo.com ([68.142.198.210]:33183 "HELO
	smtp111.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751384AbYAQACF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 19:02:05 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Z2+6y89JdAgjHrpF9E1zsree6ZXqaJtoYEbkPC1ihyHhQ/KDIMA3YlKoq2CxxRBdALneH1kCQ3A5eTtoVdidAsuwP+cfCaslhgH5ck6cuzZJQhBbD38dtYthmrOoMoVPN7s1pcDNMMdgbtN4WsWA+0a+D83DJIrOcekKNmUzed4=  ;
X-YMail-OSG: 2OvK.J0VM1lCPqLt3csgCoDD5evKl.bkmUEiMDCqfCLoR3Dq4cWLdhDnMpC9FuLiGhioHvvkQg--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Jan Beulich" <jbeulich@novell.com>
Subject: Re: 2.6.23-git Kconfig regression
Date: Wed, 16 Jan 2008 16:02:01 -0800
User-Agent: KMail/1.9.6
Cc: "Randy Dunlap" <rdunlap@xenotime.net>,
       "lkml" <linux-kernel@vger.kernel.org>
References: <20071020012245.9B3FB23A5F7@adsl-69-226-248-13.dsl.pltn13.pacbell.net> <20071019202140.ecbc4a0d.rdunlap@xenotime.net> <478DDC79.76E4.0078.0@novell.com>
In-Reply-To: <478DDC79.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801161602.01557.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 January 2008, Jan Beulich wrote:
> >>> Randy Dunlap <rdunlap@xenotime.net> 20.10.07 05:21 >>>
> 
> Sorry for only now getting back to this.
> 
> >On Fri, 19 Oct 2007 19:55:35 -0700 Randy Dunlap wrote:
> >
> ...
> 
> I'm pretty convinced that drivers/usb/gadget/Kconfig isn't really
> written properly:

That's orthogonal to whether that patch caused a regression,
of course.  The operational semantics have, except when they
were changed, been that it did what it needed to do.


> These prompt-less items should go after the choice (resulting 
> in the choice to become a boolean one),

Maybe -- such a change would have been OK as part of the patch
which changed the operational semantics of Kconfig.

For better or worse, operational semantics are most of what we
have to go by here.  It would be nice if they were cleanly and
clearly specified, like a Prolog engine ... just a simple little
tristate logic engine, provably correct, with some UI wrappers.
But that's not what we have today.


> these options are just pointless except for avoiding
> 
> #if defined(CONFIG_...) || defined(CONFIG_..._MODULE)'
> 
> in C sources.

Well, avoiding such error-prone idioms would seem good to me.
They're common enough, and nasty.  But that's not why those
mechanisms are there.


> In that latter case, the choice could become a tristate 
> one, allowing all of the selections to be built at once as modules
> (which really seems to be the way distro kernels would want to use
> it) or any one of them to be built in (the current behavior, except
> that at present even when using these as a module only a single
> one can be selected).

The requirements are that (a) just one peripheral controller
driver be selectable, and (b) that it be linked either
statically or dynamically.  Related, that for the gadget
drivers (c) none may be selected until the peripheral
controller driver they'll be used with is known, and either
(d1) one may be statically linked, or else (d2) any number
may be built as modules, with only one loaded at a time.

This stuff isn't for "distro" kernels; it's for embedded
environments of the "only this hardware exists" sort.
Space matters, and having small code matters.  Nobody has
been interested enough in an "embedded distro" model to
provide patches enabling such stuff.


> The second choice appears suspicious altogether - is it really that
> just any one of these items can be selected to be built into the
> kernel?

Yes.  We may want to change that requirement at some point,
but as a rule there can be no more than one upstream USB link
in systems certified as USB conformant.  Most hardware doesn't
even allow it.

Certainly, *right now* we don't support multiple upstream
links, and that's been true for as long as that driver stack
has existed.

- Dave


> Bottom line is, in order to suggest an appropriate adjustment to this
> Kconfig file I need clarification on its intentions. Meanwhile I'll scan
> the tree for other suspicious choices...
> 
> Thanks, Jan
> 


