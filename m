Return-Path: <linux-kernel-owner+w=401wt.eu-S1758739AbXFZSQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758739AbXFZSQR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 14:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752379AbXFZSP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 14:15:59 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:39678 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756852AbXFZSP6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 14:15:58 -0400
Date: Tue, 26 Jun 2007 10:53:29 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, "Serge E. Hallyn" <serge@hallyn.com>,
       James Morris <jmorris@namei.org>, Andreas Gruenbacher <agruen@suse.de>,
       Chris Wright <chrisw@sous-sol.org>,
       linux-security-module@vger.kernel.org, Andrew Morgan <agm@google.com>,
       Andrew Morton <akpm@google.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       lkml <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>, Greg KH <greg@kroah.com>,
       Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH try #2] security: Convert LSM into a static interface
Message-ID: <20070626155329.GA24038@sergelap.ibm.com>
References: <20070617135239.GA17689@sergelap> <20070624220903.GB3723@sequoia.sous-sol.org> <Line.LNX.4.64.0706250031350.15974@localhost.localdomain> <200706252237.59226.agruen@suse.de> <Line.LNX.4.64.0706251712570.24003@localhost.localdomain> <20070626035731.GA16313@vino.hallyn.com> <20070626131519.GH1094@stusta.de> <20070626140644.GB8615@sergelap.austin.ibm.com> <20070626145929.GI1094@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070626145929.GI1094@stusta.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Adrian Bunk (bunk@stusta.de):
> On Tue, Jun 26, 2007 at 09:06:44AM -0500, Serge E. Hallyn wrote:
> > Quoting Adrian Bunk (bunk@stusta.de):
> > > On Mon, Jun 25, 2007 at 10:57:31PM -0500, Serge E. Hallyn wrote:
> > > > Quoting James Morris (jmorris@namei.org):
> > > > > On Mon, 25 Jun 2007, Andreas Gruenbacher wrote:
> > > > > 
> > > > > > It's useful for some LSMs to be modular, and LSMs which are y/n options won't 
> > > > > > have any security architecture issues with unloading at all. 
> > > > > 
> > > > > Which LSMs?  Upstream, there are SELinux and capabilty, and they're not 
> > > > > safe as loadable modules.
> > > > > 
> > > > > > The mere fact 
> > > > > > that SELinux cannot be built as a module is a rather weak argument for 
> > > > > > disabling LSM modules as a whole, so  please don't.
> > > > > 
> > > > > That's not the argument.  Please review the thread.
> > > > 
> > > > The argument is 'abuse', right?
> > > > 
> > > > Abuse is defined as using the LSM hooks for non-security applications,
> > > > right?
> > > > 
> > > > It seems to me that the community is doing a good job of discouraging
> > > > such abuse - by redirecting the "wrong-doers" to implement proper
> > > > upstream solutions, i.e. taskstats, the audit subsystem, etc.
> > > > 
> > > > Such encouragement seems a far better response than taking away freedoms
> > > > and flexibility from everyone.
> > > 
> > > We are not living in a world where everyone had good intentions...
> > 
> > Oh no, i took a wrong turn somewhere  :)
> > 
> > > For _some_ "wrong-doers" your approach works.
> > > 
> > > But how do you convince the "wrong-doers" who do things like putting 
> > > MODULE_LICENSE("GPL") into their binary-only modules and who ignore you 
> > > and get away because noone sues them?
> > 
> > Do these really exist?  Maybe noone sues them because noone knows who
> > they are...
> 
>    http://lwn.net/Articles/82306/

LinuxAnt?  Are they using LSM?

It looks to me like this patch will do nothing about them.

> > But - note that you've changed completely the meaning of 'abuse'.
> > So mine was wrong?
> 
> Technical and legal abuse are related.

True but going by your logic we could remove support for modules period
to prevent legal abuse by non-gpl modules.

> For GPL'ed modules you might assume good faith and get the authors to do 
> things in a proper way. Authors of legally questionable modules that 
> cheat in many ways are quite a different issue.
> 
> > > The spirit of the GPLv2 is to defend the freedom of the software 
> > > (different from the spirit of the BSD licence), and considering that 
> > > there aren't many people defending the GPLv2 copyright of the Linux 
> > > kernel at court against abusers, making it harder for people to do the 
> > > abuse might not be the worst choice...
> > 
> > Well, but you seem to be saying that the license means squat, and
> > resorting to making things inconvenient rather than illegal.
> 
> No, the point is that there's no reason for making illegal things 
> convenient.

But no, the point is that that you are making legal things very
inconvenient.

> I'm not talking about removing things that are used inside the kernel, 

Since capabilities can currently be compiled as a module, you are.
(Though that sounds weird, so maybe I'm misreading what you are saying)

> but what you call "freedom" can also be called "hooks for possible abuse".

Yup, that is true.

> Additionally, it both makes the kernel bigger for everyone and requires 
> proper handling of loading/unloading in the security architecture.
> 
> > Now I guess if it really is accepted that that's the way it should be,
> > then this patch will go in.
> > 
> > -serge
> 
> cu
> Adrian

thanks,
-serge
