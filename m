Return-Path: <linux-kernel-owner+w=401wt.eu-S1761707AbXF0Svi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761707AbXF0Svi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 14:51:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755220AbXF0Sva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 14:51:30 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:54327 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335AbXF0Sv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 14:51:29 -0400
Date: Wed, 27 Jun 2007 13:51:25 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: James Morris <jmorris@namei.org>, Kyle Moffett <mrmacman_g4@mac.com>,
       Andreas Gruenbacher <agruen@suse.de>,
       Chris Wright <chrisw@sous-sol.org>,
       linux-security-module@vger.kernel.org, Andrew Morgan <agm@google.com>,
       Andrew Morton <akpm@google.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       lkml <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>, Greg KH <greg@kroah.com>,
       Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH try #2] security: Convert LSM into a static interface
Message-ID: <20070627185125.GA17059@sergelap.austin.ibm.com>
References: <20070617135239.GA17689@sergelap> <20070624220903.GB3723@sequoia.sous-sol.org> <Line.LNX.4.64.0706250031350.15974@localhost.localdomain> <200706252237.59226.agruen@suse.de> <11C35822-4E11-4365-BADE-C1AE41F15B50@mac.com> <20070626134712.GA8615@sergelap.austin.ibm.com> <B189F69D-B63E-4EE3-8580-39C8AFA97E5A@mac.com> <20070627134149.GB2679@sergelap> <Line.LNX.4.64.0706271031220.5258@localhost.localdomain> <20070627172102.GB16764@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070627172102.GB16764@sergelap.austin.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Serge E. Hallyn (serue@us.ibm.com):
> Quoting James Morris (jmorris@namei.org):
> > On Wed, 27 Jun 2007, Serge E. Hallyn wrote:
> > 
> > > Quoting Kyle Moffett (mrmacman_g4@mac.com):
> > > > This whole discussion boils down to 2 points:
> > > 
> > > Yes it can, but not the two you list.
> > > 
> > > >   1) As currently implemented, no LSM may be safely rmmod-ed
> > > 
> > > That's not the rationale for the patch, it's just some talking point you
> > > picked up.  The rationale for the patch is to prevent abuse.
> > 
> > This is not correct.  Reducing API abuse is simply a bonus.
> > 
> > The rationale for the patch is to remove unneeded infrastructure which 
> > complicates security by introducing the idea that the security module can 
> > be removed at all.
> > 
> > It was in response to your very own posting about the new capabilities 
> > code which would need to take this into account.
> 
> It's (IMO) by far not the optimal "solution"  :)  If it is felt a
> solution is really needed, re-introduction of a
> security_ops->module_exit hook and introduction of CAP_SYS_CAPDISABLE
> would be better.
> 
> But I'm well aware there are far too many (separate and not so separate)
> agendas driving this, and have no expectations of being able to stop it.
> 
> James, FWIW, I'm sorry I haven't had a chance to actually test the
> patch.  I'll try to get around to that today or at least this week.

Patch tests fine for me for expected capability behavior with lsm=n,
lsm=y, lsm=y+capability=y, lsm=y+selinux=y, and lsm=y+caps=y+selinux=y.

So while I'm opposed to the patch, it appears to be safe.

thanks,
-serge
