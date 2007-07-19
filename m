Return-Path: <linux-kernel-owner+w=401wt.eu-S1759680AbXGSMYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759680AbXGSMYi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 08:24:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751381AbXGSMYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 08:24:30 -0400
Received: from smtp107.sbc.mail.mud.yahoo.com ([68.142.198.206]:46657 "HELO
	smtp107.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751192AbXGSMY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 08:24:29 -0400
X-YMail-OSG: 6FNg0VgVM1kFkpTzzl3tVlGwQ6qklbpYzG8qByQ1yLRYwsMtKHCzVJ2ZizhB5C5mWSDDwukbcw--
Date: Thu, 19 Jul 2007 07:24:24 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Christian Ehrhardt <lk@c--e.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Chris Wright <chrisw@sous-sol.org>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Stephen Smalley <sds@tycho.nsa.gov>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH try #3] security: Convert LSM into a static interface
Message-ID: <20070719122424.GA5186@vino.hallyn.com>
References: <Line.LNX.4.64.0707141233490.26711@d.namei> <20070718183503.541026f8.akpm@linux-foundation.org> <20070719073948.GI18840@lisa.in-ulm.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070719073948.GI18840@lisa.in-ulm.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Christian Ehrhardt (lk@c--e.de):
> On Wed, Jul 18, 2007 at 06:35:03PM -0700, Andrew Morton wrote:
> > On Sat, 14 Jul 2007 12:37:01 -0400 (EDT)
> > James Morris <jmorris@namei.org> wrote:
> > 
> > > Convert LSM into a static interface, as the ability to unload a security
> > > module is not required by in-tree users and potentially complicates the
> > > overall security architecture.
> > > 
> > > Needlessly exported LSM symbols have been unexported, to help reduce API
> > > abuse.
> > > 
> > > Parameters for the capability and root_plug modules are now specified
> > > at boot.
> > > 
> > > The SECURITY_FRAMEWORK_VERSION macro has also been removed.
> > 
> > I'd like to understand who is (or claims to be) adversely affected by this
> > change, and what their complaints (if any) will be.
> 
> I am currently loading and unloading a prototype like security module
> on a regular basis. The fact that such a module can be loaded and
> unloaded (albeit in an unsecure way) greatly simplifies development.
> Thus this change will adversely affect me and probably also others that
> develop LSMs.
> 
> Additionally deployment of and choice among legitimate security modules
> that may or may not (yet) be part of the main kernel tree is simplified by
> an option to load these security modules (e.g. at boot time) into a running

Right, the ability to boot with security.capability=disabpled (or
whatever) and then load a custom module without having to use a whole
new kernel is something I'm sure end-users want.

Especially since compiling a kernel which works with, say, a default
fedora install, with lvm etc, is not imo for a novice (where novice
!= security novice).

Maybe there are no out of tree modules being used this way, or maybe
there are but I just don't know about them, or maybe like James says
they are all illegal modules and kill a puppy every time they are
loaded.

> kernel. This way a distribution can provide AppArmor, SELinux, SecLevl and
> whatever as options very much in the same way that this works for a driver.
> 
> > Because I prefer my flamewars pre- rather than post-merge.
> 
> You asked for oppinion. I do not plan to engage in any flamewars.

Ditto.  There is very loud support for this - which may mean there is
*broad* support for it.

If we could get a few (non-afilliated :) people who work with
customers in the security field to tell us whether this is being
used, that would be very helpful.  Not sure how to get that.

Or we just apply the patch and see who yells  :)

-serge
