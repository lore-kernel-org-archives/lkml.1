Return-Path: <linux-kernel-owner+w=401wt.eu-S1759169AbXFZSUB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759169AbXFZSUB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 14:20:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757282AbXFZSTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 14:19:52 -0400
Received: from canuck.infradead.org ([209.217.80.40]:43282 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756972AbXFZSTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 14:19:51 -0400
Date: Tue, 26 Jun 2007 11:18:23 -0700
From: Greg KH <greg@kroah.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Adrian Bunk <bunk@stusta.de>, "Serge E. Hallyn" <serge@hallyn.com>,
       James Morris <jmorris@namei.org>, Andreas Gruenbacher <agruen@suse.de>,
       Chris Wright <chrisw@sous-sol.org>,
       linux-security-module@vger.kernel.org, Andrew Morgan <agm@google.com>,
       Andrew Morton <akpm@google.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       lkml <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>, Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH try #2] security: Convert LSM into a static interface
Message-ID: <20070626181823.GA5602@kroah.com>
References: <20070617135239.GA17689@sergelap> <20070624220903.GB3723@sequoia.sous-sol.org> <Line.LNX.4.64.0706250031350.15974@localhost.localdomain> <200706252237.59226.agruen@suse.de> <Line.LNX.4.64.0706251712570.24003@localhost.localdomain> <20070626035731.GA16313@vino.hallyn.com> <20070626131519.GH1094@stusta.de> <20070626140644.GB8615@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070626140644.GB8615@sergelap.austin.ibm.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2007 at 09:06:44AM -0500, Serge E. Hallyn wrote:
> Quoting Adrian Bunk (bunk@stusta.de):
> > On Mon, Jun 25, 2007 at 10:57:31PM -0500, Serge E. Hallyn wrote:
> > > Quoting James Morris (jmorris@namei.org):
> > > > On Mon, 25 Jun 2007, Andreas Gruenbacher wrote:
> > > > 
> > > > > It's useful for some LSMs to be modular, and LSMs which are y/n options won't 
> > > > > have any security architecture issues with unloading at all. 
> > > > 
> > > > Which LSMs?  Upstream, there are SELinux and capabilty, and they're not 
> > > > safe as loadable modules.
> > > > 
> > > > > The mere fact 
> > > > > that SELinux cannot be built as a module is a rather weak argument for 
> > > > > disabling LSM modules as a whole, so  please don't.
> > > > 
> > > > That's not the argument.  Please review the thread.
> > > 
> > > The argument is 'abuse', right?
> > > 
> > > Abuse is defined as using the LSM hooks for non-security applications,
> > > right?
> > > 
> > > It seems to me that the community is doing a good job of discouraging
> > > such abuse - by redirecting the "wrong-doers" to implement proper
> > > upstream solutions, i.e. taskstats, the audit subsystem, etc.
> > > 
> > > Such encouragement seems a far better response than taking away freedoms
> > > and flexibility from everyone.
> > 
> > We are not living in a world where everyone had good intentions...
> 
> Oh no, i took a wrong turn somewhere  :)
> 
> > For _some_ "wrong-doers" your approach works.
> > 
> > But how do you convince the "wrong-doers" who do things like putting 
> > MODULE_LICENSE("GPL") into their binary-only modules and who ignore you 
> > and get away because noone sues them?
> 
> Do these really exist?

Yes they do.

> Maybe noone sues them because noone knows who they are...

Maybe no one knows because the people doing the legal action against
them are trying to be nice and do it quietly.

And legal action takes time, it is quite slow going unfortunatly.

Heck, I've seen code that is even properly licensed under the GPL abuse
this security layer for things it was not ment to do at all, and that
stuff comes from _very_ big companies that really should know better...

So I agree that we should unexport it.  It will make people who want to
abuse the interface at least think twice about it.

thanks,

greg "I want to mark structures read-only" k-h
